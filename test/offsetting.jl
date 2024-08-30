using Test
using GeoGrids
using Meshes

@testitem "GeoRegionEnlarged" begin
    # Create a GeoRegion
    original_geo = GeoRegion(; name="Test Region", admin="Spain")
    
    # Test constructor with deltaDist
    # enlarged_geo = GeoRegionEnlarged(original_geo, 50km)  # Enlarge by 50 km
    enlarged_geo = GeoRegionEnlarged(original_geo, 50e3)  # Enlarge by 50 km
    @test enlarged_geo isa GeoRegionEnlarged
    @test enlarged_geo.original === original_geo
    @test enlarged_geo.name == "enlarged_test region"
    @test enlarged_geo.domain isa MultiBorder
    
    # Test constructor with custom name
    custom_name = "Custom Enlarged Spain"
    # enlarged_geo_custom = GeoRegionEnlarged(original_geo, 50km; name=custom_name)
    enlarged_geo_custom = GeoRegionEnlarged(original_geo, 50e3; name=custom_name)
    @test enlarged_geo_custom.name == custom_name
    
    # Test that the domain is actually enlarged
    original_area = area(original_geo.domain.latlon)
    enlarged_area = area(enlarged_geo.domain.latlon)
    @test enlarged_area > original_area
end

@testitem "PolyRegionEnlarged" begin
    using Unitful: °, km

    # Create a PolyRegion
    poly_domain = [LatLon(0°, 0°), LatLon(0°, 1°), LatLon(1°, 1°), LatLon(1°, 0°)]
    original_poly = PolyRegion("Test Poly", poly_domain)
    
    # Test constructor with deltaDist
    enlarged_poly = PolyRegionEnlarged(original_poly, 50km)  # Enlarge by 50 km
    @test enlarged_poly isa PolyRegionEnlarged
    @test enlarged_poly.original === original_poly
    @test enlarged_poly.name == "enlarged_test poly"
    @test enlarged_poly.domain isa MultiBorder
    
    # Test constructor with custom name
    custom_name = "Custom Enlarged Poly"
    enlarged_poly_custom = PolyRegionEnlarged(original_poly, 50km; name=custom_name)
    @test enlarged_poly_custom.name == custom_name
    
    # Test that the domain is actually enlarged
    original_area = area(original_poly.domain.latlon)
    enlarged_area = area(enlarged_poly.domain.latlon)
    @test enlarged_area > original_area
    
    # Test constructor from scratch
    new_poly = PolyRegionEnlarged(50km; name="New Poly", domain=poly_domain)
    @test new_poly isa PolyRegionEnlarged
    @test new_poly.name == "New Poly"
    @test new_poly.domain isa MultiBorder
end