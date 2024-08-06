"""
    _gen_regular_lattice(dx::T, dy, ds; x0=zero(T), y0=zero(T), M::Int=100, N::Int=M) where {T}

The `_gen_regular_lattice` function generates a regular lattice of points in a
two-dimensional space. The lattice is defined by its spacing in the x and y
directions (`dx` and `dy`), an additional offset (`ds`), and optional starting
positions (`x0` and `y0`). The lattice spans `2M + 1` rows and `2N + 1` columns
centered around the origin.

## Arguments
- `dx::T`: The spacing between points in the x direction.
- `dy::T`: The spacing between points in the y direction.
- `ds::T`: The additional offset in the x direction per row.
- `x0::T`: The x-coordinate of the starting position. Default is `zero(T)`.
- `y0::T`: The y-coordinate of the starting position. Default is `zero(T)`.
- `M::Int`: The number of points in the x direction from the center. Default is \
100.
- `N::Int`: The number of points in the y direction from the center. Default is \
equal to `M`.

## Returns
- `Array{SVector{2,T},2}`: A 2D array of points represented as static vectors \
(`SVector{2,T}`) from the `StaticArrays` package. Each point is in the form \
`(x, y)`.
"""
function _gen_regular_lattice(dx::T, dy, ds; x0=zero(T), y0=zero(T), M::Int=70, N::Int=M) where {T}
    # Function to generate x position as function of row,column number m,n
    x(m, n) = m * dx + n * ds + x0
    # Function to generate y position as function of row,column number m,n
    y(n) = n * dy + y0
    # Generate the elements. For each row, shift the columns to always have the
    # search domain around x=0
    gen = [SVector(x(m - round(Int, n * ds / dx), n), y(n)) for n in -N:N, m in -M:M]

    return gen
end

"""
    gen_hex_lattice(spacing, direction = :pointy; kwargs...)
Generate a hexagonal lattice of points with equal distance `spacing` between
neighboring points.

The generated hexagonal lattice will have distance between points on the same
row/column that will depend on the second argument `direction`:

If `direction = :pointy`, neighboring points on the same row (points which have
the same `y` coordinate) will be at a distance `spacing` from one another, while
points on the same column (sharing the `x` coordinate) will have a distance
equivalent to `√3 * spacing`.

If `direction = :flat`, the distance will be reversed, so points on the same
column will have a distance equivalent to `spacing` while points on the same row
will have a distance equivalent to `√3 * spacing`.

## Arguments
- `spacing`: spacing between neighboring points
- `direction`: specifies the direction of minimum distance between neighboring\
points. Defaults to `:pointy`.

See also: [`_gen_regular_lattice`](@ref)
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
    _adapted_icogrid(radius::Number; correctionFactor=6/5)

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
function _adapted_icogrid(radius::Number; earth_local_radius=constants.Re_mean, correctionFactor=6 / 5)
    # Define the separation angle for the icosahedral grid in a similar way as
    # for the hexagonal grid using a correction factor 1.2 to adapt the cell
    # centers distances (from old MATLAB grid). The correction factor would be
    # √3 if the original hex grid approach was used.
    sepAng = radius * correctionFactor / earth_local_radius |> rad2deg

    return icogrid(; sepAng)
end

"""
    _hex_tesselation_centroids(origin::SimpleLatLon, radius::Number; direction::Symbol=:pointy, Re::Number=constants.Re_mean, kwargs_lattice...)

This function generates the centroids of a hexagonal tessellation on the Earth's
surface, centered at the origin. The tessellation is created based on a given
radius and direction. The function converts the offsets of the hexagonal grid to
latitude and longitude coordinates.

## Arguments
- `origin::SimpleLatLon`: The lat-lon coordinates of the center of the tessellation. 
- `radius::Number`: The radius of the hexagons in the tessellation in meters.
- `direction::Symbol`: The direction of the hexagons, either `:pointy` (default) \
or `:flat`.
- `Re::Number`: The mean radius of the Earth in meters (default is \
`constants.Re_mean`).
- `kwargs_lattice...`: Additional keyword arguments for the hexagonal lattice \
generation.

## Returns
- `Vector{SimpleLatLon}`: A vector of `SimpleLatLon` objects representing the \
centroids of the hexagonal tessellation in latitude and longitude.
"""
function _hex_tesselation_centroids(origin::SimpleLatLon, radius::Number; direction::Symbol=:pointy, refRadius::Number=constants.Re_mean, kwargs_lattice...)
    ## Generate the lattice centered in 0,0.
    # Angular spacing [rad] between lattice points considering a triple-point
    # overlap. This spacing represents the angle of the arc of length radius, on
    # a circonference of radius equivalent to the Earth mean radius.
    spacing = radius * √3 / refRadius
    offsetLattice = gen_hex_lattice(spacing, direction; kwargs_lattice...) # [rad]

    ## Re-center the lattice around the seed point.
    θ = 90 - (origin.lat |> ustrip) |> deg2rad
    ϕ = origin.lon |> ustrip |> deg2rad
    centreθφ = (; θ=θ, ϕ=ϕ) # [rad] Convert lat-lon in theta-phi (shperical approximation)
    newLattice = map(offsetLattice) do offset
        # 1 - Convert the lat-lon of the grid seed in spherical (ISO). 2 - The
        # lattice give us the θ-ϕ offset to be used for the computation of the
        # actual position of the points on the lat-lon grid. 3 - Pass to
        # Cartesian coordinate such to rotate the vector representing the grid
        # center by the angle described by the offset. 4 - Convert the cartesian
        # position of the newly identified vector back to spherical, (ISO) then
        # to lat-lon This is an approximate approach which can be considered
        # enough accurate for tassellation of small surfaces. However, the
        # points are equidisant from the center, if we want to keep equidistance
        # between adjacent points as accurate as possible, we could solve the
        # geodesic direct problem using each point of the lattice to determinte
        # the sourrounding neighbours. In this case we could compute the azimuth
        # between each of the points and each of its neighbours from the lattice
        # and use the defaul distance we want to obtain between them (radius).
        # Knowing also the lat-lon position of the starting point we have all
        # the parameters to compute the geodesic direct. Even if more accurate,
        # this approch would require to discard the points already computed from
        # the newly computed neighbours (not trivial to be done precisely).
        x, y = offset # Get the x,y of the offset
        θ = sqrt(x^2 + y^2) # [rad] θ is the angular distance between center and target offset, which is exactly the euclidean distance based on how we created the lattice, instead of the asin() like it is to transform from uv -> θϕ
        ϕ = atan(y, x) # [rad]
        offsetθφ = (; θ, ϕ) # [rad]
        new = _add_angular_offset(centreθφ, offsetθφ)

        lat, lon = _wrap_latlon(π / 2 - new.θ |> rad2deg, new.ϕ |> rad2deg)
        SimpleLatLon(lat, lon)
    end

    return newLattice
end

function _generate_tesselation(region::GeoRegion, radius::Number, type::HEX; refRadius::Number=constants.Re_mean, kwargs_lattice...)
    ## Find the domain center as seed for the cell grid layout.
    domain = extract_countries(region)[1] # The indicization is used to extract directly the Multi or PolyArea from the view
    origin = let
        c = if domain isa Multi
            idxMain = findmax(x -> length(vertices(x)), domain.geoms)[2] # Find the PolyArea with the most vertices. It is assumed also to be the largest one so the main area of that country to be considered for the centroid computation.
            c = centroid(domain.geoms[idxMain]) # Find the centroid of the main PolyArea to be used as grid layout seed.
        elseif domain isa PolyArea
            centroid(domain)
        else
            error("Unrecognised type of GeoRegion domain...")
        end
        (; x, y) = c.coords
        SimpleLatLon(y |> ustrip, x |> ustrip) # SimpleLatLon in deg
    end

    ## Generate the tassellation centroids and filter the ones in the region.
    return _hex_tesselation_centroids(origin, radius; direction=type.direction, refRadius, kwargs_lattice...)
end

function _generate_tesselation(region::PolyRegion, radius::Number, type::HEX; refRadius::Number=constants.Re_mean, kwargs_lattice...)
    # Find the domain center as seed for the cell grid layout.
    origin = let
        centre = centroid(region.domain)
        (; x, y) = centre.coords
        SimpleLatLon(y |> ustrip, x |> ustrip) # SimpleLatLon in deg
    end

    # Generate the tassellation centroids.
    return _hex_tesselation_centroids(origin, radius; direction=type.direction, refRadius, kwargs_lattice...)
end

"""
    generate_tesselation(region::Union{GeoRegion, PolyRegion}, radius::Number, type::HEX; refRadius::Number=constants.Re_mean, kwargs_lattice...)
    generate_tesselation(region::Union{GeoRegion, PolyRegion}, radius::Number, type::HEX, ::ExtraOutput; refRadius::Number=constants.Re_mean, kwargs_lattice...)

The `generate_tesselation` function generates a hexagonal cell layout for a given
geographical region. It calculates the cell grid layout centered around the
centroid of the main area of the region and returns the points within the
specified region.

## Arguments
- `region::Union{GeoRegion, PolyRegion}`: The geographical region for which the
cell layout is generated. Larger regions like global and LatBeltRegions are not
supported because of the problem of regular tassellation of the sphere.
- `radius::Number`: The radius of each hexagonal cell. Has to be intended as the \
circumscribed circumference.
- `type::HEX`: A parameter indicating the type of lattice (only HEX is \
supported).
- `refRadius::Number`: The radius of the Earth in meters (default is \
`constants.Re_mean`).
- `::ExtraOutput`: an extra parameter enabling a `Vector{Ngon}` the contours of \
each cell. The mesh originating these contours is obtained using \
`VoronoiTesselation`.
- `kwargs_lattice...`: Additional keyword arguments passed to the \
`gen_hex_lattice` function.

## Returns
- `Array{SimpleLatLon,1}`: An array of points (`SimpleLatLon`) representing the \
cell centers within the specified region.

See also: [`gen_hex_lattice`](@ref), [`_generate_tesselation`](@ref),
[`_hex_tesselation_centroids`](@ref), [`my_tesselate`](@ref), [`HEX`](@ref),
[`GeoRegion`](@ref), [`PolyRegion`](@ref)
"""
function generate_tesselation(region::Union{GeoRegion,PolyRegion}, radius::Number, type::HEX; refRadius::Number=constants.Re_mean, kwargs_lattice...)
    # Generate the tassellation centroids.
    centroids = _generate_tesselation(region, radius, type; refRadius, kwargs_lattice...)

    # Filter centroids in the region.
    return filter_points(centroids, region)
end

function generate_tesselation(region::Union{GeoRegion,PolyRegion}, radius::Number, type::HEX, ::ExtraOutput; refRadius::Number=constants.Re_mean, kwargs_lattice...)
    # Generate the tassellation centroids and filter the ones in the region.
    centroids = _generate_tesselation(region, radius, type; refRadius, kwargs_lattice...)

    # Create the tasselation from all the centroids.
    mesh = my_tesselate(centroids)

    # Filter centroids in the region.
    filtered, idxs = filter_points(centroids, region, ExtraOutput())

    return filtered, mesh[idxs]
end

"""
    generate_tesselation(region::GlobalRegion, radius::Number, type::ICO)
    generate_tesselation(region::Union{LatBeltRegion, GeoRegion, PolyRegion}, radius::Number, type::ICO)

The `generate_tesselation` function generates a cell layout using an icosahedral grid
for a given geographical region. The function adapts the grid based on the
specified radius and applies a correction factor (see `_adapted_icogrid`). The
radius as to be intended as the semparation angle of the point on the
icosahedral grid. It then filters the grid points to include only those within
the specified region.

## Arguments
- `region::Union{LatBeltRegion, GeoRegion, PolyRegion}`: The geographical region \
for which the cell layout is generated. This can be a `LatBeltRegion`, \
`GeoRegion`, or `PolyRegion`.
- `radius::Number`: The radius used to adapt the icosahedral grid.
- `type::ICO`: An object specifying the type of icosahedral grid and its \
correction factor.

## Returns
- `Array{PointType, 1}`: An array of points representing the cell centers within \
the specified region. The exact type of `PointType` depends on the \
implementation of the `_adapted_icogrid` and `filter_points` functions.

See also: [`_adapted_icogrid()`](@ref), [`icogrid()`](@ref),
[`filter_points()`](@ref), [`GeoRegion`](@ref), [`LatBeltRegion`](@ref),
[`PolyRegion`](@ref), [`GlobalRegion`](@ref), [`ICO`](@ref)
"""
function generate_tesselation(region::GlobalRegion, radius::Number, type::ICO)
    return _adapted_icogrid(radius; correctionFactor=type.correction)
end

function generate_tesselation(region::Union{LatBeltRegion,GeoRegion,PolyRegion}, radius::Number, type::ICO)
    grid = _adapted_icogrid(radius; correctionFactor=type.correction)

    return filter_points(grid, region)
end

function generate_tesselation(region::Union{GlobalRegion,LatBeltRegion,GeoRegion,PolyRegion}, radius::Number, type::H3)
    error("H3 tassellation is not yet implemented in this version...")
end

"""
    my_tesselate(pset::PointSet, method::VoronoiTesselation; sorted=true) -> SimpleMesh
    my_tesselate(points::AbstractVector{<:Point}, method::TesselationMethod) -> SimpleMesh

This function performs a Voronoi tessellation on a given set of 2D points. The
tessellation divides the plane into polygons such that each polygon contains
exactly one generating point and every point in a given polygon is closer to its
generating point than to any other. The function handles the conversion between
coordinate systems and ensures that the resulting polygons are correctly sorted
if specified.

## Arguments
- `pset::PointSet`: The set of points to be tessellated. Must have 2 coordinates \
per point.
- `method::VoronoiTesselation`: The tessellation method containing parameters \
for the Voronoi tessellation, including the random number generator (`rng`).
- `sorted::Bool`: Whether to sort the polygons in the tessellation output to \
match the original order of points (default: `true`).

## Returns
- `SimpleMesh`: A mesh object representing the tessellated polygons.
"""
function my_tesselate(pset::PointSet; method::VoronoiTesselation=VoronoiTesselation(), sorted=true)
    C = crs(pset)
    T = Meshes.numtype(Meshes.lentype(pset))
    Meshes.assertion(CoordRefSystems.ncoords(C) == 2, "points must have 2 coordinates")

    # Perform tesselation with raw coordinates
    rawval = map(p -> CoordRefSystems.rawvalues(coords(p)), pset)

    triang = Meshes.triangulate(rawval, randomise=false, rng=method.rng)
    vorono = Meshes.voronoi(triang, clip=true) # Using the Dict we loose the correct sorting of elements (polygons), which can be recovered later.

    # Mesh with all (possibly unused) points
    points = map(Meshes.get_polygon_points(vorono)) do xy
        coords = CoordRefSystems.reconstruct(C, T.(xy))
        Point(coords)
    end
    polygs = Meshes.each_polygon(vorono)
    tuples = [Tuple(inds[begin:(end-1)]) for inds in polygs]

    if sorted # Recover correct sorting of polygons.
        original_idxs = keys(vorono.polygons) |> collect
        invpermute!(tuples, original_idxs)
    end

    connec = connect.(tuples)
    mesh = SimpleMesh(points, connec)

    # Remove unused points
    mesh |> Repair{1}()
end

my_tesselate(points::AbstractVector{<:Point}; kwargs...) = my_tesselate(PointSet(points); kwargs...)

function my_tesselate(points::AbstractVector{<:SimpleLatLon}; kwargs...)
    # Convert the input points in a PointSet. Rememeber that in Meshes.jl we
    # must consider lat=y and lon=x (that's why we invert the order when
    # creating the converted point).
    converted = map(x -> Point(ustrip(x.lon), ustrip(x.lat)), points)

    my_tesselate(PointSet(converted); kwargs...)
end
