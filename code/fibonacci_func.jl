"""
	fibonaccisphere_classic(N::Int)
	
This function generates `N` uniformly distributed points on the surface of a unitary sphere using the classic Fibonacci spiral method as described in [1].

### Arguments:
- `N::Int`: The number of points to generate.

### Output:
- A `N x 3` matrix containing the generated points. Each row of the matrix corresponds to a point on the surface of the sphere, and the columns correspond to the x, y, and z coordinates of the point.

### References
1. http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/

### Example:

Generate 1000 uniformly distributed points on the surface of a sphere using the classic Fibonacci spiral method:

```
points = fibonaccisphere_classic(1000)
```
"""
function fibonaccisphere_classic(N::Int)
	points = zeros(N,3)
	goldenRatio = (1 + sqrt(5))/2
	for k in 0:N-1
		θ = 2π * k/ goldenRatio # Longitude
		ϕ = acos(1 - 2(k+0.5)/N) # Latitude
		points[k+1,:] = [sin(ϕ)*cos(θ), sin(ϕ)*sin(θ), cos(ϕ)]
	end

	return points
end

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

"""
	points_required_for_separation_angle(angle)

Given a separation angle in degrees, returns the minimum number of points required on a unit sphere to ensure that no two points are closer than the specified angle using the Fibonacci spiral method.

### Arguments:
- `angle::Float64`: the minimum desired separation angle between two points, in degrees.

### Output:
- `N::Int` An integer indicating the minimum number of points required to satisfy the specified separation angle.
```

The `points_required_for_separation_angle` function takes a `Float64` value `angle`, representing the minimum desired separation angle between two points on a unit sphere. The function returns an integer indicating the minimum number of points required to ensure that no two points are closer than the specified angle.

The function uses the formula for the surface area of a unit sphere and the formula for the surface area of a spherical cap to calculate the minimum number of points required to satisfy the specified separation angle.
"""
function points_required_for_separation_angle(angle)
    cos_theta = cos(angle)
    N = 2
    while true
        points = fibonaccisphere_classic(N)
        angles = zeros(N, N)
        for i in 1:N, j in 1:N
            if i != j
                angles[i, j] = acos(dot(points[i, :], points[j, :]))
            end
        end
        min_angle = minimum(angles)
        if min_angle > cos_theta
            return N
        end
        N += 1
    end
end

"""
	fibonaccigrid(N)

This function call fibonaccisphere_classic(N) an returns a vector `Nx2` of LAT LON values for each of the points.

### Arguments:
- `N::Int`: The number of points to generate.

### Output:
- A `N x 2` matrix containing the generated points. Each row of the matrix corresponds to a point on the surface of the sphere, and the columns correspond to the LAT, LON coordinates of the point.
	
"""
function fibonaccigrid(;N=nothing, angle=nothing)	
	if N isa nothing && angle isa Nothing
		error("Input one argument between N and angle...")
	elseif angle isa Nothing
		cartPoints = fibonaccisphere_classic(N)
	elseif N isa Nothing
		N = points_required_for_separation(angle)
		cartPoints = fibonaccisphere_classic(N)
	else
		error("Input one argument between N and angle...")
	end

	latlonPoints = zeros(N,2)
	latlonPoints[:,1] = acos.(cartPoints[:,3]) .* 180/π # lat
	latlonPoints[:,2] = atan.(cartPoints[:,2], cartPoints[:,1]) .* 180/π # lon (with atan2)

	return latlonPoints
end