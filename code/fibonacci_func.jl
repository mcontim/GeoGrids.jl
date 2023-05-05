"""
	fibonaccisphere_classic(N::Int)
	
This function generates `N` uniformly distributed points on the surface of a unitary sphere using the classic Fibonacci spiral method as described in [1].

### Arguments:
- `N::Int`: The number of points to generate.
- `coord::Symbol`: The type of coordinates of generated points (`:sphe` | `:cart`).
- `radius`: the sphere radius in meters (unitary as default)

### Output:
- `N x 1` array containing the SVector of the generated points. Each element corresponds to a point on the surface of the sphere, the SVector contains either the x, y, and z (:cart) or lat, lon, alt (:sphe) coordinates of the point.

### References
1. http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/

### Example:

Generate 1000 uniformly distributed points on the surface of a sphere using the classic Fibonacci spiral method:

```
points = fibonaccisphere_classic(1000)
```
"""
function fibonaccisphere_classic(N::Int; coord::Symbol=:sphe, spheRadius=1.0)
	goldenRatio = (1 + sqrt(5))/2	
	if coord==:sphe # :sphe | :cart
		points = map(0:N-1) do k
			θ = 2π * k/ goldenRatio # [0,2π] [LON]
			ϕ = acos(1 - 2(k+0.5)/N) # [0,π] from North Pole [LAT]
			
			SVector(π/2 - ϕ, rem2pi(θ, RoundNearest), spheRadius) # wrap
		end
	else
		points = map(0:N-1) do k
			θ = 2π * k/ goldenRatio # [0,2π] [LON]
			ϕ = acos(1 - 2(k+0.5)/N) # [0,π] from North Pole [LAT]
			
			SVector(spheRadius.*sin(ϕ)*cos(θ), spheRadius.*sin(ϕ)*sin(θ), spheRadius.*cos(ϕ))
		end
	end

	return points
end


"""
	points_required_for_separation_angle(angle)

Given a separation angle in rad, returns the minimum number of points required on a unit sphere to ensure that no two points are closer than the specified angle using the Fibonacci spiral method.
Different Fibonacci spirals are gnereated iteritevily until the right N is found starting from N=2. 
The chek on points angular distances is limited to the first 20 generated points since their growth follw the Fibonacci spiral and it is possible to cover the worst case scenario (minimum angular distance) checking only few points. 

### Arguments:
- `angle::Float64`: the minimum desired separation angle between two points, in rad.

### Output:
- `N::Int` An integer indicating the minimum number of points required to satisfy the specified separation angle.
```
"""
function points_required_for_separation_angle(angle)

	# N = 2
	# while true
	# 	angles = zeros(N, N)
	# 	points = 
	# 	for k in 0:20
	# 		θ = 2π * k/ goldenRatio # [0,2π] [LON]
	# 		ϕ = acos(1 - 2(k+0.5)/N) # [0,π] from North Pole [LAT]
			
	# 		points[k+1,:] = [spheRadius.*sin(ϕ)*cos(θ), spheRadius.*sin(ϕ)*sin(θ), spheRadius.*cos(ϕ)]
	# 	end


    # cos_theta = cos(angle)
    # N
    # while true
    #     points = fibonaccisphere_classic(N)
    #     angles = zeros(N, N)
    #     for i in 1:N, j in 1:N
    #         if i != j

	# 			angles[i,j] = acos(dot(points[i,:],points[j,:]) / norm(points[i,:])*norm(points[j,:]))
    #             # angles[i,j] = acos(dot(points[i,:], points[j,:]))
    #         end
    #     end
    #     min_angle = minimum(angles)
    #     if min_angle > cos_theta
    #         return N
    #     end
    #     N += 1
	# 	if N>10
	# 		return N
	# 	end
    # end
end

"""
	fibonaccigrid(;N=nothing, angle=nothing)

This function call fibonaccisphere_classic(N) an returns a vector `Nx2` of LAT LON values for each of the points.

### Arguments:
- `N::Int`: The number of points to generate.

### Output:
- A `N x 2` matrix containing the generated points. Each row of the matrix corresponds to a point on the surface of the sphere, and the columns correspond to the LAT, LON coordinates of the point.
	
"""
function fibonaccigrid(;N=nothing, angle=nothing, altitude=1.0)	
	if N isa Nothing && angle isa Nothing
		error("Input one argument between N and angle...")
	elseif angle isa Nothing
		geoPoints = fibonaccisphere_classic(N; coord=:sphe, spheRadius=altitude)
	elseif N isa Nothing
		N = points_required_for_separation_angle(angle)
		geoPoints = fibonaccisphere_classic(N; coord=:sphe, spheRadius=altitude)
	else
		error("Input one argument between N and angle...")
	end

	return geoPoints
end

## Alternative implementations ------------------------------------------------------------------------------
# These implementations are here only for keep track of the alternatives and for future developement
"""
    fibonaccisphere_optimization1(N)

Create a set of `N` uniformly distributed points on the surface of a sphere using the Fibonacci spiral method optimized as described in [1].

This method is called Offset Fibonacci Lattice which is one method to optimize the minimum nearest-neighbor distance. 
We need to move (offset) all the points slightly farther away from the poles. This of course means, that almost all of them become slightly closer together. Offsetting the points of the Fibonacci lattice slightly away from the poles produces a packing that is up to 8.3% tighter than the canonical Fibonacci lattice.

For `n>100`, an improvement can be made beyond this, by initially placing a point at each pole, and then placing the remaining `n-2` points. This not only (very sightly) improves minimal nearest packing, but it also prevents a large gap at each pole.

### Arguments
- `N::Int`: The number of points to generate.

### Output
- `points::Matrix{Float64}`: A `N`x`3` matrix where each row corresponds to a point `(x,y,z)` on the surface of the unitary sphere.

### References
1. http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/

### Example
```julia
julia> fibonaccisphere_optimization1(100)
100×3 Matrix{Float64}:
 -0.0857561  -0.353764   -0.931232
 -0.420015    0.865954    0.271521
  0.109262   -0.92697     0.357822
  0.300392    0.68646     0.661058
  0.787932   -0.28247    -0.547211
  0.91193    -0.396059    0.109263
  0.655143    0.753931   -0.0427975
  0.366537   -0.155941    0.916388
  0.238012   -0.619806   -0.748564
  0.225831    0.116511    0.966097
  ⋮
```
"""
function fibonaccisphere_optimization1(N::Int)
	points = zeros(N,3)
	
	if N >= 600000
	  epsilon = 214
	elseif N >= 400000
	  epsilon = 75
	elseif N >= 11000
	  epsilon = 27
	elseif N >= 890
	  epsilon = 10
	elseif N >= 177
	  epsilon = 3.33
	elseif N >= 24
	  epsilon = 1.33
	else
	  epsilon = 0.33
	end
	
	goldenRatio = (1 + sqrt(5))/2
	for k in 0:N-1
		θ = 2π * k / goldenRatio # Longitude
		ϕ = acos(1 - 2*(k+epsilon)/(N-1+2*epsilon)) # Latitude
		points[k+1,:] = [sin(ϕ)*cos(θ), sin(ϕ)*sin(θ), cos(ϕ)]
	end

	return points
end

"""
	fibonaccisphere_alternative1(N::Int)

This function generates points on the surface of a unit sphere using the Fibonacci spiral method. The function takes an integer `N` as an input, which specifies the number of points to be generated.

### Arguments
- `N::Int`: The number of points to generate. This is an integer value.
### Output
- `N x 3` matrix containing the generated points. Each row of the matrix corresponds to a point on the surface of the sphere, and the columns correspond to the x, y, and z coordinates of the point.
"""
function fibonaccisphere_alternative1(N::Int)
	# //FIX: to be further tested 
	points = zeros(N,3)
	goldenSphere = π * (3.0 - sqrt(5.0))
	off = 2.0 / N

	for k in 0:N-1
		y = k * off - 1.0 + (off / 2.0)
		r = sqrt(1.0 - y * y)
		phi = k * goldenSphere
		points[k+1,:] = [cos(phi) * r, y, sin(phi) * r]
	end

	return points
end