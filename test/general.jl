using Test
using GeoGrids

# Test that this thorws 
@test_throws "No PlotlyBase package has been loaded" GeoGrids._plotly_plot(3)

using PlotlyBase

initEpoch = now()
initEpoch_julian = initEpoch |> datetime2julian
orb_file_contents = strip("""
|   ConstID   |   Epoch   |   a   |   e   |   i   |   RAAN   |   per   |   M   |
6	$initEpoch_julian	7.378137e6	0.0	90.0	0.0	0.0	0.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	0.0	0.0	72.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	0.0	0.0	144.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	0.0	0.0	216.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	0.0	0.0	288.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	90.0	0.0	36.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	90.0	0.0	108.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	90.0	0.0	180.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	90.0	0.0	252.0
6	$initEpoch_julian	7.378137e6	0.0	90.0	90.0	0.0	324.0
2	$initEpoch_julian	6.878137e6	0.0	70.0	0.0	0.0	0.0
2	$initEpoch_julian	6.878137e6	0.0	70.0	0.0	0.0	90.0
2	$initEpoch_julian	6.878137e6	0.0	70.0	0.0	0.0	180.0
2	$initEpoch_julian	6.878137e6	0.0	70.0	0.0	0.0	270.0
""")

satInits_constellation = mktempdir() do dir # We generate the vector of subconstellations data
    cd(dir) do
        open("orbfile.orb", "w") do io
            write(io, orb_file_contents)
        end
        read_kepleriansFile("orbfile.orb")
    end
end

em = EllipsoidModel(WGS84_ELLIPSOID)
sats = sat_from_init(satInits_constellation; em)

@testset "Main Function" begin
    @test plotSat_scattergeo(sats) isa Plot
    @test plotSat_scattergeo(sats; eta_fov=deg2rad(30), res_fov=0.2, title="Test", camera=:threedim, sat_marker_size=4) isa Plot
    @test plotSat_scattergeo(sats; res_fov=0.2, sat_marker_size=4) isa Plot
    @test plotSat_scattergeo(sats; eta_fov=deg2rad(30), res_fov=0.2) isa Plot
end

@testset "Function t_instant" begin
    @test plotSat_scattergeo(sats, 60) isa Plot
    @test plotSat_scattergeo(sats, 60;eta_fov=deg2rad(30), res_fov=0.2, title="Test", camera=:threedim, sat_marker_size=4) isa Plot
    @test plotSat_scattergeo(sats, 60;res_fov=0.2, sat_marker_size=4) isa Plot
    @test plotSat_scattergeo(sats, 60;eta_fov=deg2rad(30), res_fov=0.2) isa Plot
end

@testset "Function t interval" begin
    @test plotSat_scattergeo(sats, (0,60,1200)) isa Plot
    @test plotSat_scattergeo(sats, (0,60,1200); eta_fov=deg2rad(30), res_fov=0.2, title="Test", camera=:threedim, sat_marker_size=4) isa Plot
    @test plotSat_scattergeo(sats, (0,60,1200); res_fov=0.2, sat_marker_size=4) isa Plot
    @test plotSat_scattergeo(sats, (0,60,1200); eta_fov=deg2rad(30), res_fov=0.2) isa Plot
end

using PlutoPlotly

@test plotSat_scattergeo(sats, (0,60,1200)) isa PlutoPlot