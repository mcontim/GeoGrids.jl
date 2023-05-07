"""
	meshgrid(gridRes)

This function call get_meshgrid with the specified resolution given as input and return the LAT, LON meshgrid.

### Arguments
- `gridRes`: resolution of the meshgrid

### Output
- `vec`: A vector of SVector objects.
- `grid`: A tuple of two 2-dimensional grids of x-coordinates and y-coordinates.
"""
meshgrid(gridRes) = get_meshgrid(-180:gridRes:180,-90:gridRes:90)

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
			push!(vec,SVector(xout[ix,jx],yout[ix,jx]))
	    end
	end
	grid = (xout,yout)

    return vec,grid
end