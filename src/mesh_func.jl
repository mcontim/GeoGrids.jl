"""
	rectgrid(xRes::ValidAngle; yRes::ValidAngle=xRes, height=nothing, unit=:rad, type=:lla)

This function call meshgrid with the specified resolution given as input and return the LAT, LON meshgrid (LAT=y, LON=x).
The meshgrid cover all the globe with LAT=-90:90 and LON=-180:180

## Arguments
- `xRes`: resolution of the x axis in meshgrid in `ValidAngle`. 
- `yRes`: resolution of the y axis in meshgrid in `ValidAngle`. 
- `unit`: `:rad` or `:deg`
- `type`: `:lla` or `:point`. Output type either `LLA` or `Point2`
- `height`: the point altitude in case of LLA type

## Output
- `out`: Matrix{Union{LLA,Point2}}, each element of the matrix is either a `LLA` or `Point2`. The order of the elements is LAT, LON.
"""
function rectgrid(xRes::ValidAngle; yRes::ValidAngle=xRes, height=nothing, unit=:rad, type=:lla)
	# Input Validation   
	_xRes = let
		x = xRes isa Real ? xRes * ° : l # Convert to Uniful
		abs(x) ≤ 180° || error("Resolution of x is too large, it must be smaller than π...")
		if x < 0
			@warn "Input xRes is negative, it will be converted to positive..."
			abs(x)
		else
			x
		end
	end

	_yRes = let
		x = yRes isa Real ? yRes * ° : l # Convert to Uniful
		abs(x) ≤ 180° || error("Resolution of x is too large, it must be smaller than π...")
		if x < 0
			@warn "Input yRes is negative, it will be converted to positive..."
			abs(x)
		else
			x
		end
	end

	# Create the rectangular grid of elements SimpleLatLon
	out = [SimpleLatLon(x,y) for x in -90°:_xRes:90°, y in -180°:_yRes:(180°-_yRes+1e-10*°)]

	return out
end

"""
    vecgrid(gridRes::ValidAngle; height=nothing, unit=:rad, type=:lla)

Create a vector grid with a given resolution.

## Arguments
- `gridRes::ValidAngle`: The resolution of the grid. If the input is negative, it will be converted to positive. The resolution must be smaller than π/2.
- `height`: The height value. It is optional. If not provided, it will be set to 0 by default. This argument is ignored when `type` is set to `:point`.
- `unit::Symbol`: The unit of the grid. It can be `:rad` for radians (default) or `:deg` for degrees. This argument is used only when `type` is set to `:point`.
- `type::Symbol`: The type of the output. It can be `:lla` (default) for latitude-longitude-altitude or `:point` for 2D point.

## Returns
- `out`: The output vector grid. If `type` is `:lla`, each element of the grid is an `LLA` object with latitude, longitude, and altitude. If `type` is `:point`, each element of the grid is a `Point2` object with latitude and longitude.
"""
function vecgrid(gridRes::ValidAngle; height=nothing, unit=:rad, type=:lla)
	# Input Validation
	_gridRes = let
		_check_angle(gridRes; limit=π/2, msg = "Resolution of grid is too large, it must be smaller than π/2...")
		if gridRes < 0
			@warn "Input gridRes is negative, it will be converted to positive..."
			to_radians(abs(gridRes))
		else
			to_radians(gridRes)
		end	
	end

	# Create LAT vector
	temp = collect(0:_gridRes:π/2) # LAT vector from 0 to π/2
	vec = map(x -> SVector(x, 0.0), temp) # LAT vector from 0 to π/2
	
	# Unit Conversion
	out = _grid_points_conversion(vec; height, type, unit)

	return out
end