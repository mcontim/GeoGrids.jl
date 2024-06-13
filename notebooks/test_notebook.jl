### A Pluto.jl notebook ###
# v0.19.41

#> custom_attrs = ["hide-enabled"]

using Markdown
using InteractiveUtils

# ╔═╡ cea38f6b-4eaf-4d4d-a882-81bf1e63e902
begin
	using PlutoUI
	using PlutoExtras
	using PlutoExtras.StructBondModule
	using PlutoDevMacros
	using PlutoPlotly
	using PlotlyBase
end

# ╔═╡ 6c7d8bc0-47aa-499b-a0fc-895828c43ec6
@fromparent begin
	import ^: * # to eport all functions from parent package
	using >. AngleBetweenVectors
	using >. CountriesBorders
    using >. LinearAlgebra
	using >. PlotlyExtensionsHelper
	using >. StaticArrays
	using >. TelecomUtils
	using >. Meshes
end

# ╔═╡ 9b06e2f7-cf71-4317-aecf-f44124ca9fde
begin
	using BenchmarkTools
	using PlutoVSCodeDebugger
	using Unzip
	using Unitful
end

# ╔═╡ 282b928a-fc7d-4487-a056-6c2626cf7179
ExtendedTableOfContents()

# ╔═╡ 2f988a76-9c84-432b-b69f-dbe06f32ea35


# ╔═╡ 0e205c7f-43ea-4612-830c-d930e8e4522f
md"""
# Test
"""

# ╔═╡ c9738f80-0297-46c4-b5ee-1a64ced99296
grid=meshgrid_geo(deg2rad(.5))

# ╔═╡ dcac9772-2c2c-431b-a568-ac91d483e470
poly = PolyRegion(regionName="POLY", domain=[LLA(10°,-5°,0), LLA(10°,15°,0), LLA(27°,15°,0), LLA(27°,-5°,0), LLA(10°,-5°,0)])

# ╔═╡ 2a77c856-6155-4759-bf50-aa3169d7494d
filt = filter_points(grid[:],poly)

# ╔═╡ 86362c31-7407-4c33-b24d-5e10a2a0858f
plot_geo(filt)

# ╔═╡ 163dd79f-a999-4630-9cbb-b1fb06ea8aa6
sample_border = [(10°,-5°), (10.1°,10°), (27°,15°)]

# ╔═╡ c58e75cb-3355-4c63-8eb9-1f364c6ec159
in_region(sample_border, poly)

# ╔═╡ 4eae9a7e-2c76-477d-a08f-fedffb259300
GeoRegion(;continent="Europe",domain=PolyArea(Point2(0.0,0.0), Point2(0.0,0.5), Point2(0.3,0.5), Point2(0.3,0.0), Point2(0.0,0.0)))

# ╔═╡ 90fb35a5-51d3-4f1a-b140-c95eb0fbfa15
PolyRegion(domain=[LLA(10°,-5°,0), LLA(10°,15°,0), LLA(27°,15°,0), LLA(27°,-5°,0), LLA(10°,-5°,0)])

# ╔═╡ 575501f7-50ea-450c-94ac-a1e484963aaf
PolyRegion(domain=[(10°,-5°), (10°,15°), (27°,15°), (27°,-5°), (10°,-5°)])

# ╔═╡ 1732096c-d89d-4c07-97e6-60973a6bbc1c
[(10°,-5°), (10°,15°), (27°,15°), (27°,-5°), (10°,-5°)] isa Vector{Tuple}

# ╔═╡ 2fe84091-4831-40af-a564-f67b17062732
methods(_check_angle)

# ╔═╡ 77a2eac3-c24b-4ab9-bf01-43d741674120
abs(-93.2244°)

# ╔═╡ a32a1633-134f-4363-96b0-65d511142ec0
93.2244°<pi/2

# ╔═╡ 02348c26-d666-4da3-9390-edbd6ca87027


# ╔═╡ 278fbecd-f240-4693-b65d-083b02aae797
www=meshgrid_geo(1;unit=:deg)

# ╔═╡ 658a8bf3-452a-4748-a24d-023200586516
a1=2.0

# ╔═╡ ac5eb1ce-aa4b-4a3e-ad05-ed47852d1c00
a3=5°

# ╔═╡ 54ae0273-62ae-45f2-ac1c-870014a098ac
typeof(ustrip(a3))

# ╔═╡ 620108e4-ed0c-4955-9e04-1d3fe9683aeb
a2=[1,3]

# ╔═╡ 2fc51681-33db-48a1-8cd0-939615dab9d5
reverse!(a2)

# ╔═╡ 219b93b6-34a2-4422-a971-da417033effd
a2

# ╔═╡ 68e99520-e513-4355-8871-70177c936b10
length((1,2))

# ╔═╡ 925e889f-1a4a-449f-b5dd-b5581a0d169f
typeof((1,2))

# ╔═╡ 4a96aafa-1313-444b-a5cb-cb56a1c5189f
SMatrix{3,3}([1 0 0;0 1 0;0 0 1])

# ╔═╡ 3e0a9404-9ec5-40bc-9074-2dee6efccb43
map(randn(3,3)) do v
	v*2
end

# ╔═╡ f429fdbe-4464-4ca5-a4ba-b7830c12d49f
s = "a"

# ╔═╡ a41c17a6-b650-4b92-939e-d79cd820ad27
isempty(s)

# ╔═╡ 542e9a43-44c4-4c88-b511-a4ffc3adc0b6
methods(StaticVector)

# ╔═╡ 152ae683-dbad-4c2c-9c4a-5e14a31d2748
md"""
## GeoRegion
"""

# ╔═╡ 40653a7f-bc4b-47f2-9006-6856bb89210e
r = GeoRegion(;continent = "Europe", admin="Italy")

# ╔═╡ 9c977c07-ce0e-4c38-bcac-b2a83cfb3544
GeoRegion(continent = "Europe", admin="Italy")

# ╔═╡ 974a09cd-fffb-40c6-b277-8a27fd827f92
methods(GeoRegion)

# ╔═╡ 8f960ccd-a95d-403f-a6f8-0c8da617c009
md"""
## PolyRegion
"""

# ╔═╡ 16558f4f-0d6c-4f0f-90fe-6f43b023f33e
methods(PolyRegion)

# ╔═╡ 01ce8e56-201c-47a6-b925-a1d95f816b60
methods(in_region)

# ╔═╡ 26ffbfb5-da79-45b1-bf77-ace20102699e
# ╠═╡ disabled = true
#=╠═╡
poly = PolyArea((0.0,0.0),(1.0,0.0),(1.0,1.0),(0.0,1.0),(0.0,0.0))
  ╠═╡ =#

# ╔═╡ 20d397c3-9d37-4fd1-b62c-c93b931d5c97
a = [(0.0,0.0),(1.0,0.0),(1.0,1.0),(0.0,1.0)]

# ╔═╡ 47d9109b-b546-4279-b2e4-061746214d56
Point2(a[1])

# ╔═╡ f9cf5ae3-661d-42f6-b30b-fd7ef3fb2879
b = [SVector(0.0,0.0),SVector(1.0,0.0),SVector(1.0,1.0),SVector(0.0,1.0),SVector(0.0,0.0)]

# ╔═╡ 704c0699-4c32-4039-996f-24b314e1f34b
Point2(b[1]) isa Point2

# ╔═╡ 4e508a67-c8b6-47f8-a160-420b7f881769
c = [Point(0.0,0.0),Point(1.0,0.0),Point(1.0,1.0),Point(0.0,1.0),Point(0.0,0.0)]

# ╔═╡ b496c282-4de8-442e-b96f-96158375b773
first(c[2].coords)

# ╔═╡ 03251cdd-55e1-4392-aebd-4e8d8679cf62
last(c[2].coords)

# ╔═╡ 49a31491-a55f-4fb5-b8f7-d037a346837c
typeof(c[1].coords)

# ╔═╡ 2e1e519f-0d5e-48b8-800b-f1159a796dca
c[1].coords isa Vec2

# ╔═╡ 73aff794-81c0-4d1c-89cd-b965415ad8d9
c[1].coords isa AbstractVector

# ╔═╡ 24b3a8e0-5624-402c-afc4-8203691dc913
c[1] isa Point2

# ╔═╡ f3a6771f-2e7a-446f-ade5-6fee0091ccb4
b[1] isa AbstractVector

# ╔═╡ e15afc1f-ea55-48c9-8fed-8c98e3ed60e1
a[1] isa Tuple

# ╔═╡ 5ba44a38-e391-42dc-a566-ec4552329073
length(a[1])

# ╔═╡ 60f4905c-6f6f-405a-bcf0-05110f5e05e3
AbstractVector{2}

# ╔═╡ 3052ad94-14f6-42f9-bbf1-ff744138d8a1
PolyRegion(domain=poly)

# ╔═╡ ee9f61e3-dd7c-40a8-b7a8-41009b4a3518
PolyRegion(domain=a)

# ╔═╡ 850942e4-95f3-4f07-9493-9c3e709cb080
PolyRegion(domain=b)

# ╔═╡ c74bde8a-74d3-45e9-9857-330d0f9ff411
PolyRegion(domain=c)

# ╔═╡ c21f4e70-77f0-4ea8-bf96-450820f2912d
nt=(continent="Europe", admin="")

# ╔═╡ c058ccea-4945-416f-9bed-0d1063e398a0
aaa=CountriesBorders.extract_countries(;nt...)

# ╔═╡ 1da7de55-cc23-4a51-93e7-21bfc4fcadfa
aaa.items[1].items[1].outer

# ╔═╡ 6cca736e-7006-4887-83f0-d15f49533903
md"""
# Packages
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoExtras = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PlutoVSCodeDebugger = "560812a8-17ff-4261-aab5-f8f600b273e2"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
Unzip = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"

[compat]
BenchmarkTools = "~1.5.0"
PlotlyBase = "~0.8.19"
PlutoDevMacros = "~0.7.4"
PlutoExtras = "~0.7.12"
PlutoPlotly = "~0.4.6"
PlutoUI = "~0.7.59"
PlutoVSCodeDebugger = "~0.2.0"
Unitful = "~1.20.0"
Unzip = "~0.2.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.3"
manifest_format = "2.0"
project_hash = "7bb0ff3e13f58e64aef4531a0caa51f3a83844d3"

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

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "f1dff6729bc61f4d49e140da1af55dcd1ac97b2f"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.5.0"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

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

[[deps.PlutoVSCodeDebugger]]
deps = ["AbstractPlutoDingetjes", "InteractiveUtils", "Markdown", "REPL"]
git-tree-sha1 = "888128e4c890f15b1a0eb847bfd54cf987a6bc77"
uuid = "560812a8-17ff-4261-aab5-f8f600b273e2"
version = "0.2.0"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

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

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "dd260903fdabea27d9b6021689b3cd5401a57748"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.20.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

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
# ╠═282b928a-fc7d-4487-a056-6c2626cf7179
# ╠═2f988a76-9c84-432b-b69f-dbe06f32ea35
# ╟─0e205c7f-43ea-4612-830c-d930e8e4522f
# ╠═86362c31-7407-4c33-b24d-5e10a2a0858f
# ╠═c9738f80-0297-46c4-b5ee-1a64ced99296
# ╠═2a77c856-6155-4759-bf50-aa3169d7494d
# ╠═dcac9772-2c2c-431b-a568-ac91d483e470
# ╠═163dd79f-a999-4630-9cbb-b1fb06ea8aa6
# ╠═c58e75cb-3355-4c63-8eb9-1f364c6ec159
# ╠═4eae9a7e-2c76-477d-a08f-fedffb259300
# ╠═90fb35a5-51d3-4f1a-b140-c95eb0fbfa15
# ╠═575501f7-50ea-450c-94ac-a1e484963aaf
# ╠═1732096c-d89d-4c07-97e6-60973a6bbc1c
# ╠═2fe84091-4831-40af-a564-f67b17062732
# ╠═77a2eac3-c24b-4ab9-bf01-43d741674120
# ╠═a32a1633-134f-4363-96b0-65d511142ec0
# ╠═02348c26-d666-4da3-9390-edbd6ca87027
# ╠═278fbecd-f240-4693-b65d-083b02aae797
# ╠═658a8bf3-452a-4748-a24d-023200586516
# ╠═ac5eb1ce-aa4b-4a3e-ad05-ed47852d1c00
# ╠═54ae0273-62ae-45f2-ac1c-870014a098ac
# ╠═620108e4-ed0c-4955-9e04-1d3fe9683aeb
# ╠═2fc51681-33db-48a1-8cd0-939615dab9d5
# ╠═219b93b6-34a2-4422-a971-da417033effd
# ╠═68e99520-e513-4355-8871-70177c936b10
# ╠═925e889f-1a4a-449f-b5dd-b5581a0d169f
# ╠═4a96aafa-1313-444b-a5cb-cb56a1c5189f
# ╠═3e0a9404-9ec5-40bc-9074-2dee6efccb43
# ╠═f429fdbe-4464-4ca5-a4ba-b7830c12d49f
# ╠═a41c17a6-b650-4b92-939e-d79cd820ad27
# ╠═542e9a43-44c4-4c88-b511-a4ffc3adc0b6
# ╟─152ae683-dbad-4c2c-9c4a-5e14a31d2748
# ╠═40653a7f-bc4b-47f2-9006-6856bb89210e
# ╠═9c977c07-ce0e-4c38-bcac-b2a83cfb3544
# ╠═974a09cd-fffb-40c6-b277-8a27fd827f92
# ╟─8f960ccd-a95d-403f-a6f8-0c8da617c009
# ╠═16558f4f-0d6c-4f0f-90fe-6f43b023f33e
# ╠═01ce8e56-201c-47a6-b925-a1d95f816b60
# ╠═26ffbfb5-da79-45b1-bf77-ace20102699e
# ╠═20d397c3-9d37-4fd1-b62c-c93b931d5c97
# ╠═47d9109b-b546-4279-b2e4-061746214d56
# ╠═704c0699-4c32-4039-996f-24b314e1f34b
# ╠═f9cf5ae3-661d-42f6-b30b-fd7ef3fb2879
# ╠═4e508a67-c8b6-47f8-a160-420b7f881769
# ╠═b496c282-4de8-442e-b96f-96158375b773
# ╠═03251cdd-55e1-4392-aebd-4e8d8679cf62
# ╠═49a31491-a55f-4fb5-b8f7-d037a346837c
# ╠═2e1e519f-0d5e-48b8-800b-f1159a796dca
# ╠═73aff794-81c0-4d1c-89cd-b965415ad8d9
# ╠═24b3a8e0-5624-402c-afc4-8203691dc913
# ╠═f3a6771f-2e7a-446f-ade5-6fee0091ccb4
# ╠═e15afc1f-ea55-48c9-8fed-8c98e3ed60e1
# ╠═5ba44a38-e391-42dc-a566-ec4552329073
# ╠═60f4905c-6f6f-405a-bcf0-05110f5e05e3
# ╠═3052ad94-14f6-42f9-bbf1-ff744138d8a1
# ╠═ee9f61e3-dd7c-40a8-b7a8-41009b4a3518
# ╠═850942e4-95f3-4f07-9493-9c3e709cb080
# ╠═c74bde8a-74d3-45e9-9857-330d0f9ff411
# ╠═c058ccea-4945-416f-9bed-0d1063e398a0
# ╠═1da7de55-cc23-4a51-93e7-21bfc4fcadfa
# ╠═c21f4e70-77f0-4ea8-bf96-450820f2912d
# ╟─6cca736e-7006-4887-83f0-d15f49533903
# ╠═6c7d8bc0-47aa-499b-a0fc-895828c43ec6
# ╠═cea38f6b-4eaf-4d4d-a882-81bf1e63e902
# ╠═9b06e2f7-cf71-4317-aecf-f44124ca9fde
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
