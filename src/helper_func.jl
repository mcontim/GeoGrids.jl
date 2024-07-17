"""
    _cast_geopoint(p::Union{AbstractVector, Tuple})
    _cast_geopoint(p::SimpleLatLon)

Convert various types of input representations into a `SimpleLatLon` object.
This method assumes that the input coordinates are in degrees. It converts the latitude and longitude from degrees to radians before creating a `SimpleLatLon` object.

## Arguments
- `p::Union{AbstractVector, Tuple}`: A 2D point where the first element is the latitude and the second element is the longitude, both in degrees.

## Returns
- `SimpleLatLon`: An object representing the geographical point with latitude and longitude converted to radians.

## Errors
- Throws an `ArgumentError` if the input `p` does not have exactly two elements.
"""
function _cast_geopoint(p::Union{AbstractVector, Tuple})
    length(p) != 2 && error("The input must be a 2D point...")
    lat = first(p)
    lon = last(p)
    # Inputs are considered in degrees
    return SimpleLatLon(lat*°, lon*°)
end
# _cast_geopoint(p::LLA) = SimpleLatLon(p) # //FIX: to be removed
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
    names = setdiff(fieldnames(GeoRegion), (:regionName,:domain))

    all_pairs = map(names) do n
        n => getfield(r,n)
    end 
    
    kwargs = NamedTuple(filter(x -> !isempty(x[2]), all_pairs))
    @info kwargs
    CountriesBorders.extract_countries(;kwargs...)
end

# """
#     _grid_points_conversion(gridPoints; height=nothing, unit=:rad, type=:lla)

# Converts grid points to the desired type and unit.

# ## Arguments
# - `gridPoints`: The grid points to be converted.
# - `height`: The height value. It is optional. If not provided, it will be set to 0 by default. This argument is ignored when `type` is set to `:point`.
# - `unit::Symbol`: The unit of the grid. It can be `:rad` for radians (default) or `:deg` for degrees. This argument is used only when `type` is set to `:point`.
# - `type::Symbol`: The type of the output. It can be `:lla` (default) for latitude-longitude-altitude or `:point` for 2D point.

# ## Returns
# - `out`: The converted grid points. If `type` is `:lla`, each element of the grid is an `LLA` object with latitude, longitude, and altitude. If `type` is `:point`, each element of the grid is a `Point` object with latitude and longitude.
# """
# function _grid_points_conversion(gridPoints; height=nothing, unit=:rad, type=:lla)
#     out = if type == :lla
# 		_height = if isnothing(height)
# 			@warn "Height is not provided, it will be set to 0 by default..." 
# 			0.0 
# 		else 
# 			height
# 		end
# 		map(x -> LLA(x..., _height), gridPoints)
# 	elseif type == :point
# 		!isnothing(height) && @warn "Height is ignored when type is set to :point..."
# 		# Unit Conversion
# 		conv = if unit == :deg 
# 			map(x -> rad2deg.(x), gridPoints)
# 		else
# 			gridPoints
# 		end
# 		map(x -> Point(x...), conv) # lat-lon
# 	else
# 		error("The input type do not match the expected format, it must be :lla or :point...")
# 	end

# 	return out
# end

function _check_angle_func(limit = π) 
	f(x::Union{Real, UnitfulAngleQuantity}) = abs(x) <= limit
end
function _check_angle(x; limit = π, msg::String = "Angles directly provided as numbers must be expressed in radians and satisfy -$limit ≤ x ≤ $limit
Consider using `°` from Unitful (Also re-exported by TelecomUtils) if you want to pass numbers in degrees, by doing `x * °`." )  
	@assert all(_check_angle_func(limit), x) msg
end
