"""
	meshgrid(gridRes)

This function call get_meshgrid with the specified resolution given as input and return the LAT, LON meshgrid (LAT=y, LON=x).

### Arguments
- `gridRes`: resolution of the meshgrid in rad

### Output
- `vec`: A vector of SVector{2}(lon,lat) objects of LAT-LON coordinates in rad (LAT=y, LON=x).
- `grid`: A tuple of two 2-dimensional grids of LAT-LON coordinates in rad (LAT=y, LON=x).
"""
function meshgrid(gridRes; unit=:rad)
	if unit == :rad 
		vec,grid = get_meshgrid(-π:gridRes:π-gridRes,-π/2:gridRes:π/2)
	else
		coord = get_meshgrid(-π:gridRes:π-gridRes,-π/2:gridRes:π/2)
		vec = map(x -> rad2deg.(x), coord[1])
		grid = (x=rad2deg.(coord[2][1]), y=rad2deg.(coord[2][2]))
	end

	return vec,grid
end

"""
	get_meshgrid(xin, yin)

Create a 2D grid of coordinates using the input vectors `xin` and `yin`.
The outputs contain all possible combinations of the elements of `xin` and `yin`, with `xout` corresponding to the horizontal coordinates and `yout` corresponding to the vertical coordinates.

### Arguments
- `xin::AbstractVector`: 1D input array of horizontal coordinates.
- `yin::AbstractVector`: 1D input array of vertical coordinates.

### Output
- `vec`: A vector of SVector objects.
- `grid`: A tuple of two 2-dimensional grids of x-coordinates and y-coordinates.
"""
function get_meshgrid(xin,yin)
	nx = length(xin)
	ny = length(yin)
	xout = zeros(ny,nx)
	yout = zeros(ny,nx)
	vec = []
	
    for jx = 1:nx
	    for ix = 1:ny
	        xout[ix,jx] = xin[jx]
	        yout[ix,jx] = yin[ix]
			push!(vec,SVector(xin[jx],yin[ix]))
	    end
	end
	grid = (x=xout,y=yout)

    return vec,grid
end