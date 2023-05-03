"""
    meshgrid(xin, yin)

Create a 2D grid of coordinates using the input vectors `xin` and `yin`.
The output arrays `xout` and `yout` are the same size, and contain all possible combinations of the elements of `xin` and `yin`, with `xout` corresponding to the horizontal coordinates and `yout` corresponding to the vertical coordinates.

### Arguments
- `xin::AbstractVector`: 1D input array of horizontal coordinates.
- `yin::AbstractVector`: 1D input array of vertical coordinates.

### Output
- `xout::Matrix`: 2D output array of horizontal coordinates, with size (length(yin), length(xin)).
- `yout::Matrix`: 2D output array of vertical coordinates, with size (length(yin), length(xin)).

### Example
```julia
julia> x = [1, 2, 3];
julia> y = [4, 5, 6, 7];
julia> meshgrid(x, y)
([1 2 3; 1 2 3; 1 2 3; 1 2 3], [4 4 4; 5 5 5; 6 6 6; 7 7 7])
```
"""
function meshgrid(xin,yin)
	nx = length(xin)
	ny = length(yin)
	xout = zeros(ny,nx)
	yout = zeros(ny,nx)
	
    for jx = 1:nx
	    for ix = 1:ny
	        xout[ix,jx] = xin[jx]
	        yout[ix,jx] = yin[ix]
	    end
	end
	
    return xout,yout
end