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
	using PlutoExtras.StructBondModule
	using PlutoDevMacros
	using HypertextLiteral
	using UUIDs
	using PlutoPlotly
	using LinearAlgebra
	using MAT
end

# ╔═╡ 49b913f4-c717-4a8a-855d-cdb54b3e74b5
begin
	using GeoGrids
end

# ╔═╡ 6846c9d5-525c-4311-a2d7-a515923d5efa
# Export all functions from package for easy test
begin
	using GeoGrids: plot_geo_2D,plot_geo_3D,plot_unitarysphere,fibonaccisphere_classic,fibonaccisphere_optimization1,fibonaccisphere_alternative1,points_required_for_separation_angle
end

# ╔═╡ 8450f4d6-20e5-4459-9a21-2a2aeaf78de4
html"""
<style>
main {
    max-width: min(1000px, calc(95% - 200px));
    margin-right: 150px !important;
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

# ╔═╡ de5322c4-e0d9-43db-b73c-74935fb20b2f
md"""
# Foce export of functions from package
"""

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
**NOTE:** In the following implementations ϕ is the angle from the North Pole ϕ ∈ [0,π] while θ is a sort of Longitude θ ∈ [0,2π], Mathematical notation for spherical coordinates
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

# ╔═╡ e7e7a9d5-6f6c-45ab-b1cd-5a20a4569176
md"""
## 2. Optimization #1 (Offset Fibonacci)
"""

# ╔═╡ 85434a87-b158-44ed-ac2e-e2188b1228fa
md"""
The function ```fibonaccisphere_optimization1()``` uses an optimization of the Fibonacci Sphere.
"""

# ╔═╡ ea04e7ab-4fb8-4045-9015-f342d916c010
md"""
This method is called **Offset Fibonacci** Lattice which is one method to optimize the minimum nearest-neighbor distance.

We need to move (offset) all the points slightly farther away from the poles. This of course means, that almost all of them become slightly closer together.

Offsetting the points of the Fibonacci lattice slightly away from the poles produces a packing that is up to 8.3% tighter than the canonical Fibonacci lattice and **affect the density of points at the poles**.

For $n>100$, an improvement can be made beyond this, by initially placing a point at each pole, and then placing the remaining $n-2$ points. This not only (very sightly) improves minimal nearest packing, but it also prevents a large gap at each pole.
"""

# ╔═╡ 0752c0d0-6ec6-4290-b15d-513f521698e4
md"""
The main source can be found at this [link](http://extremelearning.com.au/how-to-evenly-distribute-points-on-a-sphere-more-effectively-than-the-canonical-fibonacci-lattice/).
"""

# ╔═╡ e5a8a3aa-4a7a-4170-a543-e64ec79071b8
md"""
## 3. Alternatives
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

# ╔═╡ e687a108-7608-46cc-98a6-2e930886d022
md"""
# GEO Grids
"""

# ╔═╡ e5ab7623-f708-489b-a130-8e33eb985aa6
md"""
Here we test the GEO Grids (LAT-LON)
"""

# ╔═╡ d60e27a0-d518-475d-8a09-427fb42fd4c1
md"""
## Fibonacci
"""

# ╔═╡ 4a4e3121-3d6b-485f-9690-5000e1e01e87
# latlonPoints_fibonacci2 = fibonaccigrid(angle=0.25)

# ╔═╡ 601cd375-b40b-4d8a-98b3-9660adabdeff
# lol(deg2rad(1))

# ╔═╡ 6f89470d-ded3-4842-89e0-96b1c89b348a
function lol(angle)
    N = 2
	min_angle = 999
    while true
        points = fibonaccisphere_classic(N)
        for i in 1:N, j in 1:N
            if i != j
				temp = acos(dot(points[i,:],points[j,:]) / norm(points[i,:])*norm(points[j,:]))
                # angles[i,j] = acos(dot(points[i,:], points[j,:]))
				if temp < min_angle
					min_angle = temp
				end
            end
        end
        if min_angle <= angle
            return N
        end
        N += 1
		# if N>1000
		# 	return N
		# end
    end
end

# ╔═╡ e690615a-7678-4624-b0cc-43ae6af319f4
points = fibonaccisphere_classic(1000)

# ╔═╡ 9b8cf4cc-39ed-461c-8cea-7b2cdd92f0f3
md"""
# Test vs similar (previous) MATLAB implementation
"""

# ╔═╡ 85e83e10-849c-4d57-9343-7328393e30b0
MATLABgridRes = "32"

# ╔═╡ 14178dd8-c96b-4db7-af7a-b89d08f1e060
begin
	file = matopen(joinpath("/home/mconti/Git/GitHub/GeoGrids.jl/assets/ico_grid", "ico_grid_$(MATLABgridRes).mat"))
	ut_lat_unsorted = read(file, "lat") 
	ut_lon_unsorted = read(file, "lon")
	ut_alt_unsorted = ones(size(ut_lat_unsorted)) .* 10e3
	close(file)
end

# ╔═╡ e3426da3-e213-49b2-917b-d58504eb1530
ut_lat_unsorted

# ╔═╡ 7441b671-45dd-4117-baf4-19d27fb1bd52
lat = asin.(cart[:,3]) .* 180 / π

# ╔═╡ 54341997-6e51-4a49-bc27-8fc8bb91e929
lon = atan.(cart[:,2], cart[:,1]) .* 180 / π

# ╔═╡ f2925689-80a9-460c-aa64-40780ca0609d
plot_geo(lat,lon)

# ╔═╡ ecbb4bc9-3c10-45c6-a00d-b39d27ef3f90
plot_geo(latlon[:,1],latlon[:,2])

# ╔═╡ 281ce87b-9c81-4580-8425-537ec9efa36e
md"""
# Bonds
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
points1 = fibonaccisphere_classic(n; coord=:cart)

# ╔═╡ 5fd8a2d6-a1fb-40ca-bdc0-ffc403625592
points1[1][1]

# ╔═╡ 256e751b-d868-4b41-9f94-e54672a3f571
plot_unitarysphere(points1)

# ╔═╡ a5da23ce-9407-4120-9117-66ba9072aad7
# Check for the growing of point in Fibonacci spiral
plot_unitarysphere(points1[1:20,:])

# ╔═╡ 19f09d99-4b9f-40d2-b09d-551930d0e677
points2 = fibonaccisphere_optimization1(n)

# ╔═╡ 4e8c0d63-a135-490b-bcb5-7ae76fba2ec3
plot_unitarysphere(points2)

# ╔═╡ 37c0c4de-daba-4591-b19b-a15a8ebe75ad
points3 = fibonaccisphere_alternative1(n)

# ╔═╡ 5c1ed0da-e5f7-498c-8e46-570db5e258d8
plot_unitarysphere(points3)

# ╔═╡ fddf545c-2d3c-4c5f-bdd6-6e58302808e8
latlonPoints_fibonacci = rad2deg.(fibonaccisphere_classic(n)[:,1:2])

# ╔═╡ ec3c88ba-972f-4b0f-ac25-75e779b1c33a
plot_geo_2D(latlonPoints_fibonacci)

# ╔═╡ 900cc195-8c5a-47c0-a48b-e04baa15fc61
# Check for the growing of point in Fibonacci spiral
plot_geo_2D(latlonPoints_fibonacci[1:20,:])

# ╔═╡ fe9d0374-824d-4756-b887-5a852aab9d68
md"""
# Catch Revise Errors
"""

# ╔═╡ b8cb81aa-9b26-4929-9b8c-551d59bc872b
collect(values(Revise.queue_errors))

# ╔═╡ 32ef4b79-5981-4d95-b437-60b80d4397bb
Revise.errors()

# ╔═╡ 8d7e7f4e-1e41-48dd-9469-2723f3a5930f
collect(values(Revise.queue_errors))[1][1].exc.msg

# ╔═╡ Cell order:
# ╠═347c69aa-a901-4a16-ac2e-8da3c314965e
# ╠═5f32ed86-7613-4337-b6fd-bc42537baef1
# ╠═49b913f4-c717-4a8a-855d-cdb54b3e74b5
# ╠═8450f4d6-20e5-4459-9a21-2a2aeaf78de4
# ╠═e975f523-b6b0-4aca-8c74-22db0ec3a30f
# ╠═ac88e13f-73dc-451c-b3f3-2a4b4a422f19
# ╟─de5322c4-e0d9-43db-b73c-74935fb20b2f
# ╠═6846c9d5-525c-4311-a2d7-a515923d5efa
# ╟─af33dff0-3b77-48e3-abab-d6a610123be9
# ╟─7def6caf-2105-4230-9acc-7b3db15c7689
# ╟─d111b9a5-2d79-4eb7-b577-7b186b68016c
# ╟─e78dca27-5288-4d90-a025-36790563c76b
# ╟─2dbe0a40-f961-41c5-8556-c0c2df83f9cf
# ╟─c63cac75-8eb1-47d2-88ef-7fbe418ae57b
# ╟─d91d92b4-0e7c-40fc-97d3-4ae6f731d121
# ╟─4457e406-3b1b-4237-b02d-767f76a0d6e2
# ╠═2edabb82-7ac0-4b37-a947-b9e9e23ef00a
# ╠═5fd8a2d6-a1fb-40ca-bdc0-ffc403625592
# ╠═256e751b-d868-4b41-9f94-e54672a3f571
# ╠═a5da23ce-9407-4120-9117-66ba9072aad7
# ╟─e7e7a9d5-6f6c-45ab-b1cd-5a20a4569176
# ╟─85434a87-b158-44ed-ac2e-e2188b1228fa
# ╟─ea04e7ab-4fb8-4045-9015-f342d916c010
# ╟─0752c0d0-6ec6-4290-b15d-513f521698e4
# ╠═19f09d99-4b9f-40d2-b09d-551930d0e677
# ╠═4e8c0d63-a135-490b-bcb5-7ae76fba2ec3
# ╟─e5a8a3aa-4a7a-4170-a543-e64ec79071b8
# ╟─3636cb43-10e0-465c-9d6a-e96f540a4acf
# ╟─01ca2945-7838-4fb7-aafc-3c646612b8ea
# ╠═37c0c4de-daba-4591-b19b-a15a8ebe75ad
# ╠═5c1ed0da-e5f7-498c-8e46-570db5e258d8
# ╟─e687a108-7608-46cc-98a6-2e930886d022
# ╟─e5ab7623-f708-489b-a130-8e33eb985aa6
# ╟─d60e27a0-d518-475d-8a09-427fb42fd4c1
# ╠═fddf545c-2d3c-4c5f-bdd6-6e58302808e8
# ╠═ec3c88ba-972f-4b0f-ac25-75e779b1c33a
# ╠═900cc195-8c5a-47c0-a48b-e04baa15fc61
# ╠═4a4e3121-3d6b-485f-9690-5000e1e01e87
# ╠═601cd375-b40b-4d8a-98b3-9660adabdeff
# ╠═6f89470d-ded3-4842-89e0-96b1c89b348a
# ╠═e690615a-7678-4624-b0cc-43ae6af319f4
# ╟─9b8cf4cc-39ed-461c-8cea-7b2cdd92f0f3
# ╠═85e83e10-849c-4d57-9343-7328393e30b0
# ╠═14178dd8-c96b-4db7-af7a-b89d08f1e060
# ╠═e3426da3-e213-49b2-917b-d58504eb1530
# ╠═7441b671-45dd-4117-baf4-19d27fb1bd52
# ╠═54341997-6e51-4a49-bc27-8fc8bb91e929
# ╠═f2925689-80a9-460c-aa64-40780ca0609d
# ╠═ecbb4bc9-3c10-45c6-a00d-b39d27ef3f90
# ╟─281ce87b-9c81-4580-8425-537ec9efa36e
# ╠═75f1a094-72c2-49f5-a9b0-be0783a7f135
# ╟─fe9d0374-824d-4756-b887-5a852aab9d68
# ╠═b8cb81aa-9b26-4929-9b8c-551d59bc872b
# ╠═32ef4b79-5981-4d95-b437-60b80d4397bb
# ╠═8d7e7f4e-1e41-48dd-9469-2723f3a5930f
