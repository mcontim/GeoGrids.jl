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
    _check_geopoint(p::Union{AbstractVector, Point2, Tuple}) -> Point2(lon,lat)
    _check_geopoint(p::Point2) -> Point2(lon,lat)
    _check_geopoint(p::LLA) -> Point2(lon,lat)

Checks the validity of the given point `p` in terms of latitude (LAT) and longitude (LON) values. The function expects the input to be in radians and within the valid range for LAT and LON. If you want to pass numbers in degrees, consider using `°` from Unitful (Also re-exported by GeoGrids) by doing `x * °`.

## Arguments
- `p`: A tuple representing a point on the globe where the first element is the latitude (LAT) and the second element is the longitude (LON).

## Returns
- A `Point2` with the longitude (LON) in first position and latitude (LAT) value in second position, converted to radians.
"""
function _check_geopoint(p::Union{AbstractVector, Tuple})
    length(p) != 2 && error("The input must be a 2D point...")
    _check_angle(first(p); limit=π/2, msg="LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    _check_angle(last(p); limit=π, msg="LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    
    lat = to_radians(first(p)) |> rad2deg
	lon = to_radians(last(p)) |> rad2deg

    return Point2(lon, lat) # Countries borders is in degrees (for consistency also PolyArea points are stored in degrees)
end
_check_geopoint(p::Point2) = _check_geopoint(p.coords)
_check_geopoint(p::LLA) = Point2((rad2deg(p.lon), rad2deg(p.lat))) # The values are in radians and checked in LLA() constructor.