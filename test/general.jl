using Test
using GeoGrids
using StaticArrays

@testset "Theory Notebook Functions" begin
    @test GeoGrids.fibonaccisphere_optimization1(100) isa Vector{SVector{3, Float64}}
    @test GeoGrids.fibonaccisphere_alternative1(100) isa Vector{SVector{3, Float64}}
end

@testset "Icogrid Functions" begin
    @test icogrid(100; coord=:cart) isa Vector{SVector{3, Float64}}
    @test icogrid(100; coord=:sphe) isa Vector{SVector{2, Float64}}
    
    @test icogrid_geo(N=100, height=0.0) isa Vector{LLA}
    @test icogrid_geo(N=100, type=:point) isa Vector{Point2}
    
    @test icogrid_geo(sepAng=deg2rad(5), unit=:deg) isa Vector{LLA}
    @test icogrid_geo(sepAng=deg2rad(5), unit=:deg, type=:point) isa Vector{Point2}
    
    @test_logs (:warn, "Height is not provided, it will be set to 0 by default...") icogrid_geo(N=100)
    @test_logs (:warn, "Height is ignored when type is set to :point...") icogrid_geo(N=100, type=:point, height=0.0)
    @test_throws "The input type do not match the expected format, it must be :lla or :point..." icogrid_geo(N=100, type=:testerr, height=0.0)
    @test_throws "Input one argument between N and sepAng..." icogrid_geo(type=:testerr, height=0.0)
end

@testset "Mesh Grid Functions" begin
    @test meshgrid_geo(deg2rad(5); unit=:deg) isa Matrix{SVector{2, Float64}}
    @test meshgrid_geo(deg2rad(5)) isa Matrix{SVector{2, Float64}}
end

using PlotlyBase

@testset "Plots Plotly Base" begin
    @test plot_unitarysphere(icogrid(100; coord=:cart)) isa Plot
    @test plot_geo(map(x -> rad2deg.(x), icogrid_geo(sepAng=deg2rad(4)))) isa Plot
    @test plot_geo(map(x -> rad2deg.(x), icogrid_geo(sepAng=deg2rad(4)));camera=:threedim) isa Plot
end

using PlutoPlotly

@testset "Plots Plotly Base" begin
    @test GeoGrids.plot_unitarysphere(icogrid(100; coord=:cart)) isa PlutoPlot
    @test GeoGrids.plot_geo(map(x -> rad2deg.(x), icogrid_geo(sepAng=deg2rad(4)))) isa PlutoPlot
    @test GeoGrids.plot_geo(map(x -> rad2deg.(x), icogrid_geo(sepAng=deg2rad(4)));camera=:threedim) isa PlutoPlot
end