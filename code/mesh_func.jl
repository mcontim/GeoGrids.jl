"""
	meshgrid(gridRes)

This function call get_meshgrid with the specified resolution given as input and return the LAT, LON meshgrid (LAT=y, LON=x).
The meshgrid cover all the globe with LAT=-90:90 and LON=-180:180

### Arguments
- `gridRes`: resolution of the meshgrid in rad
- `unit`: `:rad` or `:deg`

### Output
- `vec`: A vector of SVector{2}(lon,lat) objects of LAT-LON coordinates in rad (or deg) (LAT=y, LON=x).
"""
function meshgrid(gridRes; unit=:rad)
	vec = get_meshgrid(-π:gridRes:π-gridRes,-π/2:gridRes:π/2)
	
	# Unit Conversion
	if unit == :deg 
		vec = map(x -> rad2deg.(x), vec)
	end

	return vec
end

"""
	get_meshgrid(xin, yin)

Create a 2D grid of coordinates using the input vectors `xin` and `yin`.
The outputs contain all possible combinations of the elements of `xin` and `yin`, with `xout` corresponding to the horizontal coordinates and `yout` corresponding to the vertical coordinates.

### Arguments
- `xin::AbstractVector`: 1D input array of horizontal coordinates.
- `yin::AbstractVector`: 1D input array of vertical coordinates.

### Output
- `mat`: A Matrix of SVector{2}(lon,lat) objects.
"""
function get_meshgrid(xin,yin)
	# Compact writing using SA convenience constructor for StaticArrays and Comprehensions 
	[SA_F64[x,y] for x in xin, y in yin]
	
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