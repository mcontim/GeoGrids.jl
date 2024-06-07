"""
	meshgrid_geo(gridRes)

This function call meshgrid with the specified resolution given as input and return the LAT, LON meshgrid_geo (LAT=y, LON=x).
The meshgrid_geo cover all the globe with LAT=-90:90 and LON=-180:180

### Arguments
- `gridRes`: resolution of the meshgrid_geo in `ValidAngle`. 
- `unit`: `:rad` or `:deg`
- `type`: `:lla` or `:point`. Output type either `LLA` or `Point2`

### Output
- Matrix{SVector{2,Float64}}, each element of the matrix is either a `LLA` or `Point2`. The order of the elements is LAT, LON.
"""
function meshgrid_geo(xRes::ValidAngle; yRes::ValidAngle=xRes, height=0.0, unit=:rad, type=:lla)
	# Input Validation
	_xRes = to_radians(xRes; rounding=RoundDown)
	_xRes > π && error("Resolution of x is too large, it must be smaller than π...")
	_yRes = to_radians(yRes; rounding=RoundDown)
	_yRes > π && error("Resolution of y is too large, it must be smaller than π...")
	
	# Create meshgrid
	mat = meshgrid(-π/2:gridRes:π/2, -π:gridRes:π-gridRes+1e-10)
	
	# Unit Conversion
	out = if type == :lla
		map(x -> LLA(x[1], x[2], height), mat)
	else
		conv = if unit == :deg 
			map(x -> rad2deg.(x), mat)
		else
			mat
		end
		
	end

	return out
end

"""
	meshgrid(xin::AbstractVector, yin::AbstractVector) -> Matrix{SVector{2,Float64}}

Create a 2D grid of coordinates using the input vectors `xin` and `yin`.
The outputs contain all possible combinations of the elements of `xin` and `yin`, with `xout` corresponding to the horizontal coordinates and `yout` corresponding to the vertical coordinates.

### Arguments
- `xin::AbstractVector`: 1D input array of horizontal coordinates.
- `yin::AbstractVector`: 1D input array of vertical coordinates.

### Output
- Matrix{SVector{2,Float64}}, each element of the matrix can be considered as (lat, lon).
"""
function meshgrid(xin::AbstractVector, yin::AbstractVector)
	# Compact writing using SA convenience constructor for StaticArrays and Comprehensions 
	return [SA_F64[x,y] for x in xin, y in yin]
	
	# # Equivalent nested for construction
	# nx 	 = length(xin)
	# ny 	 = length(yin)
	# xout = zeros(ny,nx)
	# yout = zeros(ny,nx)
	# mat  = Array{SVector{2,Float64}}(undef,length(yin),length(xin)) # Output matrix of SVectors
	
    # for jx = 1:nx
	#     for ix = 1:ny
	#         xout[ix,jx] = xin[jx]
	#         yout[ix,jx] = yin[ix]
	# 		mat[ix,jx] = SVector(xin[jx],yin[ix])
	#     end
	# end
    # return mat
end