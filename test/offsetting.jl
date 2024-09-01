@testitem "GeoRegionEnlarged" begin
    # Create a GeoRegion
    original_geo = GeoRegion(; name="Test Region", admin="Spain")
    
    # Test constructor with deltaDist
    # enlarged_geo = GeoRegionEnlarged(original_geo, 50km)  # Enlarge by 50 km
    enlarged_geo = GeoRegionEnlarged(original_geo, 50e3)  # Enlarge by 50 km
    @test enlarged_geo isa GeoRegionEnlarged
    @test enlarged_geo.original === original_geo
    @test enlarged_geo.name == "enlarged_georegion"
    @test enlarged_geo.domain isa MultiBorder
    
    # Test constructor with custom name
    custom_name = "Custom Enlarged Spain"
    # enlarged_geo_custom = GeoRegionEnlarged(original_geo, 50km; name=custom_name)
    enlarged_geo_custom = GeoRegionEnlarged(original_geo, 50e3; name=custom_name)
    @test enlarged_geo_custom.name == custom_name
end

@testitem "PolyRegionEnlarged" begin
    # Create a PolyRegion
    poly_domain = [LatLon(0°, 0°), LatLon(0°, 1°), LatLon(1°, 1°), LatLon(1°, 0°)]
    original_poly = PolyRegion("Test Poly", poly_domain)
    
    # Test constructor with deltaDist
    # enlarged_poly = PolyRegionEnlarged(original_poly, 50km)  # Enlarge by 50 km
    enlarged_poly = PolyRegionEnlarged(original_poly, 50e3)  # Enlarge by 50 km
    @test enlarged_poly isa PolyRegionEnlarged
    @test enlarged_poly.original === original_poly
    @test enlarged_poly.name == "enlarged_polyregion"
    @test enlarged_poly.domain isa MultiBorder
    
    # Test constructor with custom name
    custom_name = "Custom Enlarged Poly"
    enlarged_poly_custom = PolyRegionEnlarged(original_poly, 50e3; name=custom_name)
    @test enlarged_poly_custom.name == custom_name
    
    # Test constructor from scratch
    new_poly = PolyRegionEnlarged(delta=50e3, name="New Poly", domain=poly_domain)
    @test new_poly isa PolyRegionEnlarged
    @test new_poly.name == "New Poly"
    @test new_poly.domain isa MultiBorder
end