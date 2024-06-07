### A Pluto.jl notebook ###
# v0.19.41

#> custom_attrs = ["hide-enabled"]

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

# ╔═╡ ca17905e-687a-4603-ab2f-d651123a12d1
begin
	using PlutoUI
	using PlutoExtras
	using PlutoExtras.StructBondModule
	using PlutoDevMacros
	using PlutoPlotly
	using PlotlyBase
	using MAT	
end

# ╔═╡ 1aab6599-3b14-422d-acf6-3cbd953c555e
@fromparent begin
	import ^: * # to eport all functions from parent package
	using >. AngleBetweenVectors
	using >. CountriesBorders
    using >. LinearAlgebra
	using >. PlotlyExtensionsHelper
	using >. StaticArrays
end

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
	file = matopen(joinpath("./assets/ico_grid", "ico_grid_$(MATLABgridRes).mat"))
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
plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(fibRes))))

# ╔═╡ 857cec97-06d8-4d48-b335-8f358b65b39c
plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(fibRes)));camera=:threedim)

# ╔═╡ 6191b1d1-2b46-410d-96a4-5c9e9835283a
md"""
### Icosahedron
"""

# ╔═╡ 136e0c87-9b04-4031-9bc7-8ec3acd0670f
plot_geo(svecMAT)

# ╔═╡ 320f235b-b7fa-4752-93e3-f34cfe82fdbb
plot_geo(svecMAT;camera=:threedim)

# ╔═╡ 8f4a39bf-cfdf-45ae-b7ca-357cc353a8bf
md"""
# Test LAT-LON :deg
"""

# ╔═╡ 446c2ef6-1983-47d0-a390-17d2357d0f92
# ╠═╡ custom_attrs = ["toc-hidden"]
md"""
# Packages
"""

# ╔═╡ 8450f4d6-20e5-4459-9a21-2a2aeaf78de4
html"""
<style>
	body.static_preview pluto-helpbox {
		display: none;
	}
@media screen and (min-width: 2000px) {
	main {
	    max-width: min(1200px, calc(95% - 200px));
	    margin-right: 80px !important;
	}
}
</style>
"""

# ╔═╡ fe9d0374-824d-4756-b887-5a852aab9d68
# ╠═╡ custom_attrs = ["toc-hidden"]
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
plot_unitarysphere(points1)

# ╔═╡ a5da23ce-9407-4120-9117-66ba9072aad7
# Check for the growing of point in Fibonacci spiral
plot_unitarysphere(points1[1:20])

# ╔═╡ 4e8c0d63-a135-490b-bcb5-7ae76fba2ec3
plot_unitarysphere(fibonaccisphere_optimization1(tableVal.n))

# ╔═╡ 5c1ed0da-e5f7-498c-8e46-570db5e258d8
plot_unitarysphere(fibonaccisphere_alternative1(tableVal.n))

# ╔═╡ ec3c88ba-972f-4b0f-ac25-75e779b1c33a
plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg))

# ╔═╡ f97a8555-086b-48f6-950e-fc583d0afa11
plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg);camera=:threedim)

# ╔═╡ 900cc195-8c5a-47c0-a48b-e04baa15fc61
# Check for the growing of points in Fibonacci spiral
plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg)[1:50])

# ╔═╡ d005be58-3be7-4b2a-a3f7-edf0fd095259
# Check for the growing of points in Fibonacci spiral
plot_geo(fibonaccigrid(N=tableVal.n;unit=:deg)[1:50];camera=:threedim)

# ╔═╡ 6b1c8079-bab5-4951-b564-500bba378781
plot_geo(fibonaccigrid(sepAng=deg2rad(tableVal.ang);unit=:deg))

# ╔═╡ 88704126-cdc6-486f-bd68-e8fee558eac4
plot_geo(fibonaccigrid(sepAng=deg2rad(tableVal.ang);unit=:deg);camera=:threedim)

# ╔═╡ f1d6ee2f-01d2-4b79-b326-cb202c58d74d
meshGrid = meshgrid_geo(deg2rad(tableVal.ang); unit=:deg)

# ╔═╡ 3eeeffc0-3ba5-427b-b75b-0bf5f6286c9b
plot_geo(vec(meshGrid))

# ╔═╡ 00055125-7c7e-459e-b79e-f22e3d74866d
plot_geo(vec(meshGrid); camera=:threedim)

# ╔═╡ 06a5260c-7d8c-42ad-895a-79f90df4040c
fibonaccigrid(N=tableVal.n, unit=:deg)

# ╔═╡ 4cb5958e-3d18-40ff-9100-42592e5ad1de
meshgrid_geo(deg2rad(tableVal.ang); unit=:deg)

# ╔═╡ 8ed3bf0f-534e-4b12-a905-2b25b8c8e13a
BondTable([
	tableVal_bond,

]; description = "Grid Parameters")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
MAT = "23992714-dd62-5051-b70f-ba57cb901cac"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoExtras = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
MAT = "~0.10.7"
PlotlyBase = "~0.8.19"
PlutoDevMacros = "~0.7.4"
PlutoExtras = "~0.7.12"
PlutoPlotly = "~0.4.6"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "e9000912970992ae44f2ff7b66ce0d09cd24afbf"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BaseDirs]]
git-tree-sha1 = "cb25e4b105cc927052c2314f8291854ea59bf70a"
uuid = "18cc8868-cbac-4acf-b575-c8ff214dc66f"
version = "1.2.4"

[[deps.BufferedStreams]]
git-tree-sha1 = "4ae47f9a4b1dc19897d3743ff13685925c5202ec"
uuid = "e1450e63-4bb3-523b-b2a4-4ffa8c0fd77d"
version = "1.2.1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "59939d8a997469ee05c4b4944560a820f9ba0d73"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "4b270d6465eb21ae89b732182c20dc165f8bf9f2"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.25.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "b1c55339b7c6c350ee89f2c1604299660525b248"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.15.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.HDF5]]
deps = ["Compat", "HDF5_jll", "Libdl", "MPIPreferences", "Mmap", "Preferences", "Printf", "Random", "Requires", "UUIDs"]
git-tree-sha1 = "e856eef26cf5bf2b0f95f8f4fc37553c72c8641c"
uuid = "f67ccb44-e63f-5c2f-98bd-6dc0ccc4ba2f"
version = "0.17.2"

    [deps.HDF5.extensions]
    MPIExt = "MPI"

    [deps.HDF5.weakdeps]
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"

[[deps.HDF5_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "LibCURL_jll", "Libdl", "MPICH_jll", "MPIPreferences", "MPItrampoline_jll", "MicrosoftMPI_jll", "OpenMPI_jll", "OpenSSL_jll", "TOML", "Zlib_jll", "libaec_jll"]
git-tree-sha1 = "82a471768b513dc39e471540fdadc84ff80ff997"
uuid = "0234f1f7-429e-5d53-9886-15a909be8d59"
version = "1.14.3+3"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ca0f6bf568b4bfc807e7537f081c81e35ceca114"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.10.0+0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "8b72179abc660bfab5e28472e019392b97d0985c"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MAT]]
deps = ["BufferedStreams", "CodecZlib", "HDF5", "SparseArrays"]
git-tree-sha1 = "1d2dd9b186742b0f317f2530ddcbf00eebb18e96"
uuid = "23992714-dd62-5051-b70f-ba57cb901cac"
version = "0.10.7"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MPICH_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "4099bb6809ac109bfc17d521dad33763bcf026b7"
uuid = "7cb0a576-ebde-5e09-9194-50597f1243b4"
version = "4.2.1+1"

[[deps.MPIPreferences]]
deps = ["Libdl", "Preferences"]
git-tree-sha1 = "c105fe467859e7f6e9a852cb15cb4301126fac07"
uuid = "3da0fdf6-3ccc-4f1b-acd9-58baa6c99267"
version = "0.1.11"

[[deps.MPItrampoline_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "8c35d5420193841b2f367e658540e8d9e0601ed0"
uuid = "f1f71cc9-e9ae-5b93-9b94-4fe0e1ad3748"
version = "5.4.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MicrosoftMPI_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f12a29c4400ba812841c6ace3f4efbb6dbb3ba01"
uuid = "9237b28f-5490-5468-be7b-bb81f5f5e6cf"
version = "10.1.4+2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenMPI_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "e25c1778a98e34219a00455d6e4384e017ea9762"
uuid = "fe0851c0-eecd-5654-98d4-656369965a5c"
version = "4.1.6+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3da7367955dcc5c54c1ba4d402ccdc09a1a3e046"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.13+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlutoDevMacros]]
deps = ["AbstractPlutoDingetjes", "DocStringExtensions", "HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "c3839362a712e6d9c2845d179edafe74371cb77b"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.7.4"

[[deps.PlutoExtras]]
deps = ["AbstractPlutoDingetjes", "HypertextLiteral", "InteractiveUtils", "Markdown", "PlutoDevMacros", "PlutoUI", "REPL"]
git-tree-sha1 = "93d8c75734da9192d0639406fe6fb446be0fba4f"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.7.12"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "BaseDirs", "Colors", "Dates", "Downloads", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "Pkg", "PlotlyBase", "Reexport", "TOML"]
git-tree-sha1 = "1ae939782a5ce9a004484eab5416411c7190d3ce"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.4.6"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"
    UnitfulExt = "Unitful"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "ab55ee1510ad2af0ff674dbcced5e94921f867a9"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.59"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "a947ea21087caba0a798c5e494d0bb78e3a1a3a0"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.9"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libaec_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "46bf7be2917b59b761247be3f317ddf75e50e997"
uuid = "477f73a3-ac25-53e9-8cc3-50b2fa2566f0"
version = "1.1.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═ac88e13f-73dc-451c-b3f3-2a4b4a422f19
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
# ╟─5c1ed0da-e5f7-498c-8e46-570db5e258d8
# ╟─e687a108-7608-46cc-98a6-2e930886d022
# ╟─e5ab7623-f708-489b-a130-8e33eb985aa6
# ╟─d60e27a0-d518-475d-8a09-427fb42fd4c1
# ╟─9cb4a573-a745-4314-a1ac-76ce01b9af55
# ╟─ec3c88ba-972f-4b0f-ac25-75e779b1c33a
# ╟─f97a8555-086b-48f6-950e-fc583d0afa11
# ╟─900cc195-8c5a-47c0-a48b-e04baa15fc61
# ╟─d005be58-3be7-4b2a-a3f7-edf0fd095259
# ╟─c09b1bbf-dc06-4ff0-a660-d68708b6fa2f
# ╠═589e967e-3373-4708-b3dc-e17eae300bdd
# ╠═021472ba-6998-455d-a6d4-84a840f1412c
# ╠═58acf19c-e394-4bb5-8c2d-2cb266806c5d
# ╟─6b1c8079-bab5-4951-b564-500bba378781
# ╟─88704126-cdc6-486f-bd68-e8fee558eac4
# ╟─9549fdb3-af94-4b3f-ba22-043c4e8be52e
# ╠═f1d6ee2f-01d2-4b79-b326-cb202c58d74d
# ╟─3eeeffc0-3ba5-427b-b75b-0bf5f6286c9b
# ╟─00055125-7c7e-459e-b79e-f22e3d74866d
# ╟─9b8cf4cc-39ed-461c-8cea-7b2cdd92f0f3
# ╟─45e2a04d-1414-4168-bca8-2ea557fb1cab
# ╠═85e83e10-849c-4d57-9343-7328393e30b0
# ╠═14178dd8-c96b-4db7-af7a-b89d08f1e060
# ╠═e3426da3-e213-49b2-917b-d58504eb1530
# ╠═d532c096-048d-49c5-ab95-b3d0520f85b9
# ╟─59a8f573-9413-4ff6-b2b9-707a83c361de
# ╟─32e67099-d63f-4319-8f74-95e8c74d6e89
# ╟─857cec97-06d8-4d48-b335-8f358b65b39c
# ╟─6191b1d1-2b46-410d-96a4-5c9e9835283a
# ╟─136e0c87-9b04-4031-9bc7-8ec3acd0670f
# ╟─320f235b-b7fa-4752-93e3-f34cfe82fdbb
# ╟─8f4a39bf-cfdf-45ae-b7ca-357cc353a8bf
# ╠═06a5260c-7d8c-42ad-895a-79f90df4040c
# ╠═4cb5958e-3d18-40ff-9100-42592e5ad1de
# ╟─446c2ef6-1983-47d0-a390-17d2357d0f92
# ╠═1aab6599-3b14-422d-acf6-3cbd953c555e
# ╠═ca17905e-687a-4603-ab2f-d651123a12d1
# ╠═8450f4d6-20e5-4459-9a21-2a2aeaf78de4
# ╟─fe9d0374-824d-4756-b887-5a852aab9d68
# ╠═d6549e61-1eec-4ad3-83ad-5c2d5dc3685c
# ╠═8ed3bf0f-534e-4b12-a905-2b25b8c8e13a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
