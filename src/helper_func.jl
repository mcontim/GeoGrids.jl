"""
    _check_geopoint(p::Union{AbstractVector, Point2, Tuple}; rev=false) -> Point2
    _check_geopoint(p::Point2; kwargs...) -> Point2
    _check_geopoint(p::LLA; kwargs...) -> Point2
    _check_geopoint(points::Array{<:Union{AbstractVector,Tuple,LLA}}; kwargs...) -> Array{Point2}

Checks the validity of the given point `p` in terms of latitude (LAT) and longitude (LON) values. The function expects the input to be in radians and within the valid range for LAT and LON. If you want to pass numbers in degrees, consider using `°` from Unitful (Also re-exported by GeoGrids) by doing `x * °`.

## Arguments
- `p`: A tuple representing a point on the globe where the first element is the latitude (LAT) and the second element is the longitude (LON).
- `rev`: If `true`, the function will return the point in the reverse order. Defaults to `false`.

## Returns
- A `Point2` converted to degrees.
"""
function _check_geopoint(p::Union{AbstractVector, Tuple}; rev=false, unit=:deg)
    length(p) != 2 && error("The input must be a 2D point...")
    _check_angle(first(p); limit=π/2, msg="LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    _check_angle(last(p); limit=π, msg="LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    
    if unit == :rad
        lat = to_radians(first(p))
        lon = to_radians(last(p))
    else
        lat = to_radians(first(p)) |> rad2deg
        lon = to_radians(last(p)) |> rad2deg
    end

    return rev ? Point2(lon, lat) : Point2(lat, lon) # Countries borders is in degrees (for consistency also PolyArea points are stored in degrees)
end
_check_geopoint(p::Point2; kwargs...) = _check_geopoint(p.coords; kwargs...)
_check_geopoint(p::LLA; kwargs...) = _check_geopoint((p.lat, p.lon); kwargs...)
_check_geopoint(points::Array{<:Union{AbstractVector,Tuple,LLA,Point2}}; kwargs...) = map(x -> _check_geopoint(x, kwargs...), points)


## Aux Functions
"""
    extract_countries(r::GeoRegion)

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

"""
    _grid_points_conversion(gridPoints; height=nothing, unit=:rad, type=:lla)

Converts grid points to the desired type and unit.

## Arguments
- `gridPoints`: The grid points to be converted.
- `height`: The height value. It is optional. If not provided, it will be set to 0 by default. This argument is ignored when `type` is set to `:point`.
- `unit::Symbol`: The unit of the grid. It can be `:rad` for radians (default) or `:deg` for degrees. This argument is used only when `type` is set to `:point`.
- `type::Symbol`: The type of the output. It can be `:lla` (default) for latitude-longitude-altitude or `:point` for 2D point.

## Returns
- `out`: The converted grid points. If `type` is `:lla`, each element of the grid is an `LLA` object with latitude, longitude, and altitude. If `type` is `:point`, each element of the grid is a `Point2` object with latitude and longitude.
"""
function _grid_points_conversion(gridPoints; height=nothing, unit=:rad, type=:lla)
    out = if type == :lla
		_height = if isnothing(height)
			@warn "Height is not provided, it will be set to 0 by default..." 
			0.0 
		else 
			height
		end
		map(x -> LLA(x..., _height), gridPoints)
	elseif type == :point
		!isnothing(height) && @warn "Height is ignored when type is set to :point..."
		# Unit Conversion
		conv = if unit == :deg 
			map(x -> rad2deg.(x), gridPoints)
		else
			gridPoints
		end
		map(x -> Point2(x...), conv) # lat-lon
	else
		error("The input type do not match the expected format, it must be :lla or :point...")
	end

	return out
end