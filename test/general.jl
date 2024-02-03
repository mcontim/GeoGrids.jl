using Test
using GeoGrids

# Test that this thorws 
@test_throws "No PlotlyBase package has been loaded" GeoGrids._plotly_plot(3)

using PlotlyBase

@testset "Plots Unitary Sphere" begin
    points1 = GeoGrids.fibonaccisphere_classic(100; coord=:cart)
    GeoGrids.plot_unitarysphere(points1)
end

# @testset "Plots Plotly Base" begin
#     @test GeoGrids.plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)))) isa Plot
#     @test GeoGrids.plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)));camera=:threedim) isa Plot
# end

# using PlutoPlotly

# @testset "Plots Plotly Base" begin
#     @test GeoGrids.plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)))) isa PlutoPlot
#     @test GeoGrids.plot_geo(map(x -> rad2deg.(x), fibonaccigrid(sepAng=deg2rad(4)));camera=:threedim) isa PlutoPlot
# end