using Test
using GeoGrids

@testset "Theory Notebook Functions" begin
    @test GeoGrids.fibonaccisphere_optimization1(100) isa Vector{SVector{3, Float64}}
    @test GeoGrids.fibonaccisphere_alternative1(100) isa Vector{SVector{3, Float64}}
end

@testset "Icogrid Functions" begin
    @test icogrid(100; coord=:cart) isa Vector{SVector{3, Float64}}
    @test icogrid(100; coord=:sphe) isa Vector{SVector{2, Float64}}
    
    @test icogrid_geo(N=100, height=0.0) isa Vector{LLA}
    @test icogrid_geo(N=100, type=:point) isa Vector{Point2}
    @test icogrid_geo(N=100, type=:point, unit=:deg) isa Vector{Point2}
    
    @test icogrid_geo(sepAng=deg2rad(5), height=0.0) isa Vector{LLA}
    @test icogrid_geo(sepAng=deg2rad(5), type=:point) isa Vector{Point2}
    @test icogrid_geo(sepAng=deg2rad(5), unit=:deg, type=:point) isa Vector{Point2}
    
    @test_logs (:warn, "Height is not provided, it will be set to 0 by default...") icogrid_geo(N=100)
    @test_logs (:warn, "Height is ignored when type is set to :point...") icogrid_geo(N=100, type=:point, height=0.0)
    @test_throws "The input type do not match the expected format, it must be :lla or :point..." icogrid_geo(N=100, type=:testerr, height=0.0)
    @test_throws "Input one argument between N and sepAng..." icogrid_geo(type=:testerr, height=0.0)
end

@testset "Mesh Grid Functions" begin
    @test meshgrid_geo(deg2rad(5); height=0.0) isa Matrix{LLA}
    @test meshgrid_geo(deg2rad(5); yRes=deg2rad(3), height=0.0) isa Matrix{LLA}
    @test meshgrid_geo(deg2rad(5); type=:point) isa Matrix{Point2}
    @test meshgrid_geo(deg2rad(5); unit=:deg, type=:point) isa Matrix{Point2}
    @test meshgrid_geo(deg2rad(5); yRes=deg2rad(3), type=:point) isa Matrix{Point2}

    @test_logs (:warn, "Height is not provided, it will be set to 0 by default...") meshgrid_geo(deg2rad(5)) 
    @test_logs (:warn, "Height is ignored when type is set to :point...") meshgrid_geo(deg2rad(5); height=0.0, type=:point)
    @test_throws "The input type do not match the expected format, it must be :lla or :point..." meshgrid_geo(deg2rad(5); type=:testerr)
    @test_throws "Resolution of x is too large, it must be smaller than π..." meshgrid_geo(deg2rad(181); height=0.0)
    @test_throws "Resolution of y is too large, it must be smaller than π..." meshgrid_geo(deg2rad(5); yRes=deg2rad(181), height=0.0)
end

@testset "Plots Plotly Base" begin
    using PlotlyBase
    @test plot_unitarysphere(icogrid(100; coord=:cart)) isa Plot
    @test plot_geo(icogrid_geo(sepAng=deg2rad(5), type=:point)) isa Plot
    @test plot_geo(icogrid_geo(sepAng=deg2rad(4), height=0.0); camera=:threedim) isa Plot
    @test plot_geo(meshgrid_geo(deg2rad(5); type=:point)) isa Plot
    @test plot_geo(meshgrid_geo(deg2rad(5); height=0.0); camera=:threedim) isa Plot
end

@testset "Filtering Functions" begin
    sample_ita = [(43.727878°,12.843441°), (43.714933°,10.399326°), (37.485829°,14.328285°), (39.330460°,8.430780°), (45.918388°,10.886654°)]
    sample_eu = [(52.218550°, 4.420621°), (41.353144°, 2.167639°), (42.670341°, 23.322592°)]
    
    ita = GeoRegion(;admin = "Italy")
    eu = GeoRegion(;continent = "Europe")
    
    sv_ita = map(x -> SVector(x...), sample_ita)
    p_ita = map(x -> Point2(x...), sample_ita)
    tup_ita = sample_ita
    lla_ita = map(x -> LLA(x..., 0.0), sample_ita)
    @test all(in_region(sv_ita, ita))
    @test all(in_region(p_ita, ita))
    @test all(in_region(tup_ita, ita))
    @test all(in_region(lla_ita, ita))
    
    sv_eu = map(x -> SVector(x...), sample_eu)
    p_eu = map(x -> Point2(x...), sample_eu)
    tup_eu = sample_eu
    lla_eu = map(x -> LLA(x..., 0.0), sample_eu)
    @test all(in_region(sv_eu, eu))
    @test all(in_region(p_eu, eu))
    @test all(in_region(tup_eu, eu))
    @test all(in_region(lla_eu, eu))

    @test in_region((0.7631954460103929,0.22416033273563304), ita)
    @test in_region((0.7631954460103929,0.22416033273563304), eu)
    @test !in_region((0.7085271959818754, -0.2072522112608427), eu)
    @test !in_region((52.218550°, 4.420621°), ita)
    
    @test_throws "LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." in_region((93.727878,0.22416033273563304), eu)
    @test_throws "LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." in_region((0.7631954460103929,-91.843441), eu)

    
    # add test for PolyRegion
    # add test for filter_points
end

# @testset "Helper Functions" begin
#     # Test all error messages and wrong input utilisation
#     # _check_geopoint(p::Union{AbstractVector, Tuple}) 
# end