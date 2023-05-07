function meshgrid(;N=nothing, gridRes=nothing)	
	if N isa Nothing && gridRes isa Nothing
		error("Input one argument between N and gridRes...")
	elseif gridRes isa Nothing
		# Find the separation angle corresponding to the Fibonacci Grid for that N
		this_gridRes = round(find_separation_angle(fibonaccisphere_classic_partial(N)); digits=2)
		geoPoints_vec,geoPoints_grid = get_meshgrid(-180:this_gridRes:180,-90:this_gridRes:90)
	elseif N isa Nothing
		geoPoints_vec,geoPoints_grid = get_meshgrid(-180:gridRes:180,-90:gridRes:90)
	else
		error("Input one argument between N and gridRes...")
	end

	return geoPoints_vec,geoPoints_grid
end

"""
	get_meshgrid(xin, yin)

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
	# vec = map((x,y) -> SVector(x,y), xout,yout)

    return vec,grid
end