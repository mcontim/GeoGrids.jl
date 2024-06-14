"""
    _check_angle_func(limit = π) 

This function creates and returns another function which checks if the absolute value of `x` is less than or equal to the `limit`. The `limit` defaults to `π` if not provided. 
    
## Arguments:
- `x::Uniion{Real, UnitfulAngle}`: A real number or UnitfulAngle quantity to be checked.

## Returns:
- `Bool` as result of the input check.
"""
function _check_angle_func(limit = π) 
	f(x::Real) = abs(x) <= limit
	f(x::UnitfulAngleQuantity) = abs(to_radians(x)) <= limit
end

"""
    _check_angle(x; limit = π, msg::String)
    
This function checks if all elements in `x` satisfy the condition defined by `_check_angle_func(limit)`. If not, it throws an assertion error with the provided `msg`. The `limit` defaults to `π` and `msg` defaults to a string suggesting that angles should be expressed in radians and satisfy the condition `-limit ≤ x ≤ limit`. It also suggests using `°` from Unitful for passing numbers in degrees.
"""
function _check_angle(x; limit = π, msg::String = "Angles directly provided as numbers must be expressed in radians and satisfy -$limit ≤ x ≤ $limit
Consider using `°` from Unitful (Also re-exported by TelecomUtils) if you want to pass numbers in degrees, by doing `x * °`." )  
	@assert all(_check_angle_func(limit), x) msg
end

"""
    _check_geopoint(p::Union{AbstractVector, Point2, Tuple}; rev=false) -> Point2
    _check_geopoint(p::Point2; kwargs...) -> Point2
    _check_geopoint(p::LLA; kwargs...) -> Point2
    _check_geopoint(points::Array{<:Union{AbstractVector,Tuple,LLA}}; kwargs...) -> Array{Point2}

Checks the validity of the given point `p` in terms of latitude (LAT) and longitude (LON) values. The function expects the input to be in radians and within the valid range for LAT and LON. If you want to pass numbers in degrees, consider using `°` from Unitful (Also re-exported by GeoGrids) by doing `x * °`.

## Arguments
- `p`: A tuple representing a point on the globe where the first element is the latitude (LAT) and the second element is the longitude (LON).

## Returns
- A `Point2` with the longitude (LON) in first position and latitude (LAT) value in second position, converted to radians.
"""
function _check_geopoint(p::Union{AbstractVector, Tuple}; rev=false)
    length(p) != 2 && error("The input must be a 2D point...")
    _check_angle(first(p); limit=π/2, msg="LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    _check_angle(last(p); limit=π, msg="LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    
    lat = to_radians(first(p)) |> rad2deg
	lon = to_radians(last(p)) |> rad2deg

    return rev ? Point2(lon, lat) : Point2(lat, lon) # Countries borders is in degrees (for consistency also PolyArea points are stored in degrees)
end
_check_geopoint(p::Point2; kwargs...) = _check_geopoint(p.coords; kwargs...)
_check_geopoint(p::LLA; kwargs...) = _check_geopoint((p.lat, p.lon); kwargs...)
_check_geopoint(points::Array{<:Union{AbstractVector,Tuple,LLA}}; kwargs...) = map(x -> _check_geopoint(x, kwargs...), points)


## Aux Functions
"""
    CountriesBorders.extract_countries(r::GeoRegion)

Extracts the countries from a given region.

It first gets the field names of the `GeoRegion` type, excluding the `:regionName`, then maps these field names to their corresponding values in the `GeoRegion` instance `r`, creating a collection of pairs. It filters out any pairs where the value is empty. It converts this collection of pairs into a `NamedTuple`, finally, it calls `CountriesBorders.extract_countries` with the `NamedTuple` as keyword arguments.

This function is an overload of `CountriesBorders.extract_countries` that takes a `GeoRegion` object as input. It extracts the countries from the given region and returns them.

## Arguments
- `r::GeoRegion`: The region from which to extract the countries. It should be an instance of the `GeoRegion` type.

## Returns
- The function returns the result of `CountriesBorders.extract_countries(;kwargs...)`.
"""
function CountriesBorders.extract_countries(r::GeoRegion)
    # Overload of CountriesBorders.extract_countries taking GeoRegion as input
    names = setdiff(fieldnames(GeoRegion), (:regionName,:domain))

    all_pairs = map(names) do n
        n => getfield(r,n)
    end 
    
    kwargs = NamedTuple(filter(x -> !isempty(x[2]), all_pairs))
    @info kwargs
    CountriesBorders.extract_countries(;kwargs...)
end