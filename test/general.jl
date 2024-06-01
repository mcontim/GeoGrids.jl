using Test
using GeoGrids
using StaticArrays

@testset "Internal Functions" begin
    @test GeoGrids.fibonaccisphere_classic(100; coord=:cart) isa Vector{SVector{3, Float64}}
    @test GeoGrids.fibonaccisphere_optimization1(100) isa Vector{SVector{3, Float64}}
    @test GeoGrids.fibonaccisphere_alternative1(100) isa Vector{SVector{3, Float64}}
end

@testset "Fibonacci Functions" begin
    @test fibonaccigrid(N=100;unit=:deg) isa Vector{SVector{2, Float64}}
    @test fibonaccigrid(N=100) isa Vector{SVector{2, Float64}}
    
    @test fibonaccigrid(sepAng=deg2rad(5);unit=:deg) isa Vector{SVector{2, Float64}}
    @test fibonaccigrid(sepAng=deg2rad(5)) isa Vector{SVector{2, Float64}}
end

@testset "Mesh Grid Functions" begin
    @test meshgrid(deg2rad(5); unit=:deg) isa Matrix{SVector{2, Float64}}
    @test meshgrid(deg2rad(5)) isa Matrix{SVector{2, Float64}}
end

using PlotlyBase

@testset "Plots Plotly Base" begin
    @test plot_unitarysphere(GeoGrids.fibonaccisphere_classic(100; coord=:cart)) isa Plot
    @test plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)))) isa Plot
    @test plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)));camera=:threedim) isa Plot
end

using PlutoPlotly

@testset "Plots Plotly Base" begin
    @test GeoGrids.plot_unitarysphere(GeoGrids.fibonaccisphere_classic(100; coord=:cart)) isa PlutoPlot
    @test GeoGrids.plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)))) isa PlutoPlot
    @test GeoGrids.plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)));camera=:threedim) isa PlutoPlot
end