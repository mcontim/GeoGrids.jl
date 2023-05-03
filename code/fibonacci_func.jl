function fibonaccisphere_classic(N::Int)
	points = zeros(N, 3)
	goldenRatio = (1 + sqrt(5))/2
	for k in 0:N-1
		θ = 2π * k/ goldenRatio # Longitude
		ϕ = acos(1 - 2(k+0.5)/N) # Latitude
		points[k+1,:] = [sin(ϕ)*cos(θ), sin(ϕ)*sin(θ), cos(ϕ)]
	end

	return points
end

function fibonaccisphere_optimization1(N::Int)
	points = zeros(N, 3)
	
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
	points = zeros(N, 3)
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