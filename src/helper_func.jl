"""
    _cast_geopoint(p::Union{AbstractVector, Tuple})
    _cast_geopoint(p::SimpleLatLon)

Convert various types of input representations into a `SimpleLatLon` object.
This method assumes that the input coordinates are in degrees. It converts the
latitude and longitude from degrees to radians before creating a `SimpleLatLon`
object.

## Arguments
- `p::Union{AbstractVector, Tuple}`: A 2D point where the first element is the \
latitude and the second element is the longitude, both in degrees.

## Returns
- `SimpleLatLon`: An object representing the geographical point with latitude \
and longitude converted to radians.

## Errors
- Throws an `ArgumentError` if the input `p` does not have exactly two elements.
"""
function _cast_geopoint(p::Union{AbstractVector,Tuple})
    length(p) != 2 && error("The input must be a 2D point...")
    lat = first(p)
    lon = last(p)
    # Inputs are considered in degrees
    return SimpleLatLon(lat * °, lon * °)
end
_cast_geopoint(p::SimpleLatLon) = p

## Aux Functions
"""
    extract_countries(r::GeoRegion)

Extracts the countries from a given region.

It first gets the field names of the `GeoRegion` type, excluding the
`:regionName`, then maps these field names to their corresponding values in the
`GeoRegion` instance `r`, creating a collection of pairs. It filters out any
pairs where the value is empty. It converts this collection of pairs into a
`NamedTuple`, finally, it calls `CountriesBorders.extract_countries` with the
`NamedTuple` as keyword arguments.

This function is an overload of `CountriesBorders.extract_countries` that takes
a `GeoRegion` object as input. It extracts the countries from the given region
and returns them.

## Arguments
- `r::GeoRegion`: The region from which to extract the countries. It should be \
an instance of the `GeoRegion` type.

## Returns
- The function returns the result of \
`CountriesBorders.extract_countries(;kwargs...)`.
"""
function CountriesBorders.extract_countries(r::GeoRegion)
    # Overload of CountriesBorders.extract_countries taking GeoRegion as input
    names = setdiff(fieldnames(GeoRegion), (:regionName, :domain))

    all_pairs = map(names) do n
        n => getfield(r, n)
    end

    kwargs = NamedTuple(filter(x -> !isempty(x[2]), all_pairs))

    return CountriesBorders.extract_countries(; kwargs...)
end

"""
    _gen_hex_vertices(cx::Number, cy::Number, r::Number; direction::Symbol=:pointy, f::Function=identity)
    _gen_hex_vertices(center::SimpleLatLon, r::Number; earth_local_radius = constants.Re_mean, direction::Symbol=:pointy)    

The `_gen_hex_vertices` function generates the vertices of a hexagon
centered at a given point `(cx, cy)` with a specified radius `r`. The function
allows for two orientations of the hexagon: "pointy" (vertex pointing upwards)
or "flat" (edge pointing upwards).

## Arguments
- `cx::Number`: The x-coordinate of the center of the hexagon.
- `cy::Number`: The y-coordinate of the center of the hexagon.
- `center::SimpleLatLon`: The center of the hexagon as a `SimpleLatLon` object.
- `r::Number`: The radius of the hexagon, which is the distance from the center \
to any vertex.
- `direction::Symbol`: The orientation of the hexagon. It can be either \
`:pointy` for a hexagon with a vertex pointing upwards or `:flat` for a \
hexagon with an edge pointing upwards. The default value is `:pointy`.
- f::Function: A function to apply to the vertices before returning them.

## Returns
- `vertices::Vector{Tuple{Number, Number}}`: A vector of tuples, where each \
tuple represents the `(x, y)` coordinates of a vertex of the hexagon. The \
vector contains 7 tuples, with the last vertex being the same as the first to \
close the hexagon. When `SimpleLatLon` is given as input the output vector \
contains `Number` representing lon=x and lat=y in deg (useful for geoscatter plotting). 
"""
function _gen_hex_vertices(cx::Number, cy::Number, r::Number; direction::Symbol=:pointy, f::Function=identity)
    vertices = if direction === :pointy
        [(cx + r * sin(2π * i / 6), cy + r * cos(2π * i / 6)) for i in 0:6]
    else
        [(cx + r * cos(2π * i / 6), cy + r * sin(2π * i / 6)) for i in 0:6]
    end

    return map(x -> f.(x), vertices)
end

function _gen_hex_vertices(center::SimpleLatLon, r::Number; earth_local_radius = constants.Re_mean, direction::Symbol=:pointy)
    # Radius in meters.
    # The output is a Vector of values in deg for the sake of simplicity of the plotting.
    cx = center.lon |> ustrip |> deg2rad
    cy = center.lat |> ustrip |> deg2rad
    r = r / earth_local_radius

    return _gen_hex_vertices(cx, cy, r; direction=direction, f=rad2deg)
end

"""
    _gen_circle(cx::Number, cy::Number, r::Number, f::Function=identity, n::Int=100)
    _gen_circle(center::SimpleLatLon, r::Number, n::Int=100)

The `_gen_circle` function generates a set of points representing a circle
centered at `(cx, cy)` with a radius `r`. The points are calculated using the
parametric equations for a circle. An optional function `f` can be applied to
each point, and the number of points `n` can be specified to control the
resolution of the circle.

## Arguments
- `cx::Number`: The x-coordinate of the circle's center.
- `cy::Number`: The y-coordinate of the circle's center.
- `r::Number`: The radius of the circle.
- `f::Function=identity`: An optional function to be applied to each point of \
the circle. The default function is `identity`, which returns the points \
unchanged.
- `n::Int=100`: The number of points to generate on the circle. The default \
value is 100.

## Returns
- `Array`: An array of points `(x, y)` on the circle, after applying the \
function `f` to each point.
"""
function _gen_circle(cx::Number, cy::Number, r::Number; f::Function=identity, n::Int=100)
    # Calculate the angle step
    angle = 0:2π/n:2π

    circle_points = map(angle) do ang
        (cx + r * cos(ang), cy + r * sin(ang))
    end

    return map(x -> f.(x), circle_points)
end

function _gen_circle(center::SimpleLatLon, r::Number; earth_local_radius = constants.Re_mean, n::Int=100)
    # Radius in meters.
    # The output is a Vector of values in deg for the sake of simplicity of the plotting.
    cx = center.lon |> ustrip |> deg2rad
    cy = center.lat |> ustrip |> deg2rad
    r = r / earth_local_radius

    return _gen_circle(cx, cy, r; f=rad2deg, n=n)
end

"""
    _wrap_latlon(lat::Number, lon::Number)

The `_wrap_latlon` function normalizes and wraps geographic coordinates,
latitude (`lat`) and longitude (`lon`). It ensures that the latitude is within
the range [-90, 90] degrees and the longitude is within the range [-180, 180)
degrees. This function is useful for handling geographic data where coordinates
might exceed their typical bounds.

## Arguments
- `lat::Number`: The latitude value to be normalized and wrapped.
- `lon::Number`: The longitude value to be normalized and wrapped.

## Returns
- `Tuple{Number, Number}`: A tuple `(lat, lon)` where `lat` is in the range \
[-90, 90] and `lon` is in the range [-180, 180).
"""
function _wrap_latlon(lat::Number, lon::Number)
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

function _get_local_radius(lat::Number, lon::Number, alt::Number)
    sΦ, cΦ = sincos(deg2rad(lat))
    sλ, cλ = sincos(deg2rad(lon))

    e = (constants.a^2 - constants.b^2) / constants.a^2
    N = constants.a / sqrt(1 - e^2 * sind(lon)^2) # N(lon)

    x = (N + alt) * cΦ * cλ
    y = (N + alt) * cΦ * sλ
    z = (N * (1 - e^2) + alt) * sΦ
    
    return sqrt(x^2 + y^2 + z^2)
end