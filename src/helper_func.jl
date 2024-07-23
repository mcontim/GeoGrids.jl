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
    @info kwargs
    CountriesBorders.extract_countries(; kwargs...)
end
