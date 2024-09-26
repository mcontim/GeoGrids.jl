### A Pluto.jl notebook ###
# v0.19.46

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

# ╔═╡ 1005c11c-1fef-4f3f-8cdf-d4b91d16fc60
begin
	using BenchmarkTools
	using TelecomUtils
# 	using PlutoVSCodeDebugger
# 	using Unzip
# 	using Unitful
end

# ╔═╡ 069444e1-4e89-4f4f-ae2f-f5fb3131e398
ExtendedTableOfContents()

# ╔═╡ 0db4a84d-f4cf-4cea-8e6b-5b0480d3f6ff
md"""
# New Tests
"""

# ╔═╡ 31202468-8ba1-4d04-b630-1fcdd4bab97b
begin
	# polygon with two holes
	outer = [(0, 0), (1, 0), (1, 1), (0, 1)]
	poly = PolyArea(outer)

	poly2 = Meshes.apply(Repair(10),poly)
end

# ╔═╡ c82615c5-add5-4958-b80a-592b0c410317
function plot_two_polyareas(poly1::PolyArea, poly2::PolyArea; 
                            color1=:blue, color2=:red, 
                            name1="Polygon 1", name2="Polygon 2")
    # Convert PolyArea objects to arrays of coordinates
    coords1 = [(p.coords.x, p.coords.y) for p in vertices(poly1)]
    coords2 = [(p.coords.x, p.coords.y) for p in vertices(poly2)]

    # Create traces for each polygon
    trace1 = scatter(x=first.(coords1), y=last.(coords1), 
                     mode="lines", name=name1, 
                     line=attr(color=color1, width=2))
    
    trace2 = scatter(x=first.(coords2), y=last.(coords2), 
                     mode="lines", name=name2, 
                     line=attr(color=color2, width=2))

    # Create the layout
    layout = Layout(
        title="Comparison of Two Polygons",
        xaxis_title="X",
        yaxis_title="Y",
        xaxis=attr(scaleanchor="y", scaleratio=1),
        yaxis=attr(scaleanchor="x", scaleratio=1),
        showlegend=true
    )

    # Create and return the plot
    plot(Plot([trace1, trace2], layout))
end

# ╔═╡ 800e216c-5122-4198-b980-4288c951b116
vertices(poly)

# ╔═╡ 26ccaacf-de9e-47f2-8040-9c192985b77d
vertices(poly2)

# ╔═╡ c82aa8c1-7d6b-4f52-a0c5-4616c48b9e70
let
	original = poly
	enlarged =  poly2
	plot_two_polyareas(original, enlarged, name1="Original", name2="Enlarged")
end

# ╔═╡ 3ce21344-e0ea-4e41-b78e-cf92dc9ac2e7
md"""
# Definitions
"""

# ╔═╡ a34e4ff6-51f9-4d6b-af28-5e856adea1ed
begin
	const test_pair = (;admin="Greenland")
	polyVec = [
		PolyRegion(;domain=[LatLon(-5,-5), LatLon(5,-5), LatLon(5,10), LatLon(-5,10)]),
		PolyRegion(;domain=[LatLon(60,-5), LatLon(80,0), LatLon(80,10), LatLon(60,15)])
	]
	const polyReg = polyVec[2]
end

# ╔═╡ 56005d86-0377-4d40-b63b-d5597acddc32
gr = let
   ita = GeoRegion(; name="ITA", admin="Italy")
    eu = GeoRegion(; name="EU", continent="Europe")
    poly = PolyRegion("POLY", [LatLon(10°, -5°), LatLon(10°, 15°), LatLon(27°, 15°), LatLon(27°, -5°)])
    belt = LatBeltRegion(; name="BELT", lim=(-60°, 60°))
    
    sample_in_ita = [LatLon(43.727878°, 12.843441°), LatLon(43.714933°, 10.399326°), LatLon(37.485829°, 14.328285°), LatLon(39.330460°, 8.430780°), LatLon(45.918388°, 10.886654°)]
    sample_in_poly = [LatLon(14°, 1°), LatLon(26.9°, -4.9°), LatLon(10.1°, 14.9°)]
    sample_out_poly = [LatLon(0°, 0°), LatLon(10°, -5.2°), LatLon(27°, 15.3°)]
    sample_in_belt = [LatLon(14°, 1°), LatLon(26.9°, -65°), LatLon(10.1°, 70°)]
    sample_out_belt = [LatLon(90°, 1°), LatLon(60.1°, 1°), LatLon(-62°, -4.9°), LatLon(-60.1°, 14.9°)]

    big_vec = [sample_in_ita..., sample_in_poly..., sample_out_poly..., sample_in_belt..., sample_out_belt...]

    groups_unique = group_by_domain(big_vec, [ita, eu, poly, belt])
end

# ╔═╡ c8d4cd0e-0876-4c16-9146-12ed16516ebe
gr["ITA"]

# ╔═╡ 03485d5c-d7a3-475a-a9d4-8a43a101106c
Point[]

# ╔═╡ b2216550-1473-4062-8485-66af57f2fe37
    sample_in_ita = [LatLon(43.727878°, 12.843441°), LatLon(43.714933°, 10.399326°), LatLon(37.485829°, 14.328285°), LatLon(39.330460°, 8.430780°), LatLon(45.918388°, 10.886654°)]


# ╔═╡ 222fb774-1693-4b3c-b2ef-5fd38eca773c
md"""
# HEX Tessellation
"""

# ╔═╡ ca4efc79-7cf3-46de-b03e-643c29254818
md"""
## GeoRegion
"""

# ╔═╡ e0b2c99d-c689-48fb-91d5-6a3b4ee4d044
let 
	reg = GeoRegion(; name="Tassellation", admin="Spain")
	centers, ngon = generate_tesselation(reg, 40000, HEX(;pattern=:circ), EO())
	plot_geo_cells(centers, ngon)
end

# ╔═╡ ad9016de-1cce-4dc8-bdbf-2a2d65a4319f
let 
	reg = GeoRegion(; name="Tassellation", admin="Spain")
	centers, ngon = generate_tesselation(reg, 40000, HEX(;pattern=:circ), EO())
	plot_geo_cells(centers, ngon)
end

# ╔═╡ b12ae026-8fbb-4687-98df-f7a2fe9672b6
md"""
## PolyRegion
"""

# ╔═╡ f6c86dbf-a076-4905-8b34-d0587f153e3c
let 
	reg = polyReg
	centers, ngon = generate_tesselation(reg, 40000, HEX(), EO())
	plot_geo_cells(centers, ngon)
end

# ╔═╡ 0d67eaf0-5f74-43a0-8832-0b270334d3bc
let 
	reg = polyReg
	centers, ngon = generate_tesselation(reg, 40000, HEX(;pattern=:circ), EO())
	plot_geo_cells(centers, ngon)
end

# ╔═╡ 8f4f76bb-261f-412e-8b5f-005c0f469204
md"""
# ICO Tesselation
"""

# ╔═╡ 0c539be0-ebed-4f8f-bbd8-7efd206d1bac
md"""
## GlobalRegion
"""

# ╔═╡ efe29293-38f2-49c1-a426-25cdbe0d78c3
let 
	reg = GlobalRegion()
	centers,ngon = generate_tesselation(reg, 1000000, ICO(;pattern=:hex), EO())
	plot_geo_cells(centers,ngon)
end

# ╔═╡ 51c10eff-64a3-4883-a426-178edd3ec90e
md"""
## LatBeltRegion
"""

# ╔═╡ 62c46d72-8698-4e06-85a0-f2a5040a0c48
val=3/2

# ╔═╡ 3d6cfaea-c17e-4008-a0f8-ba262b1e7408
let 
	reg = LatBeltRegion(lim=(-10,10))
	centers,ngon = generate_tesselation(reg, 400000, ICO(;correction=val), EO())
	plot_geo_cells(centers,ngon)
end

# ╔═╡ a0f1257d-467a-4875-aad7-1b763d608ab4
let 
	reg = LatBeltRegion(lim=(-10,10))
	centers,ngon = generate_tesselation(reg, 400000, ICO(;pattern=:hex), EO())
	plot_geo_cells(centers,ngon)	
end

# ╔═╡ 23ce7f6e-4629-453b-9b7d-783a4620df7e
md"""
## PolyRegion
"""

# ╔═╡ f55e4340-0cb6-4fc5-9685-ccbbc3fedd15
let 
	reg = polyReg	
	centers,ngon = generate_tesselation(reg, 40000, ICO(;correction=1.7), EO())
	plot_geo_cells(centers,ngon)
end

# ╔═╡ e6860038-91c3-4fd9-b39e-4622963fa7a0
md"""
## GeoRegion
"""

# ╔═╡ c0cbcd3e-183d-425a-a534-06b2d52f1819
let 
	reg = GeoRegion(; name="Tassellation", admin="Spain")
	centers, ngon = generate_tesselation(reg, 40000, ICO(), EO())
	plot_geo_cells(centers,ngon)
end

# ╔═╡ d272905a-dfd4-4ade-88bd-ca10abf86f77
md"""
# Additional Functions
"""

# ╔═╡ d12aece5-8625-4667-9f65-6588f63849c4
function pattern_distance(pattern)
	mindist = []
	avgdist = []
	np = length(pattern)
	
	for i in 1:np
		p1 = pattern[i]
		lla1 = LLA(get_lat(p1), get_lon(p1))
		list = collect(1:np)
		popat!(list,i)
		vecDist = map(pattern[list]) do p2
			lla2 = LLA(get_lat(p2), get_lon(p2))
			get_distance_on_earth(lla1, lla2)
		end
		sort!(vecDist)
		push!(mindist, vecDist[1])
		push!(avgdist, sum(vecDist[1:6]) / 6)		
	end

	# avgMin = mindist
	# avgAvg = avgdist
	avgMin = sum(mindist) / length(mindist)
	avgAvg = sum(avgdist) / length(avgdist)
	
	return (; avgMin=avgMin, avgAvg=avgAvg)
end

# ╔═╡ 0365783a-36b7-4338-b629-4f754953986e
function testcenters(c)
	coeff = 1 / 2 * (2/√3)
	check = pattern_distance(c)
	@info check
	@info (hexNormMin=check.avgMin*coeff, hexNormAvg=check.avgAvg*coeff)
end

# ╔═╡ 7df04689-55fd-4659-b251-2100bf565580
aaa=let
	reg = GeoRegion(; name="Tassellation", test_pair...)
	centroid(LatLon,reg)
	centers = generate_tesselation(reg, 40000, HEX())
	testcenters(centers)
end

# ╔═╡ 3603a9e3-03cd-4861-a9af-b9d5657be13e
let 
	reg = GeoRegion(; name="Tassellation", test_pair...)
	centers = generate_tesselation(reg, 40000, HEX(;pattern=:circ))
	testcenters(centers)
end

# ╔═╡ 5068883b-686e-42f4-a209-9a49027145f3
let
	reg = polyReg
	centers = generate_tesselation(reg, 40000, HEX())
	testcenters(centers)
end

# ╔═╡ 3028363d-c4a4-4ead-9a41-3cd057f5f1d5
let 
	reg = polyReg
	centers = generate_tesselation(reg, 40000, HEX(;pattern=:circ))
	testcenters(centers)
end

# ╔═╡ 166ae596-02d5-40ac-a0c8-548a4f2f2954
let 
	reg = GlobalRegion()
	centers = generate_tesselation(reg, 1000000, ICO())
	testcenters(centers)
end

# ╔═╡ f66c2264-8477-47ab-819f-7f956e7dfb5b
let 
	reg = LatBeltRegion(lim=(-10,10))
	centers = generate_tesselation(reg, 400000, ICO(;correction=val))
	testcenters(centers)
end

# ╔═╡ 6e67a703-4aca-42b6-9bbe-e05a6b3d59d5
let 
	reg = LatBeltRegion(lim=(-10,10))
	centers = generate_tesselation(reg, 400000, ICO())
	testcenters(centers)
end

# ╔═╡ 3c5ef22a-21ba-4fa4-ba23-6cb0808c62e4
let 
	reg=polyReg
	centers = generate_tesselation(reg, 40000, ICO(;correction=1.7))
	testcenters(centers)
end

# ╔═╡ dc7902d2-c46f-4afd-831b-92d5d4c3bc93
let 
	reg = GeoRegion(; name="Tassellation", admin="Spain")
	centers = generate_tesselation(reg, 40000, ICO())
	testcenters(centers)
end

# ╔═╡ 42d4f2ee-1ba1-45f5-a7a2-58ea31bf1493
"""
    offset_polyarea(poly::PolyArea, offset::Real, direction::Symbol=:outward) -> PolyArea

Offset a PolyArea by a given amount in the specified direction.

# Arguments
- `poly::PolyArea`: The input polygon to be offset.
- `offset::Real`: The distance by which to offset the polygon.
- `direction::Symbol`: The direction of the offset, either `:outward` (default) or `:inward`.

# Returns
- `PolyArea`: A new PolyArea that is the result of offsetting the input polygon.

# Note
This function attempts to preserve the shape of the original polygon as much as possible.
For complex polygons or large offsets, some simplification may occur.
"""
function offset_polyarea(poly::PolyArea, offset::Real, direction::Symbol=:outward)
    # Ensure the direction is valid
    direction in [:outward, :inward] || throw(ArgumentError("Direction must be either :outward or :inward"))
    
    # Convert PolyArea to a polygon
    polygon = Polygon(poly)
    
    # Determine the sign of the offset based on the direction
    offset_sign = direction == :outward ? 1 : -1
    
    # Get the boundary of the polygon
    boundary = GeoInterface.coordinates(polygon)[1]
    
    # Offset each edge of the polygon
    offsetted_points = offset_polygon_edges(boundary, offset * offset_sign)
    
    # Create a new PolyArea from the offsetted points
    PolyArea([Point(p) for p in offsetted_points])
end

# ╔═╡ 8f72b4d2-d32d-46d6-a935-97882c583f91
"""
    offset_polygon_edges(points::Vector{<:Point}, offset::Real) -> Vector{Point}

Offset the edges of a polygon defined by a sequence of points.

# Arguments
- `points::Vector{<:Point}`: The sequence of points defining the polygon.
- `offset::Real`: The distance by which to offset the edges.

# Returns
- `Vector{Point}`: A new sequence of points defining the offsetted polygon.
"""
function offset_polygon_edges(points::Vector{<:Point}, offset::Real)
    n = length(points)
    offsetted_points = similar(points)
    
    for i in 1:n
        prev = points[mod1(i-1, n)]
        curr = points[i]
        next = points[mod1(i+1, n)]
        
        # Calculate edge normals
        v1 = curr - prev
        v2 = next - curr
        n1 = Point(-v1.y, v1.x)
        n2 = Point(-v2.y, v2.x)
        
        # Normalize and scale normals
        n1 = n1 / √(n1.x^2 + n1.y^2) * offset
        n2 = n2 / √(n2.x^2 + n2.y^2) * offset
        
        # Calculate offset points
        p1 = curr + n1
        p2 = curr + n2
        
        # Intersect offset lines to get new corner point
        offsetted_points[i] = line_intersection(prev + n1, p1, p2, next + n2)
    end
    
    offsetted_points
end

# ╔═╡ d9c8e6e6-ace3-41dd-a58c-3f768f7ed6c2
"""
    line_intersection(p1::Point, p2::Point, p3::Point, p4::Point) -> Point

Calculate the intersection point of two lines defined by two points each.

# Arguments
- `p1::Point`, `p2::Point`: Two points defining the first line.
- `p3::Point`, `p4::Point`: Two points defining the second line.

# Returns
- `Point`: The intersection point of the two lines.
"""
function line_intersection(p1::Point, p2::Point, p3::Point, p4::Point)
    x1, y1 = p1.x, p1.y
    x2, y2 = p2.x, p2.y
    x3, y3 = p3.x, p3.y
    x4, y4 = p4.x, p4.y
    
    den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    if den == 0
        # Lines are parallel, return midpoint
        return Point((x1 + x2 + x3 + x4) / 4, (y1 + y2 + y3 + y4) / 4)
    end
    
    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
    
    x = x1 + t * (x2 - x1)
    y = y1 + t * (y2 - y1)
    
    Point(x, y)
end

# ╔═╡ 791e2437-51c4-4145-99db-a456566d6f3a
"""
    plot_offset_comparison(original::PolyArea, offset::PolyArea)

Plot the original and offset PolyArea objects for comparison.

# Arguments
- `original::PolyArea`: The original polygon
- `offset::PolyArea`: The offset polygon

# Returns
- `Plot`: A plot object showing both polygons
"""
function plot_offset_comparison(original::PolyArea, offset::PolyArea)
    # Convert PolyArea objects to arrays of coordinates
    original_coords = [(p.x, p.y) for p in original.points]
    offset_coords = [(p.x, p.y) for p in offset.points]
    
    # Create the plot
    p = plot(
        legend=:topright,
        aspect_ratio=:equal,
        title="Original vs Offset Polygon",
        xlabel="X",
        ylabel="Y"
    )
    
    # Plot original polygon
    plot!(p, first.(original_coords), last.(original_coords), 
          label="Original", color=:blue, linewidth=2)
    
    # Plot offset polygon
    plot!(p, first.(offset_coords), last.(offset_coords), 
          label="Offset", color=:red, linewidth=2, linestyle=:dash)
    
    # Add markers for vertices
    scatter!(p, first.(original_coords), last.(original_coords), 
             label="Original Vertices", color=:blue, markersize=4)
    scatter!(p, first.(offset_coords), last.(offset_coords), 
             label="Offset Vertices", color=:red, markersize=4)
    
    return p
end

# ╔═╡ 93c5ccd7-0563-49f0-846f-fd450afd7165
let
 	# Create a sample polygon (a simple pentagon)
    original = PolyArea([
        Point(0.0, 0.0),
        Point(1.0, 0.0),
        Point(1.5, 0.866),
        Point(0.5, 1.366),
        Point(-0.5, 0.866)
    ])

    # Compute an enlarged version of the polygon
    offset_distance = 0.2
    enlarged = offset_polyarea(original, offset_distance)

    # Plot the original and enlarged polygons
    plot_offset_comparison(original, enlarged)
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

# ╔═╡ Cell order:
# ╠═069444e1-4e89-4f4f-ae2f-f5fb3131e398
# ╟─0db4a84d-f4cf-4cea-8e6b-5b0480d3f6ff
# ╠═31202468-8ba1-4d04-b630-1fcdd4bab97b
# ╠═c82615c5-add5-4958-b80a-592b0c410317
# ╠═800e216c-5122-4198-b980-4288c951b116
# ╠═26ccaacf-de9e-47f2-8040-9c192985b77d
# ╠═c82aa8c1-7d6b-4f52-a0c5-4616c48b9e70
# ╟─3ce21344-e0ea-4e41-b78e-cf92dc9ac2e7
# ╠═a34e4ff6-51f9-4d6b-af28-5e856adea1ed
# ╠═56005d86-0377-4d40-b63b-d5597acddc32
# ╠═c8d4cd0e-0876-4c16-9146-12ed16516ebe
# ╠═03485d5c-d7a3-475a-a9d4-8a43a101106c
# ╠═b2216550-1473-4062-8485-66af57f2fe37
# ╟─222fb774-1693-4b3c-b2ef-5fd38eca773c
# ╟─ca4efc79-7cf3-46de-b03e-643c29254818
# ╠═e0b2c99d-c689-48fb-91d5-6a3b4ee4d044
# ╠═7df04689-55fd-4659-b251-2100bf565580
# ╠═ad9016de-1cce-4dc8-bdbf-2a2d65a4319f
# ╠═3603a9e3-03cd-4861-a9af-b9d5657be13e
# ╟─b12ae026-8fbb-4687-98df-f7a2fe9672b6
# ╠═f6c86dbf-a076-4905-8b34-d0587f153e3c
# ╠═5068883b-686e-42f4-a209-9a49027145f3
# ╠═0d67eaf0-5f74-43a0-8832-0b270334d3bc
# ╠═3028363d-c4a4-4ead-9a41-3cd057f5f1d5
# ╟─8f4f76bb-261f-412e-8b5f-005c0f469204
# ╟─0c539be0-ebed-4f8f-bbd8-7efd206d1bac
# ╠═efe29293-38f2-49c1-a426-25cdbe0d78c3
# ╠═166ae596-02d5-40ac-a0c8-548a4f2f2954
# ╟─51c10eff-64a3-4883-a426-178edd3ec90e
# ╠═62c46d72-8698-4e06-85a0-f2a5040a0c48
# ╠═3d6cfaea-c17e-4008-a0f8-ba262b1e7408
# ╠═f66c2264-8477-47ab-819f-7f956e7dfb5b
# ╠═a0f1257d-467a-4875-aad7-1b763d608ab4
# ╠═6e67a703-4aca-42b6-9bbe-e05a6b3d59d5
# ╟─23ce7f6e-4629-453b-9b7d-783a4620df7e
# ╠═f55e4340-0cb6-4fc5-9685-ccbbc3fedd15
# ╠═3c5ef22a-21ba-4fa4-ba23-6cb0808c62e4
# ╠═e6860038-91c3-4fd9-b39e-4622963fa7a0
# ╠═c0cbcd3e-183d-425a-a534-06b2d52f1819
# ╠═dc7902d2-c46f-4afd-831b-92d5d4c3bc93
# ╟─d272905a-dfd4-4ade-88bd-ca10abf86f77
# ╠═d12aece5-8625-4667-9f65-6588f63849c4
# ╠═0365783a-36b7-4338-b629-4f754953986e
# ╠═42d4f2ee-1ba1-45f5-a7a2-58ea31bf1493
# ╠═8f72b4d2-d32d-46d6-a935-97882c583f91
# ╠═d9c8e6e6-ace3-41dd-a58c-3f768f7ed6c2
# ╠═791e2437-51c4-4145-99db-a456566d6f3a
# ╠═93c5ccd7-0563-49f0-846f-fd450afd7165
# ╟─b94c71b6-0601-4a4c-ac92-417f0c372334
# ╠═bf20cace-b64b-4155-90c1-1ec3644510d7
# ╠═0e3793aa-13d2-4aeb-ad60-b98927932dc6
# ╠═1005c11c-1fef-4f3f-8cdf-d4b91d16fc60
