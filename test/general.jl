using Test
using GeoGrids

@testset "Theory Notebook Functions" begin
    @test GeoGrids.fibonaccisphere_optimization1(100) isa Vector{SVector{3, Float64}}
    @test GeoGrids.fibonaccisphere_alternative1(100) isa Vector{SVector{3, Float64}}
end

@testset "Icogrid Functions" begin
    @test GeoGrids._icogrid(100; coord=:cart) isa Vector{SVector{3, Float64}}
    @test GeoGrids._icogrid(100; coord=:sphe) isa Vector{SVector{2, Float64}}
    
    @test icogrid(N=100, height=0.0) isa Vector{LLA}
    @test icogrid(N=100, type=:point) isa Vector{Point2}
    @test icogrid(N=100, type=:point, unit=:deg) isa Vector{Point2}
    
    @test icogrid(sepAng=deg2rad(5), height=0.0) isa Vector{LLA}
    @test icogrid(sepAng=deg2rad(5), type=:point) isa Vector{Point2}
    @test icogrid(sepAng=deg2rad(5), unit=:deg, type=:point) isa Vector{Point2}
    
    @test_logs (:warn, "Height is not provided, it will be set to 0 by default...") icogrid(N=100)
    @test_logs (:warn, "Height is ignored when type is set to :point...") icogrid(N=100, type=:point, height=0.0)
    @test_throws "The input type do not match the expected format, it must be :lla or :point..." icogrid(N=100, type=:testerr, height=0.0)
    @test_throws "Input one argument between N and sepAng..." icogrid(type=:testerr, height=0.0)
end

@testset "Mesh Grid Functions" begin
    @test meshgrid(deg2rad(5); height=0.0) isa Matrix{LLA}
    @test meshgrid(deg2rad(5); yRes=deg2rad(3), height=0.0) isa Matrix{LLA}
    @test meshgrid(deg2rad(5); type=:point) isa Matrix{Point2}
    @test meshgrid(deg2rad(5); unit=:deg, type=:point) isa Matrix{Point2}
    @test meshgrid(deg2rad(5); yRes=deg2rad(3), type=:point) isa Matrix{Point2}

    @test_logs (:warn, "Height is not provided, it will be set to 0 by default...") meshgrid(deg2rad(5)) 
    @test_logs (:warn, "Height is ignored when type is set to :point...") meshgrid(deg2rad(5); height=0.0, type=:point)
    @test_throws "The input type do not match the expected format, it must be :lla or :point..." meshgrid(deg2rad(5); type=:testerr)
    @test_throws "Resolution of x is too large, it must be smaller than π..." meshgrid(deg2rad(181); height=0.0)
    @test_throws "Resolution of y is too large, it must be smaller than π..." meshgrid(deg2rad(5); yRes=deg2rad(181), height=0.0)
end

@testset "Plots Plotly Base" begin
    using PlotlyBase
    @test plot_unitarysphere(GeoGrids._icogrid(100; coord=:cart)) isa Plot
    @test plot_geo(icogrid(sepAng=deg2rad(5), type=:point)) isa Plot
    @test plot_geo(icogrid(sepAng=deg2rad(4), height=0.0); camera=:threedim) isa Plot
    @test plot_geo(meshgrid(deg2rad(5); type=:point)) isa Plot
    @test plot_geo(meshgrid(deg2rad(5); height=0.0); camera=:threedim) isa Plot
end

@testset "Helper Functions" begin
    @test_throws "The input must be a 2D point..." GeoGrids._check_geopoint((0.0, 0.0, 0.0))
    @test_throws "The input must be a 2D point..." GeoGrids._check_geopoint([0.0, 0.0, 0.0])
    @test_throws "LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." GeoGrids._check_geopoint([pi/2+0.01, 0.0]; rev=true)
    @test_throws "LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." GeoGrids._check_geopoint([0.0, pi+0.01])

    p1 = [LLA(10°,-5°,0), LLA(10°,15°,0), LLA(27°,15°,0), LLA(27°,-5°,0), LLA(10°,-5°,0)]
    p2 = [Point2(10°,-5°), Point2(10°,15°), Point2(27°,15°), Point2(27°,-5°), Point2(10°,-5°)]
    p3 = [(10°,-5°), (10°,15°), (27°,15°), (27°,-5°), (10°,-5°)]
    p4 = [SVector(0.17453292519943295,-0.08726646259971647), SVector(0.17453292519943295,0.2617993877991494), SVector(0.47123889803846897,0.2617993877991494), SVector(0.47123889803846897,-0.08726646259971647), SVector(0.17453292519943295,-0.08726646259971647)]
    p5 = [[0.17453292519943295,-0.08726646259971647], [0.17453292519943295,0.2617993877991494], [0.47123889803846897,0.2617993877991494], [0.47123889803846897,-0.08726646259971647], [0.17453292519943295,-0.08726646259971647]]

    comp = map(x -> Point2(rad2deg.(x.coords)), p2)

    @test GeoGrids._check_geopoint(p1) == comp
    @test GeoGrids._check_geopoint(p2) == comp
    @test GeoGrids._check_geopoint(p3) == comp
    @test GeoGrids._check_geopoint(p4) == comp
    @test GeoGrids._check_geopoint(p5) == comp
end