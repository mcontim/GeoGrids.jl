@testitem "plot_geo_points" tags = [:general] begin
    using PlotlyBase

    @test plot_unitarysphere(GeoGrids._icogrid(100; coord=:cart)) isa Plot

    # Multi Point
    @test plot_geo_points(icogrid(sepAng=5°)) isa Plot
    @test plot_geo_points(icogrid(sepAng=deg2rad(4) * rad); camera=:threedim) isa Plot
    @test plot_geo_points(rectgrid(5)) isa Plot
    @test plot_geo_points(rectgrid(5°); camera=:threedim) isa Plot
    
    # Single Point
    @test plot_geo_points(LatLon(10,10); camera=:threedim) isa Plot
    @test plot_geo_points((10,10)) isa Plot
    @test plot_geo_points([10,10]) isa Plot
end

@testitem "plot_geo_points" tags = [:general] begin
    using PlotlyBase

    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	
    # Multi Point
    centers, ngon = generate_tesselation(reg, 40000, HEX(;pattern=:circ), EO())
    @test plot_geo_cells(centers, ngon) isa Plot
    @test plot_geo_cells(centers[1], ngon[1]) isa Plot
    # Single Point
    @test plot_geo_cells(centers) isa Plot
    @test plot_geo_cells(centers[1]) isa Plot
	centers, ngon = generate_tesselation(reg, 40000, HEX(), EO())
    # Multi Point
    @test plot_geo_cells(centers, ngon) isa Plot
    @test plot_geo_cells(centers[1], ngon[1]) isa Plot
    # Single Point
    @test plot_geo_cells(centers) isa Plot
    @test plot_geo_cells(centers[1]) isa Plot
end