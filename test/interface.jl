## Base.in()
@testitem "Test Base.in GeoRegion" tags = [:interface] begin
    sample_ita = [LatLon(43.727878°, 12.843441°), LatLon(43.714933°, 10.399326°), LatLon(37.485829°, 14.328285°), LatLon(39.330460°, 8.430780°), LatLon(45.918388°, 10.886654°)]
    sample_eu = [LatLon(52.218550°, 4.420621°), LatLon(41.353144°, 2.167639°), LatLon(42.670341°, 23.322592°)]

    ita = GeoRegion(regionName="ITA", admin="Italy")
    eu = GeoRegion(; continent="Europe")

    @test all(map(x -> in(x, ita), sample_ita))
    @test all(map(x -> in(x, eu), sample_eu))
    
    @test in(LatLon(0.7631954460103929rad, 0.22416033273563304rad), ita)
    @test in(LatLon(0.7631954460103929rad, 0.22416033273563304rad), eu)
    @test !in(LatLon(0.7085271959818754rad, -0.2072522112608427rad), eu)
    @test !in(LatLon(52.218550°, 4.420621°), ita)
end

@testitem "Test Base.in PolyRegion" tags = [:interface] begin
    sample_in = [LatLon(14°, 1°), LatLon(26.9°, -4.9°), LatLon(10.1°, 14.9°)]
    sample_out = [LatLon(0°, 0°), LatLon(10°, -5.2°), LatLon(27°, 15.3°)]
    sample_border = [LatLon(10°, -5°), LatLon(10.1°, 10°), LatLon(27°, 15°)] # Due to the Predicates of Meshes the countour is not exact (acceptable)
    poly = PolyRegion("POLY", [LatLon(10°, -5°), LatLon(10°, 15°), LatLon(27°, 15°), LatLon(27°, -5°)])

    @test all(map(x -> in(x, poly),sample_in))
    @test all(map(x -> in(x, poly),sample_border))
    @test !all(map(x -> in(x, poly),sample_out))

    @test in(LatLon(0.24434609527920614rad, 0.017453292519943295rad), poly)
end

@testitem "Test Base.in LatBeltRegion" tags = [:interface] begin
    belt = LatBeltRegion(; regionName="test", latLim=(-60°, 60°))
    sample_in = [LatLon(14°, 1°), LatLon(26.9°, -65°), LatLon(10.1°, 70°)]
    sample_out = [LatLon(90°, 1°), LatLon(60.1°, 1°), LatLon(-62°, -4.9°), LatLon(-60.1°, 14.9°)]
    
    @test all(map(x -> in(x, belt), sample_in))
    @test !all(map(x -> in(x, belt), sample_out))
    @test in(LatLon(0.24434609527920614, 0.017453292519943295), belt)
end

## borders()
@testitem "Test borders for GeoRegion" tags = [:interface] begin
    reg = GeoRegion(regionName="ITA", admin="Italy;Spain")    
    @test borders(reg) == map(x -> x.latlon, reg.domain)
    @test borders(LatLon, reg) == map(x -> x.latlon, reg.domain)
    @test borders(Cartesian, reg) == map(x -> x.cart, reg.domain)
end

@testitem "Test borders for PolyRegion" begin
    poly = PolyRegion("POLY", [LatLon(10°, -5°), LatLon(10°, 15°), LatLon(27°, 15°), LatLon(27°, -5°)])
    @test borders(poly) == poly.domain.latlon
    @test borders(LatLon, poly) == poly.domain.latlon
    @test borders(Cartesian, poly) == poly.domain.cart
end










## Helpers
@testitem "Helper Functions" tags = [:general] begin
    r = GeoRegion(regionName="ITA", admin="Italy")
    @test extract_countries(r) == r.domain
end