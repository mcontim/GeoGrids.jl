### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 347c69aa-a901-4a16-ac2e-8da3c314965e
begin
  import Pkg
  Pkg.activate(Base.current_project(@__FILE__))
  using Revise
end

# ╔═╡ 5f32ed86-7613-4337-b6fd-bc42537baef1
begin
	using PlotlyBase
	using PlutoUI
	using PlutoExtras
	using PlutoDevMacros
	using HypertextLiteral
	using UUIDs
	using PlutoPlotly
	using PlotlyKaleido
end

# ╔═╡ 49b913f4-c717-4a8a-855d-cdb54b3e74b5
begin
	using GeoGrids
	using GeoGrids: plot_geo,fibonaccisphere_optimization1,fibonaccisphere_alternative1
end

# ╔═╡ 8450f4d6-20e5-4459-9a21-2a2aeaf78de4
html"""
<style>
main {
    max-width: min(1000px, calc(95% - 200px));
    margin-right: 350px !important;
}
</style>
"""

# ╔═╡ e975f523-b6b0-4aca-8c74-22db0ec3a30f
function position_fixed(x;left = 10, top = 10, width = 300, zindex = 500)
    id = "fixed_div_$(uuid4())"
    @htl """
    <div id=$id>
        $x
    </div>
    <style>
        #$id {
            position: fixed;
            top: $(top)px;
            left: $(left)px;
            width: $(width)px;
            z-index: $zindex;
        }
    </style>
    """
end;

# ╔═╡ ac88e13f-73dc-451c-b3f3-2a4b4a422f19
ExtendedTableOfContents()

# ╔═╡ af33dff0-3b77-48e3-abab-d6a610123be9
md"""
# Fibonacci Lattice
"""

# ╔═╡ d111b9a5-2d79-4eb7-b577-7b186b68016c
md"""
The problem of how to evenly distribute points on a sphere has a very long history. Unfortunately, except for a small handful of cases, it still has not been exactly solved. Therefore, in nearly all situations, we can merely hope to find near-optimal solutions to this problem.

Of these near-optimal solutions, one of the most common simple methods is one based on the **Fibonacci lattice** or the **Golden Spiral**. Furthermore, unlike many of the other iterative or randomised methods such a simulated annealing, the Fibonacci spiral is one of the few direct construction methods that works for arbitrary $n$.

The usual modern definition of the Fibonacci lattice, which evenly distributes $n$ points inside a unit square $[0,1)^2$ is:

$t_i = (x_i,y_i) = \biggl( \frac{i}{\phi}\%1, \frac{i}{n} \biggr)$

where $\phi = (1+\sqrt{5})/2$ is the **Golden Ratio** and the $(\cdot)\%1$ operator denotes the **fractional part of the argument**.
"""

# ╔═╡ e78dca27-5288-4d90-a025-36790563c76b
md"""
**NOTE:** In the following implementations ϕ is the angle from the North Pole ϕ ∈ [0,π] while θ is a sort of Longitude θ ∈ [0,2π] (Mathematical notation for spherical coordinates)
"""

# ╔═╡ 2dbe0a40-f961-41c5-8556-c0c2df83f9cf
md"""
## 1. Classical Implementation
"""

# ╔═╡ c63cac75-8eb1-47d2-88ef-7fbe418ae57b
md"""
The function ```fibonaccisphere_classic()``` uses calssical implementation of the Fibonacci Sphere.
"""

# ╔═╡ d91d92b4-0e7c-40fc-97d3-4ae6f731d121
md"""
This mapping has 2 main problems:
- The first is that this mapping is **area-preserving**, not distance-preserving. If you are attempting to optimize distance measures such as those related to nearest-neighbor, then it is not guaranteed that such distance-based constraints and relationships will hold after an area-based projection.
- The second, and from a pragmatic point of view possibly the trickiest to resolve, is that the spiral mapping has a **singularity** point at the centre (and the spherical mapping has a singularity at each pole)
"""

# ╔═╡ 4457e406-3b1b-4237-b02d-767f76a0d6e2
md"""
The main source can be found at this [link](http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/).
"""

# ╔═╡ 9fdf7569-cb6d-4a4a-bcfe-a5335927874f
function fibonacci_sphere_distribution_1bis(N::Int)
	cart = zeros(N, 3)
	latlon = zeros(N, 2)
	goldenRatio = (1 + sqrt(5))/2
	for k in 0:N-1
		θ = 2π * k/ goldenRatio # Longitude
		ϕ = acos(1 - 2(k+0.5)/N) # Latitude
		cart[k+1,:] = [sin(ϕ)*cos(θ), sin(ϕ)*sin(θ), cos(ϕ)]
		latlon[k+1,:] = [ϕ, θ]
	end

	return cart,latlon
end

# ╔═╡ c3f4e539-bc0b-4125-aa2c-5d4ccc685376
cart,latlon = fibonacci_sphere_distribution_1bis(2000)

# ╔═╡ 60827814-1ecf-443e-8446-d504bfddfea9
latlon .* 180/pi

# ╔═╡ 7441b671-45dd-4117-baf4-19d27fb1bd52
lat = asin.(cart[:,3]) .* 180 / π

# ╔═╡ 54341997-6e51-4a49-bc27-8fc8bb91e929
lon = atan.(cart[:,2], cart[:,1]) .* 180 / π

# ╔═╡ f2925689-80a9-460c-aa64-40780ca0609d
plot_geo(lat,lon)

# ╔═╡ ecbb4bc9-3c10-45c6-a00d-b39d27ef3f90
plot_geo(latlon[:,1],latlon[:,2])

# ╔═╡ e7e7a9d5-6f6c-45ab-b1cd-5a20a4569176
md"""
## 2. Optimization #1
"""

# ╔═╡ 0752c0d0-6ec6-4290-b15d-513f521698e4
md"""
The main source can be found at this [link](http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/).
"""

# ╔═╡ ea04e7ab-4fb8-4045-9015-f342d916c010
md"""
This method is called Offset Fibonacci Lattice which is one method to optimize the minimum nearest-neighbor distance.

We need to move (offset) all the points slightly farther away from the poles. This of course means, that almost all of them become slightly closer together.

Offsetting the points of the Fibonacci lattice slightly away from the poles produces a packing that is up to 8.3% tighter than the canonical Fibonacci lattice.

For $n>100$, an improvement can be made beyond this, by initially placing a point at each pole, and then placing the remaining $n-2$ points. This not only (very sightly) improves minimal nearest packing, but it also prevents a large gap at each pole.
"""

# ╔═╡ 75f1a094-72c2-49f5-a9b0-be0783a7f135
# Sim Parameters
begin
	n_bond = @bind n Editable(50)
end;

# ╔═╡ 7def6caf-2105-4230-9acc-7b3db15c7689
md"""
**Parameters:**
- Number of Points: $(n_bond)
""" |> x -> position_fixed(x;top = 65, left = 15, width = 350)

# ╔═╡ 2edabb82-7ac0-4b37-a947-b9e9e23ef00a
points1 = fibonaccisphere_classic(n)

# ╔═╡ a5da23ce-9407-4120-9117-66ba9072aad7
let
	# Reference Sphere
	n_sphere = 100
	u = range(-π, π; length = n_sphere)
	v = range(0, π; length = n_sphere)
	x_sphere = cos.(u) * sin.(v)'
	y_sphere = sin.(u) * sin.(v)'
	z_sphere = ones(n_sphere) * cos.(v)'
	color = ones(size(z_sphere))
	sphere = surface(z=z_sphere, x=x_sphere, y=y_sphere, surfacecolor = color, colorbar=false )
	
	markers = scatter3d(
				x = points1[:,1],
				y = points1[:,2],
				z = points1[:,3],
				mode = "markers",
				marker_size = 4,
				marker_color = "rgb(0,0,0)",
				)
	
	plot([sphere,markers])
end

# ╔═╡ 19f09d99-4b9f-40d2-b09d-551930d0e677
points2 = fibonaccisphere_optimization1(n)

# ╔═╡ af51160b-bb44-40dd-953d-79facfc76422
let
	# Reference Sphere
	n_sphere = 100
	u = range(-π, π; length = n_sphere)
	v = range(0, π; length = n_sphere)
	x_sphere = cos.(u) * sin.(v)'
	y_sphere = sin.(u) * sin.(v)'
	z_sphere = ones(n_sphere) * cos.(v)'
	color = ones(size(z_sphere))
	sphere = surface(z=z_sphere, x=x_sphere, y=y_sphere, surfacecolor = color, colorbar=false )
	
	markers = scatter3d(
				x = points2[:,1],
				y = points2[:,2],
				z = points2[:,3],
				mode = "markers",
				marker_size = 4,
				marker_color = "rgb(0,0,0)",
				)
	
	plot([sphere,markers])
end

# ╔═╡ e5a8a3aa-4a7a-4170-a543-e64ec79071b8
md"""
# 3. Alternatives
"""

# ╔═╡ 3636cb43-10e0-465c-9d6a-e96f540a4acf
md"""
### Code from ChatGPT
"""

# ╔═╡ 01ca2945-7838-4fb7-aafc-3c646612b8ea
md"""
The main source can be found at this [link here](https://chiellini.github.io/2020/10/06/fibonacci_spiral_sphere/).

The Fibonacci lattice is still used but here we use the **Golden Sphere** instead of **Golden Ratio**.

The results should be equivalent to the Classical implementation (to be verified)
"""

# ╔═╡ 37c0c4de-daba-4591-b19b-a15a8ebe75ad
points3 = fibonaccisphere_alternative1(n)

# ╔═╡ 73a05a74-17a9-467b-8049-5299060e2dd9
let
	# Reference Sphere
	n_sphere = 100
	u = range(-π, π; length = n_sphere)
	v = range(0, π; length = n_sphere)
	x_sphere = cos.(u) * sin.(v)'
	y_sphere = sin.(u) * sin.(v)'
	z_sphere = ones(n_sphere) * cos.(v)'
	color = ones(size(z_sphere))
	sphere = surface(z=z_sphere, x=x_sphere, y=y_sphere, surfacecolor = color, colorbar=false )
	
	markers = scatter3d(
				x = points3[:,1],
				y = points3[:,2],
				z = points3[:,3],
				mode = "markers",
				marker_size = 4,
				marker_color = "rgb(0,0,0)",
				)
	
	plot([sphere,markers])
end

# ╔═╡ Cell order:
# ╠═347c69aa-a901-4a16-ac2e-8da3c314965e
# ╠═5f32ed86-7613-4337-b6fd-bc42537baef1
# ╠═49b913f4-c717-4a8a-855d-cdb54b3e74b5
# ╠═8450f4d6-20e5-4459-9a21-2a2aeaf78de4
# ╠═e975f523-b6b0-4aca-8c74-22db0ec3a30f
# ╠═ac88e13f-73dc-451c-b3f3-2a4b4a422f19
# ╟─af33dff0-3b77-48e3-abab-d6a610123be9
# ╟─7def6caf-2105-4230-9acc-7b3db15c7689
# ╟─d111b9a5-2d79-4eb7-b577-7b186b68016c
# ╟─e78dca27-5288-4d90-a025-36790563c76b
# ╟─2dbe0a40-f961-41c5-8556-c0c2df83f9cf
# ╟─c63cac75-8eb1-47d2-88ef-7fbe418ae57b
# ╟─d91d92b4-0e7c-40fc-97d3-4ae6f731d121
# ╟─4457e406-3b1b-4237-b02d-767f76a0d6e2
# ╠═9fdf7569-cb6d-4a4a-bcfe-a5335927874f
# ╠═c3f4e539-bc0b-4125-aa2c-5d4ccc685376
# ╠═60827814-1ecf-443e-8446-d504bfddfea9
# ╠═7441b671-45dd-4117-baf4-19d27fb1bd52
# ╠═54341997-6e51-4a49-bc27-8fc8bb91e929
# ╠═f2925689-80a9-460c-aa64-40780ca0609d
# ╠═ecbb4bc9-3c10-45c6-a00d-b39d27ef3f90
# ╠═2edabb82-7ac0-4b37-a947-b9e9e23ef00a
# ╠═a5da23ce-9407-4120-9117-66ba9072aad7
# ╟─e7e7a9d5-6f6c-45ab-b1cd-5a20a4569176
# ╟─0752c0d0-6ec6-4290-b15d-513f521698e4
# ╟─ea04e7ab-4fb8-4045-9015-f342d916c010
# ╠═19f09d99-4b9f-40d2-b09d-551930d0e677
# ╠═af51160b-bb44-40dd-953d-79facfc76422
# ╠═75f1a094-72c2-49f5-a9b0-be0783a7f135
# ╟─e5a8a3aa-4a7a-4170-a543-e64ec79071b8
# ╟─3636cb43-10e0-465c-9d6a-e96f540a4acf
# ╟─01ca2945-7838-4fb7-aafc-3c646612b8ea
# ╠═37c0c4de-daba-4591-b19b-a15a8ebe75ad
# ╠═73a05a74-17a9-467b-8049-5299060e2dd9
