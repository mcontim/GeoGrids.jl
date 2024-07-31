# Basic generator for regular lattice
function _gen_regular_lattice(dx::T, dy, ds; x0=zero(T), y0=zero(T), M::Int=100, N::Int=M) where {T}
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
    _adapted_icogrid

The `_adapted_icogrid` function generates an icosahedral grid with a specified
radius. It defines the separation angle for the icosahedral grid using a
correction factor to adapt the cell centers' distances, ensuring the grid is
appropriate for the desired scale.

## Arguments
- `radius::Number`: The radius used to define the separation angle for the \
icosahedral grid. This radius helps determine the distance between the grid \
points.

## Keyword Arguments
- `correctionFactor=1.2`: The correction factor used to adapt the cell centers' \
distances to ensure the grid is appropriate for the desired scale.
    
## Returns
- `grid`: The generated icosahedral grid based on the calculated separation \
angle. The specific structure and format of the returned grid depend on the \
`icogrid` function being used.
"""
function _adapted_icogrid(radius::Number; correctionFactor=6/5)
    # Define the separation angle for the icosahedral grid in a similar way as for the hexagonal grid using a correction factor 1.2 to adapt the cell centers distances (from old MATLAB grid).
    # The correction factor would be √3 if the original hex grid approach was used.
    sepAng = radius * correctionFactor / constants.Re_mean |> rad2deg

    return icogrid(; sepAng)
end

function gen_cell_layout(region::GlobalRegion, radius::Number, type::ICO)
    return _adapted_icogrid(radius; correctionFactor=type.correction)
end

function gen_cell_layout(region::GlobalRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function gen_cell_layout(region::LatBeltRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function gen_cell_layout(region::GeoRegion, radius::Number, type::HEX; hex_direction::Symbol=:pointy, kwargs_lattice...)
    ## Find the domain center as seed for the cell grid layout.
    domain = extract_countries(region)[1] # The indicization is used to extract directly the Multi or PolyArea from the view
    centre = let
        c = if domain isa Multi
            idxMain = findmax(x -> length(vertices(x)), domain.geoms)[2] # Find the PolyArea with the most vertices. It is assumed also to be the largest one so the main area of that country to be considered for the centroid computation.
            c = centroid(domain.geoms[idxMain]) # Find the centroid of the main PolyArea to be used as grid layout seed.
        elseif domain isa PolyArea
            centroid(domain)
        else
            error("Unrecognised type of GeoRegion domain...")
        end
        (; x, y) = c.coords
        SVector(x |> ustrip, y |> ustrip) # SVector of lon-lat in deg
    end

    ## Generate the lattice centered in 0,0.
    spacing = radius * √3 / constants.Re_mean # spacing (angular in rad) between lattice points, considering a sphere of radius equivalent to the Earth mean radius.
    lattice = gen_hex_lattice(spacing, hex_direction, rad2deg; kwargs_lattice...)

    ## Re-center the lattice around the seed point.
    new_lattice = map(lattice) do point
        new = point + centre # This SVector is still in the order lon-lat
        lat, lon = _wrap_latlon(new[2], new[1])
        SimpleLatLon(lat, lon)
    end

    return filter_points(new_lattice, region)
end

function gen_cell_layout(region::GeoRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

function gen_cell_layout(region::PolyRegion, radius::Number, type::HEX)
    ## Find the domain center as seed for the cell grid layout.
    centre = centroid(region.domain)
    (; x, y) = centre.coords
    SVector(x |> ustrip, y |> ustrip) # SVector of lon-lat in deg

    ## Generate the lattice centered in 0,0.
    spacing = radius * √3 / constants.Re_mean # spacing (angular in rad) between lattice points, considering a sphere of radius equivalent to the Earth mean radius.
    lattice = gen_hex_lattice(spacing, hex_direction, rad2deg; kwargs_lattice...)

    ## Re-center the lattice around the seed point.
    new_lattice = map(lattice) do point
        new = point + centre # This SVector is still in the order lon-lat
        lat, lon = _wrap_latlon(new[2], new[1])
        SimpleLatLon(lat, lon)
    end

    return filter_points(new_lattice, region)
end

function gen_cell_layout(region::Union{LatBeltRegion, GeoRegion, PolyRegion}, radius::Number, type::ICO)
    grid = _adapted_icogrid(radius; correctionFactor=type.correction)

    return filter_points(grid, region)
end

function gen_cell_layout(region::PolyRegion, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end