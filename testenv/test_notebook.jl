### A Pluto.jl notebook ###
# v0.19.37

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

# ╔═╡ b5995830-daa5-4869-8274-92cb5ac76882
begin
	using LinearAlgebra
	using StaticArrays
	using AngleBetweenVectors
	using PlotlyBase
end

# ╔═╡ 5f32ed86-7613-4337-b6fd-bc42537baef1
begin
	using PlutoUI
	using PlutoExtras
	using PlutoExtras.StructBondModule
	using PlutoDevMacros
	using UUIDs
	using PlutoPlotly
	using MAT	
	using BenchmarkTools
end

# ╔═╡ 49b913f4-c717-4a8a-855d-cdb54b3e74b5
begin
	using GeoGrids
end

# ╔═╡ 6846c9d5-525c-4311-a2d7-a515923d5efa
# Export all functions from package for easy test
begin
	using GeoGrids: fibonaccisphere_classic,fibonaccisphere_optimization1,fibonaccisphere_alternative1,points_required_for_separation_angle,points_required_for_separation_angle_var1,points_required_for_separation_angle_var2,get_meshgrid,plot_geo,plot_unitarysphere
end

# ╔═╡ 8450f4d6-20e5-4459-9a21-2a2aeaf78de4
html"""
<style>
main {
    max-width: min(1000px, calc(95% - 200px));
    margin-right: 50px !important;
}
</style>
"""

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

# ╔═╡ 9cb4a573-a745-4314-a1ac-76ce01b9af55
md"""
#### Test by Number of Points
"""

# ╔═╡ c09b1bbf-dc06-4ff0-a660-d68708b6fa2f
md"""
#### Test by Separation Angle
"""

# ╔═╡ 589e967e-3373-4708-b3dc-e17eae300bdd
# @benchmark points_required_for_separation_angle(deg2rad(5))

# ╔═╡ 021472ba-6998-455d-a6d4-84a840f1412c
# @benchmark points_required_for_separation_angle_var1(deg2rad(5))

# ╔═╡ 58acf19c-e394-4bb5-8c2d-2cb266806c5d
# @benchmark points_required_for_separation_angle_var2(deg2rad(5))

# ╔═╡ 9549fdb3-af94-4b3f-ba22-043c4e8be52e
md"""
## Meshgrid
"""

# ╔═╡ 9b8cf4cc-39ed-461c-8cea-7b2cdd92f0f3
md"""
# Test vs old MATLAB implementation
"""

# ╔═╡ 45e2a04d-1414-4168-bca8-2ea557fb1cab
md"""
It is possible to see that the two methods do not exactly correspond but the freedom of exact number of points selection given by the Fibonacci Spiral gives the edge to the latter.
"""

# ╔═╡ 85e83e10-849c-4d57-9343-7328393e30b0
begin
	MATLABgridRes = "4"
	fibRes = 4
end;

# ╔═╡ 14178dd8-c96b-4db7-af7a-b89d08f1e060
begin
	file = matopen(joinpath("/home/mconti/Git/GitHub/GeoGrids.jl/assets/ico_grid", "ico_grid_$(MATLABgridRes).mat"))
	ut_lat_unsorted = read(file, "lat") 
	ut_lon_unsorted = read(file, "lon")
	ut_alt_unsorted = ones(size(ut_lat_unsorted)) .* 10e3
	close(file)

	svecMAT = []
	for ii=1:length(ut_lat_unsorted)
		push!(svecMAT,SVector(ut_lon_unsorted[ii],ut_lat_unsorted[ii]))
	end
end;

# ╔═╡ e3426da3-e213-49b2-917b-d58504eb1530
length(svecMAT)

# ╔═╡ d532c096-048d-49c5-ab95-b3d0520f85b9
points_required_for_separation_angle(deg2rad(fibRes))

# ╔═╡ 59a8f573-9413-4ff6-b2b9-707a83c361de
md"""
### Fibonacci
"""

# ╔═╡ 32e67099-d63f-4319-8f74-95e8c74d6e89
plot(plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(fibRes)))))

# ╔═╡ 857cec97-06d8-4d48-b335-8f358b65b39c
plot(plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(fibRes)));camera=:threedim))

# ╔═╡ 6191b1d1-2b46-410d-96a4-5c9e9835283a
md"""
### Icosahedron
"""

# ╔═╡ 136e0c87-9b04-4031-9bc7-8ec3acd0670f
plot(plot_geo(svecMAT))

# ╔═╡ 320f235b-b7fa-4752-93e3-f34cfe82fdbb
plot(plot_geo(svecMAT;camera=:threedim))

# ╔═╡ 8f4a39bf-cfdf-45ae-b7ca-357cc353a8bf
md"""
# Test LAT-LON :deg
"""

# ╔═╡ fe9d0374-824d-4756-b887-5a852aab9d68
md"""
# Check on Notebook status
"""

# ╔═╡ d6549e61-1eec-4ad3-83ad-5c2d5dc3685c
begin
"""
	struct TABLE
"""
Base.@kwdef struct TABLE
	n::Int 
	ang::Number
end
@fielddata TABLE begin
	n = (md"Number of Points to be generated:", Editable(1000))
	ang = (md"Target separation angle `[deg]`:", Editable(5.0))

end
tableVal_bond = @bind tableVal StructBond(TABLE; description = "Grid Parameters")
end

# ╔═╡ 173eb8a1-c2bb-4c73-8345-6b9f0f5b7d90
points1 = fibonaccisphere_classic(tableVal.n; coord=:cart)

# ╔═╡ 256e751b-d868-4b41-9f94-e54672a3f571
# plot() is used to wrap the Plot() output for a proper visualization. PlutoPlotly or PlutoJS are required in the notebook
plot(plot_unitarysphere(points1))

# ╔═╡ a5da23ce-9407-4120-9117-66ba9072aad7
# Check for the growing of point in Fibonacci spiral
plot(plot_unitarysphere(points1[1:20]))

# ╔═╡ 4e8c0d63-a135-490b-bcb5-7ae76fba2ec3
plot(plot_unitarysphere(fibonaccisphere_optimization1(tableVal.n)))

# ╔═╡ 5c1ed0da-e5f7-498c-8e46-570db5e258d8
plot(plot_unitarysphere(fibonaccisphere_alternative1(tableVal.n)))

# ╔═╡ ec3c88ba-972f-4b0f-ac25-75e779b1c33a
plot(plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg)))

# ╔═╡ f97a8555-086b-48f6-950e-fc583d0afa11
plot(plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg);camera=:threedim))

# ╔═╡ 900cc195-8c5a-47c0-a48b-e04baa15fc61
# Check for the growing of points in Fibonacci spiral
plot(plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg)[1:50]))

# ╔═╡ d005be58-3be7-4b2a-a3f7-edf0fd095259
# Check for the growing of points in Fibonacci spiral
plot(plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg)[1:50];camera=:threedim))

# ╔═╡ 6b1c8079-bab5-4951-b564-500bba378781
plot(plot_geo(fibonaccigrid(sepAng=deg2rad(tableVal.ang);unit=:deg)))

# ╔═╡ 88704126-cdc6-486f-bd68-e8fee558eac4
plot(plot_geo(fibonaccigrid(sepAng=deg2rad(tableVal.ang);unit=:deg);camera=:threedim))

# ╔═╡ f1d6ee2f-01d2-4b79-b326-cb202c58d74d
meshGrid = meshgrid(deg2rad(tableVal.ang); unit=:deg)

# ╔═╡ 3eeeffc0-3ba5-427b-b75b-0bf5f6286c9b
plot(plot_geo(vec(meshGrid)))

# ╔═╡ 00055125-7c7e-459e-b79e-f22e3d74866d
plot(plot_geo(vec(meshGrid); camera=:threedim))

# ╔═╡ 06a5260c-7d8c-42ad-895a-79f90df4040c
fibonaccigrid(N=tableVal.n, unit=:deg)

# ╔═╡ 4cb5958e-3d18-40ff-9100-42592e5ad1de
meshgrid(deg2rad(tableVal.ang); unit=:deg)

# ╔═╡ 8ed3bf0f-534e-4b12-a905-2b25b8c8e13a
BondTable([
	tableVal_bond,

]; description = "Grid Parameters")

# ╔═╡ b8cb81aa-9b26-4929-9b8c-551d59bc872b
collect(values(Revise.queue_errors))

# ╔═╡ 32ef4b79-5981-4d95-b437-60b80d4397bb
Revise.errors()

# ╔═╡ 8d7e7f4e-1e41-48dd-9469-2723f3a5930f
collect(values(Revise.queue_errors))[1][1].exc.msg

# ╔═╡ Cell order:
# ╠═347c69aa-a901-4a16-ac2e-8da3c314965e
# ╠═b5995830-daa5-4869-8274-92cb5ac76882
# ╠═5f32ed86-7613-4337-b6fd-bc42537baef1
# ╠═49b913f4-c717-4a8a-855d-cdb54b3e74b5
# ╠═8450f4d6-20e5-4459-9a21-2a2aeaf78de4
# ╠═ac88e13f-73dc-451c-b3f3-2a4b4a422f19
# ╠═6846c9d5-525c-4311-a2d7-a515923d5efa
# ╟─af33dff0-3b77-48e3-abab-d6a610123be9
# ╟─d111b9a5-2d79-4eb7-b577-7b186b68016c
# ╟─e78dca27-5288-4d90-a025-36790563c76b
# ╟─2dbe0a40-f961-41c5-8556-c0c2df83f9cf
# ╟─c63cac75-8eb1-47d2-88ef-7fbe418ae57b
# ╟─d91d92b4-0e7c-40fc-97d3-4ae6f731d121
# ╟─4457e406-3b1b-4237-b02d-767f76a0d6e2
# ╠═173eb8a1-c2bb-4c73-8345-6b9f0f5b7d90
# ╟─256e751b-d868-4b41-9f94-e54672a3f571
# ╟─a5da23ce-9407-4120-9117-66ba9072aad7
# ╟─e7e7a9d5-6f6c-45ab-b1cd-5a20a4569176
# ╟─85434a87-b158-44ed-ac2e-e2188b1228fa
# ╟─ea04e7ab-4fb8-4045-9015-f342d916c010
# ╟─0752c0d0-6ec6-4290-b15d-513f521698e4
# ╠═4e8c0d63-a135-490b-bcb5-7ae76fba2ec3
# ╟─e5a8a3aa-4a7a-4170-a543-e64ec79071b8
# ╟─3636cb43-10e0-465c-9d6a-e96f540a4acf
# ╟─01ca2945-7838-4fb7-aafc-3c646612b8ea
# ╠═5c1ed0da-e5f7-498c-8e46-570db5e258d8
# ╟─e687a108-7608-46cc-98a6-2e930886d022
# ╟─e5ab7623-f708-489b-a130-8e33eb985aa6
# ╟─d60e27a0-d518-475d-8a09-427fb42fd4c1
# ╟─9cb4a573-a745-4314-a1ac-76ce01b9af55
# ╠═ec3c88ba-972f-4b0f-ac25-75e779b1c33a
# ╠═f97a8555-086b-48f6-950e-fc583d0afa11
# ╠═900cc195-8c5a-47c0-a48b-e04baa15fc61
# ╠═d005be58-3be7-4b2a-a3f7-edf0fd095259
# ╟─c09b1bbf-dc06-4ff0-a660-d68708b6fa2f
# ╠═589e967e-3373-4708-b3dc-e17eae300bdd
# ╠═021472ba-6998-455d-a6d4-84a840f1412c
# ╠═58acf19c-e394-4bb5-8c2d-2cb266806c5d
# ╠═6b1c8079-bab5-4951-b564-500bba378781
# ╠═88704126-cdc6-486f-bd68-e8fee558eac4
# ╟─9549fdb3-af94-4b3f-ba22-043c4e8be52e
# ╠═f1d6ee2f-01d2-4b79-b326-cb202c58d74d
# ╠═3eeeffc0-3ba5-427b-b75b-0bf5f6286c9b
# ╠═00055125-7c7e-459e-b79e-f22e3d74866d
# ╟─9b8cf4cc-39ed-461c-8cea-7b2cdd92f0f3
# ╟─45e2a04d-1414-4168-bca8-2ea557fb1cab
# ╠═85e83e10-849c-4d57-9343-7328393e30b0
# ╠═14178dd8-c96b-4db7-af7a-b89d08f1e060
# ╠═e3426da3-e213-49b2-917b-d58504eb1530
# ╠═d532c096-048d-49c5-ab95-b3d0520f85b9
# ╟─59a8f573-9413-4ff6-b2b9-707a83c361de
# ╠═32e67099-d63f-4319-8f74-95e8c74d6e89
# ╠═857cec97-06d8-4d48-b335-8f358b65b39c
# ╟─6191b1d1-2b46-410d-96a4-5c9e9835283a
# ╠═136e0c87-9b04-4031-9bc7-8ec3acd0670f
# ╠═320f235b-b7fa-4752-93e3-f34cfe82fdbb
# ╟─8f4a39bf-cfdf-45ae-b7ca-357cc353a8bf
# ╠═06a5260c-7d8c-42ad-895a-79f90df4040c
# ╠═4cb5958e-3d18-40ff-9100-42592e5ad1de
# ╟─fe9d0374-824d-4756-b887-5a852aab9d68
# ╠═d6549e61-1eec-4ad3-83ad-5c2d5dc3685c
# ╠═8ed3bf0f-534e-4b12-a905-2b25b8c8e13a
# ╠═b8cb81aa-9b26-4929-9b8c-551d59bc872b
# ╠═32ef4b79-5981-4d95-b437-60b80d4397bb
# ╠═8d7e7f4e-1e41-48dd-9469-2723f3a5930f
