### A Pluto.jl notebook ###
# v0.19.41

#> custom_attrs = ["hide-enabled"]

using Markdown
using InteractiveUtils

# ╔═╡ 0e3793aa-13d2-4aeb-ad60-b98927932dc6
begin
	using PlutoUI
	using PlutoExtras
	using PlutoExtras.StructBondModule
	using PlutoDevMacros
	using PlutoPlotly
	using PlotlyBase
end

# ╔═╡ 069444e1-4e89-4f4f-ae2f-f5fb3131e398
ExtendedTableOfContents()

# ╔═╡ 8717aaad-3791-40ec-82a3-3957fb10a562
md"""
# Test
"""

# ╔═╡ 222fb774-1693-4b3c-b2ef-5fd38eca773c
md"""
# Test Tessellation
"""

# ╔═╡ 2f6c6420-ffb5-4bb6-b757-1ce852c35e78
md"""
## Local grid on Earth
"""

# ╔═╡ 833103c3-9d4c-4c78-b83f-49e0c6b16104
md"""
- We use sphere a pproximation for the tasselltion which is a fair assumption for local grid.
- To increase precision we will also implement H3, however, it won't allow us full flexibility in terms of lattice spacing definition (as we have here with HEX grid).
"""

# ╔═╡ ea40cb99-2bf1-4225-84fe-e8aee4f7863a
begin
	# 1. Find lattice spacing as angular distance related to cell size
	Re = 6371e3 # Earth radius
	Rc = 10e3 # 10 km cell radius (circumscribed circle to hex cell)
	linSpacing = Rc*√3 # linear spacing between lattice points (considering a pointy topped formation to ease the toughts)
	θ = 2linSpacing/Re # equivalent angular spacing [rad]
end

# ╔═╡ b94c71b6-0601-4a4c-ac92-417f0c372334
md"""
# Packages
"""

# ╔═╡ bf20cace-b64b-4155-90c1-1ec3644510d7
@fromparent begin
	import ^: * # to eport all functions from parent package
	import >.CoordRefSystems
end

# ╔═╡ cd0f6997-c95c-4fd7-9be8-88d8dbcf760a
r = [
	GeoRegion(regionName="ITA", admin="Italy"), 
	PolyRegion(regionName="POLY", domain=[SimpleLatLon(-60°,-180°), SimpleLatLon(-60°,180°), SimpleLatLon(60°,180°), SimpleLatLon(60°,-180°)]),
	LatBeltRegion(regionName="test", latLim=(50°, 60°)),
	# LatBeltRegion(regionName="test", latLim=(45, 60)),
	# LatBeltRegion(regionName="test", latLim=((pi/4)rad, (pi/2)rad))
]

# ╔═╡ aed8268b-3432-434c-a764-03bfc49b6333
typeof(r)

# ╔═╡ 3a7b7e4e-8555-488f-be49-c82cac515376
SimpleLatLon(43.997568°, 11.647423°) in r[2]

# ╔═╡ 56cef4fa-7aea-40c8-83da-e6431ff9a915
SimpleLatLon(-70°, 11.647423°) in r

# ╔═╡ d2c92cda-1d17-49c0-82af-40da55db9ccd
methods(filter_points)

# ╔═╡ e05e7a8c-3957-4329-950c-7cc41383662f
points = [SimpleLatLon(43.997568°, 11.647423°), SimpleLatLon(-70°, 11.647423°)]

# ╔═╡ af171b47-c943-4d70-93cc-e55f1ef9d2c2
filter_points(points, r[1])

# ╔═╡ 8eb93dcd-118a-4988-a4bc-a59db70053ea
gr = group_by_domain(points, r; flagUnique=false)

# ╔═╡ 18a8cc75-79ae-49c2-8c7b-3ea6c318f383
gr["ITA"]

# ╔═╡ b638c73e-72d8-4140-aa7a-97d6293794a4
gr["POLY"]

# ╔═╡ f9a83ad1-ae48-429d-825f-a2db78c27d83
gr["test"]

# ╔═╡ b6dda362-d709-4628-aa45-a42ca377ee70
typeof(points)

# ╔═╡ 28aa42db-f470-4170-8f91-4b2897389fd5
SimpleLatLon(60°,180°).lat 

# ╔═╡ f33655ca-5da5-45af-9608-341bcb609477
aaa=extract_countries(GeoRegion(regionName="ITA", continent="Europe"))

# ╔═╡ 5a60a99f-ff3b-4867-86ba-03813a817430
aaa

# ╔═╡ d9334bde-6ae5-4da4-b8ed-b16bd9678785
extract_countries(GeoRegion(regionName="ITA", continent="Europe"))

# ╔═╡ 4ff0540b-c3ba-408f-894e-5fda86c0769d
plot_geo([SimpleLatLon(-70°, 11°),SimpleLatLon(-0°, 12°)])

# ╔═╡ 4bec169d-5243-439f-92e0-b623aaa1c31c
plot_unitarysphere([[1.0,1.0,1.0],[1.0,1.0,2.0]])

# ╔═╡ 404988a4-599e-42c7-a3c6-636dd40ad797
TilingInit(10.0)

# ╔═╡ 318449bb-6e70-46d0-adbb-ce5f3522d1fe
TilingInit(12, :ICO, GlobalRegion())

# ╔═╡ aa980a61-139b-4a46-a04c-4ce8552a2766
TilingInit(radius=12, type=:ICO)

# ╔═╡ 69ff22ae-93ac-466d-ba16-5a2521e1729e
begin
	# 2. Define the lattice
	aaaa = _generate_hex_lattice(1)
end

# ╔═╡ 1005c11c-1fef-4f3f-8cdf-d4b91d16fc60
# begin
# 	using BenchmarkTools
# 	using PlutoVSCodeDebugger
# 	using Unzip
# 	using Unitful
# end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoExtras = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlotlyBase = "~0.8.19"
PlutoDevMacros = "~0.9.0"
PlutoExtras = "~0.7.13"
PlutoPlotly = "~0.4.6"
PlutoUI = "~0.7.59"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.4"
manifest_format = "2.0"
project_hash = "94387de7a043c1bded01cc93904ca43c63fa39be"

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

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "c0216e792f518b39b22212127d4a84dc31e4e386"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.3.5"

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
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "a6adc2dcfe4187c40dc7c2c9d2128e326360e90a"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.32"

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
deps = ["JuliaInterpreter", "Logging", "MacroTools", "Pkg", "TOML"]
git-tree-sha1 = "72f65885168722413c7b9a9debc504c7e7df7709"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.9.0"

[[deps.PlutoExtras]]
deps = ["AbstractPlutoDingetjes", "DocStringExtensions", "HypertextLiteral", "InteractiveUtils", "Markdown", "PlutoUI", "REPL", "Random"]
git-tree-sha1 = "681f89bdd5c1da76b31a524af798efb5eb332ee9"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.7.13"

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
# ╠═069444e1-4e89-4f4f-ae2f-f5fb3131e398
# ╟─8717aaad-3791-40ec-82a3-3957fb10a562
# ╠═cd0f6997-c95c-4fd7-9be8-88d8dbcf760a
# ╠═3a7b7e4e-8555-488f-be49-c82cac515376
# ╠═56cef4fa-7aea-40c8-83da-e6431ff9a915
# ╠═af171b47-c943-4d70-93cc-e55f1ef9d2c2
# ╠═8eb93dcd-118a-4988-a4bc-a59db70053ea
# ╠═18a8cc75-79ae-49c2-8c7b-3ea6c318f383
# ╠═b638c73e-72d8-4140-aa7a-97d6293794a4
# ╠═f9a83ad1-ae48-429d-825f-a2db78c27d83
# ╠═b6dda362-d709-4628-aa45-a42ca377ee70
# ╠═d2c92cda-1d17-49c0-82af-40da55db9ccd
# ╠═e05e7a8c-3957-4329-950c-7cc41383662f
# ╠═aed8268b-3432-434c-a764-03bfc49b6333
# ╠═28aa42db-f470-4170-8f91-4b2897389fd5
# ╠═f33655ca-5da5-45af-9608-341bcb609477
# ╠═d9334bde-6ae5-4da4-b8ed-b16bd9678785
# ╠═5a60a99f-ff3b-4867-86ba-03813a817430
# ╠═4ff0540b-c3ba-408f-894e-5fda86c0769d
# ╠═4bec169d-5243-439f-92e0-b623aaa1c31c
# ╟─222fb774-1693-4b3c-b2ef-5fd38eca773c
# ╠═404988a4-599e-42c7-a3c6-636dd40ad797
# ╠═318449bb-6e70-46d0-adbb-ce5f3522d1fe
# ╠═aa980a61-139b-4a46-a04c-4ce8552a2766
# ╟─2f6c6420-ffb5-4bb6-b757-1ce852c35e78
# ╟─833103c3-9d4c-4c78-b83f-49e0c6b16104
# ╠═ea40cb99-2bf1-4225-84fe-e8aee4f7863a
# ╠═69ff22ae-93ac-466d-ba16-5a2521e1729e
# ╟─b94c71b6-0601-4a4c-ac92-417f0c372334
# ╠═bf20cace-b64b-4155-90c1-1ec3644510d7
# ╠═0e3793aa-13d2-4aeb-ad60-b98927932dc6
# ╠═1005c11c-1fef-4f3f-8cdf-d4b91d16fc60
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
