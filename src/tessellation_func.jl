# Basic generator for regular lattice
function _gen_regular_lattice(dx::T, dy, ds; x0=zero(T), y0=zero(T), M::Int=70, N::Int=M) where {T}
    # Function to generate x position as function of row,column number m,n
    x(m, n) = m * dx + n * ds + x0
    # Function to generate y position as function of row,column number m,n
    y(n) = n * dy + y0
    # Generate the elements. For each row, shift the columns to always have the search domain around x=0
    gen = [SVector(x(m - round(Int, n * ds / dx), n), y(n)) for n in -N:N, m in -M:M]

    return gen
end

# Hex Lattice
"""
	gen_hex_lattice(spacing, direction = :pointy; kwargs...)
Generate a hexagonal lattice of points with equal distance `spacing` between neighboring points.

The generated hexagonal lattice will have distance between points on the same
row/column that will depend on the second argument `direction`:

If `direction = :pointy`, neighboring points on the same row (points which
have the same `y` coordinate) will be at a distance `spacing` from one another, while
points on the same column (sharing the `x` coordinate) will have a distance
equivalent to `√3 * spacing`.

If `direction = :flat`, the distance will be reversed, so points on the same
column will have a distance equivalent to `spacing` while points on the same row
will have a distance equivalent to `√3 * spacing`.

## Arguments
- `spacing`: spacing between neighboring points
- `direction`: specifies the direction of minimum distance between neighboring\
points. Defaults to `:pointy`.
"""
function gen_hex_lattice(spacing, direction=:pointy, f::Function=identity; kwargs...)
    coeffs = if direction === :pointy # Hexagon orientation with the pointy side up
        1.0, √3 / 2, 0.5
    elseif direction === :flat # Hexagon orientation with the flat side up
        √3, 0.5, √3 / 2
    else
        error("Invalid value for `direction`, it must be either `:pointy` or `:flat`")
    end

    dx, dy, ds = spacing .* coeffs

    lat = _gen_regular_lattice(dx, dy, ds; kwargs...)

    return map(x -> f.(x), lat)
end

"""
    _gen_hex_vertices(cx::Number, cy::Number, r::Number, direction::Symbol=:pointy) -> Vector{Number}

The `_gen_hex_vertices` function generates the vertices of a hexagon
centered at a given point `(cx, cy)` with a specified radius `r`. The function
allows for two orientations of the hexagon: "pointy" (vertex pointing upwards)
or "flat" (edge pointing upwards).

## Arguments
- `cx::Number`: The x-coordinate of the center of the hexagon.
- `cy::Number`: The y-coordinate of the center of the hexagon.
- `r::Number`: The radius of the hexagon, which is the distance from the center \
to any vertex.
- `direction::Symbol`: The orientation of the hexagon. It can be either \
`:pointy` for a hexagon with a vertex pointing upwards or `:flat` for a \
hexagon with an edge pointing upwards. The default value is `:pointy`.

## Returns
- `vertices::Vector{Tuple{Number, Number}}`: A vector of tuples, where each \
tuple represents the `(x, y)` coordinates of a vertex of the hexagon. The \
vector contains 7 tuples, with the last vertex being the same as the first to \
close the hexagon.
"""
function _gen_hex_vertices(cx::Number, cy::Number, r::Number, direction::Symbol=:pointy, f::Function=identity)
    vertices = if direction === :pointy
        [(cx + r * sin(2π * i / 6), cy + r * cos(2π * i / 6)) for i in 0:6]
    else
        [(cx + r * cos(2π * i / 6), cy + r * sin(2π * i / 6)) for i in 0:6]
    end

    return map(x -> f.(x), vertices)
end



# - Add multiple dispatch for different types of grid ICO, HEX, H3
# - Add multiple dispatch for different types of Regions
function gen_cell_layout(initLayout::TilingInit; hex_direction::Symbol=:pointy)
    (; radius, type, region) = initLayout
    # For SimpleLatLon consider that lon=x and lat=y (it's importand for the operations with 2D points/vec)
    centre = if region isa GeoRegion
        dmn = extract_countries(region)[1] # The indicization is used to extract directly the Multi or PolyArea from the view
        c = if dmn isa Multi
            idxMain = findmax(x -> length(vertices(x)), dmn.geoms)[2] # Find the PolyArea with the most vertices. It is assumed also to be the largest one so the main area of that country to be considered for the centroid computation.
            centroid(dmn.geoms[idxMain]) # Find the centroid of the main PolyArea to be used as grid layout seed.
        elseif dmn isa PolyArea
            centroid(dmn)
        else
            error("Unrecognised type of GeoRegion domain...")
        end
    elseif region isa PolyRegion
        centroid(region.domain)
    elseif region isa GlobalRegion

    end    

    d = first(dmn)
    c = centroid(d)
    
    # Create grid layout
    if initLayout.type == :HEX
        return gen_hex_lattice(initLayout.radius, hex_direction)
    elseif initLayout.type == :ICO

    else
        error("H3 tassellation is not yet implemented...")
    end

end

function _gen_cell_layout(region::GlobalRegion, radius::Number, type::ICO)

end

function _gen_cell_layout(region::GlobalRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function _gen_cell_layout(region::LatBeltRegion, radius::Number, type::ICO)

end

function _gen_cell_layout(region::LatBeltRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function _gen_cell_layout(region::GeoRegion, radius::Number, type::HEX; hex_direction::Symbol=:pointy, kwargs_lattice...)
    ## Find the domain center as seed for the cell grid layout.
    domain = extract_countries(region)[1]; # The indicization is used to extract directly the Multi or PolyArea from the view
    centre = let
        c = if domain isa Multi
            idxMain = findmax(x -> length(vertices(x)), domain.geoms)[2] # Find the PolyArea with the most vertices. It is assumed also to be the largest one so the main area of that country to be considered for the centroid computation.
            c = centroid(domain.geoms[idxMain]) # Find the centroid of the main PolyArea to be used as grid layout seed.
        elseif domain isa PolyArea
            centroid(domain)
        else
            error("Unrecognised type of GeoRegion domain...")
        end
        (;x,y) = c.coords
        SVector(x |> ustrip, y |> ustrip) # SVector of lon-lat in deg
    end
    
    ## Generate the lattice centered in 0,0.
    spacing = radius*√3/constants.Re_mean # spacing (angular in rad) between lattice points, considering a sphere of radius equivalent to the Earth mean radius.
    lattice = gen_hex_lattice(spacing, hex_direction, rad2deg; kwargs_lattice...)

    ## Re-center the lattice around the seed point.
    new_lattice = map(lattice) do point
        new = point + centre # This SVector is still in the order lon-lat
        lat,lon = _wrap_latlon(new[2], new[1])
        SimpleLatLon(lat,lon)
    end

    return filter_points(new_lattice, region)
end

function _gen_cell_layout(region::GeoRegion, radius::Number, type::ICO)

end

function _gen_cell_layout(region::GeoRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function _gen_cell_layout(region::PolyRegion, radius::Number, type::HEX)

end

function _gen_cell_layout(region::PolyRegion, radius::Number, type::ICO)

end

function _gen_cell_layout(region::PolyRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function _wrap_latlon(lat, lon)
    # Normalize lat to the range [-180, 180)
    lat = rem(lat, 360, RoundNearest)
    lon = rem(lon, 360, RoundNearest)
    
    # Wrap to the range [-90, 90] and make the longitude "jump"
    if lat > 90
        lat = 180 - lat
        lon = lon + 180
        lon = rem(lon, 360, RoundNearest)
    elseif lat < -90
        lat = -180 - lat
        lon = lon + 180
        lon = rem(lon, 360, RoundNearest)
    end

    return lat, lon
end













# satAlt, minEl
# function make_cells!(cellsInit; em::EllipsoidModel)    
#     ellipsoid = get_ellipsoid(em)

#     ## Earth-Space Geometry ----------------------------------------------------------------------------------
#     ρ = asin(ellipsoid.a ./ (ellipsoid.a + cellsInit.satAlt)) # [rad]
#     η = asin(cosd(cellsInit.minEl)*sin(ρ)) # [rad]
#     λ = π/2 - η + deg2rad(cellsInit.minEl) # [rad]

#     if cellsInit.maxLatCovered == 999
#         if cellsInit.satIncl == 999
#             error("Satellite orbital plane reference inclination or Max LAT to be covered must be specified.")
#         else
#             @warn("maxLatCovered is not specified. Automatically computed based on the other cellsInit paramenters.")
#             cellsInit.maxLatCovered = cellsInit.satIncl + rad2deg(λ)
#         end
#     end

#     # Find earth angle for scan cell at sizing elevation angle
#     scanAng = asin(cosd(cellsInit.minEl)*sin(ρ)); # 5-56b [1]
#     satAntBW = deg2rad(cellsInit.bwBoresightSat)/cos(scanAng); # 1.63 [2] [radians] 
#     # Lambda@(scan+beamScan_radius) - Lambda@scanSizing = Earth_centralAngle for the cell
#     # Half cone angle of the cell at Eart h centre
#     cellEarthAng = (π/2 - acos(sin(scanAng+satAntBW/2)/sin(ρ)) - (scanAng+satAntBW/2)) - (π/2 - acos(sin(scanAng)/sin(ρ)) - (scanAng)) # 5-27 [1] [rad] take in consideration both antenna scan angle distortion and geometrical distortion
#     # //COMMENT: (sphere_surface_area/spherical_cap_area), (4*pi*R^2)/(2*pi*R^2*(1-cos(central_angle))) [https://en.wikipedia.org/wiki/Spherical_cap] a correction factor of 1.2 is considered for cell overlap
#     Ncells = 1.2 * 4π ./ (2π * (1 .- cos.(cellEarthAng))) # approximate number of cells required to cover the are of interest

#     ## Generate cells Centres --------------------------------------------------------------------------------    
#     if cellsInit.gridType == :leg   
#         geoCoord = celldeploy_legacy(Ncells)    
#     else
#         geoCoord = sort(vec(fibonaccigrid(;N=Ncells)), by = x -> x[2]) # Sort cells positions by LAT  
#     end

#     cells = map(geoCoord) do p
#         cell_lla = LLA(reverse(p)...) # Default altitude 0.0
#         cell_ecef = get_ecef(cell_lla; ellipsoid) 
#         Cell(position = CellPosition(cell_ecef, cell_lla))
#     end	

#     # Update cellsInit with the sinzing angles
#     # cellsInit can be modified because passed by reference (because it is a mutable struct)
#     cellsInit.satScanAng   = scanAng
#     cellsInit.satAntBW     = satAntBW
#     cellsInit.cellEarthAng = cellEarthAng

#     return cells
# end


# function celldeploy_legacy(N)
#     # //UGLY: improve code, avoid push!() 
#     a = 4π*1^2/N # surface of a cell (spherical cap) on a unit sphere
#     M_Theta = round(π/sqrt(a)) # how many circles are in pi (half circle), total number of circle from 90:-90 //NOTE: maybe you can use something different than sqrt(a) like 2*theta of the spherical cap
#     # M_Theta looks like the squaring of the circle sqrt(a) is the edge of the equiarea square of that circle. So it is like to consider how many edge of the square you can accomodate in -90:90 [https://en.wikipedia.org/wiki/Squaring_the_circle]
#     # d_theta and d_phi are basically the diameter of each cell, represented as the Earth central angle
#     d_theta = π/M_Theta # represent 2*theta of the spherical cap
#     d_phi = a/d_theta # ? it's equal to d_theta

#     cellCoord = []
#     for i = 0:M_Theta-1 # from 90 to -90 LAT
#         Theta_ThisTheta = π*(i+0.5)/M_Theta # center of the m-th tier (theta angle from Earth center - spherical cap like) of circles (steps of LAT), you need to normalize on the total number of circle from 90:-90 (M_Theta)
#         M_Phi = round(2π*sin(Theta_ThisTheta)/d_phi) # number of circles for this LAT tier (360, all the LON) - circonference/cell_diameter
#         for j = 0:M_Phi-1
#             Phi_ThisTheta = 2π*j/M_Phi # position of the centers (steps of LON)  
#             # Wrap LON in -180:180
#             Phi_ThisTheta > π ? temp_lon=Phi_ThisTheta-2π : temp_lon=Phi_ThisTheta    
#             push!(cellCoord, SVector(temp_lon, π/2-Theta_ThisTheta)) # lon-lat
#         end
#     end

#     return cellCoord
# end





# function plot_cells_geo(cellTuple...; N=1000, title="Cells Position GEO Map", camera::Symbol=:twodim)
# 	# Check the number of Cells to be plotted, if to high plot only centers, otherwise also the contour
# 	count = 0
# 	for i ∈ eachindex(cellTuple)
# 		count += length(cellTuple[i][1])
# 	end

# 	if count < N 
# 		# //FIX: implement function similar to MATLAB scircle1
# 	else
# 		# Plot only markers for the cell centers
# 		markers = []
# 		for p ∈ eachindex(cellTuple)
# 			push!(markers,
# 				scattergeo(;
# 					lat = map(x -> rad2deg(x.lat), cellTuple[p][1]),
# 					lon = map(x -> rad2deg(x.lon), cellTuple[p][1]),
# 					mode = "markers",
# 					marker_size = 5,
# 					marker_color = cellTuple[p][2]			
# 				)
# 			)
# 		end
# 	end

# 	if camera == :threedim
# 		projection = "orthographic"
# 	else
# 		projection = "natural earth"
# 	end

# 	# Create the geo layout
# 	layout = Layout(
# 		geo =  attr(
# 			projection =  attr(
# 			type =  "robinson",
# 			),
# 			showocean =  true,
# 			# oceancolor =  "rgb(0, 255, 255)",
# 			oceancolor =  "rgb(255, 255, 255)",
# 			showland =  true,
# 			# landcolor =  "rgb(230, 145, 56)",
# 			landcolor =  "rgb(217, 217, 217)",
# 			showlakes =  true,
# 			# lakecolor =  "rgb(0, 255, 255)",
# 			lakecolor =  "rgb(255, 255, 255)",
# 			showcountries =  true,
# 			lonaxis =  attr(
# 				showgrid =  true,
# 				gridcolor =  "rgb(102, 102, 102)"
# 			),
# 			lataxis =  attr(
# 				showgrid =  true,
# 				gridcolor =  "rgb(102, 102, 102)"
# 			)
# 		),
# 		title = title;
# 		geo_projection_type = projection
# 	)

# 	plotly_plot([markers...],layout)
# end