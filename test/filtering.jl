@testitem "GeoRegion Test" tags = [:filtering] begin
    sample_ita = [LatLon(43.727878°, 12.843441°), LatLon(43.714933°, 10.399326°), LatLon(37.485829°, 14.328285°), LatLon(39.330460°, 8.430780°), LatLon(45.918388°, 10.886654°)]
    sample_eu = [LatLon(52.218550°, 4.420621°), LatLon(41.353144°, 2.167639°), LatLon(42.670341°, 23.322592°)]

    ita = GeoRegion(regionName="ITA", admin="Italy")
    eu = GeoRegion(; continent="Europe")

    @test ita isa GeoRegion
    @test eu isa GeoRegion
    @test ita isa AbstractRegion
    @test eu isa AbstractRegion

    @test all(map(x -> in(x, ita), sample_ita))
    @test all(map(x -> in(x, eu), sample_eu))
    
    @test in(LatLon(0.7631954460103929rad, 0.22416033273563304rad), ita)
    @test in(LatLon(0.7631954460103929rad, 0.22416033273563304rad), eu)
    @test !in(LatLon(0.7085271959818754rad, -0.2072522112608427rad), eu)
    @test !in(LatLon(52.218550°, 4.420621°), ita)
    
    @test_throws "Input at least one argument between continent, subregion and admin..." GeoRegion()

    @test filter_points(sample_ita, ita) == sample_ita
    @test filter_points(sample_eu, eu) == sample_eu
    @test filter_points([LatLon(52.218550°, 4.420621°), LatLon(43.727878°, 12.843441°), LatLon(41.353144°, 2.167639°), LatLon(43.714933°, 10.399326°)], ita) == [LatLon(43.727878°, 12.843441°), LatLon(43.714933°, 10.399326°)]
end

@testitem "PolyRegion Test" tags = [:filtering] begin
    sample_in = [LatLon(14°, 1°), LatLon(26.9°, -4.9°), LatLon(10.1°, 14.9°)]
    sample_out = [LatLon(0°, 0°), LatLon(10°, -5.2°), LatLon(27°, 15.3°)]
    sample_border = [LatLon(10°, -5°), LatLon(10.1°, 10°), LatLon(27°, 15°)] # Due to the Predicates of Meshes the countour is not exact (acceptable)
    poly = PolyRegion("POLY", [LatLon(10°, -5°), LatLon(10°, 15°), LatLon(27°, 15°), LatLon(27°, -5°)])
    vertex = [LatLon(10°, -5°), LatLon(10°, 15°), LatLon(27°, 15°), LatLon(27°, -5°)]

    @test poly isa PolyRegion
    @test PolyRegion(;domain=vertex) isa PolyRegion
    @test PolyRegion(;regionName="Test",domain=vertex) isa PolyRegion
    @test PolyRegion("Test", vertex) isa PolyRegion
    @test_throws "UndefKeywordError: keyword argument `domain` not assigned" PolyRegion()
    
    @test all(map(x -> in(x, poly),sample_in))
    @test all(map(x -> in(x, poly),sample_border))
    @test !all(map(x -> in(x, poly),sample_out))

    @test in(LatLon(0.24434609527920614rad, 0.017453292519943295rad), poly)
    
    @test filter_points(vcat(sample_in, sample_out), poly) == sample_in
end

@testitem "LatBeltRegion Test" tags = [:filtering] begin
    belt = LatBeltRegion(; regionName="test", latLim=(-60°, 60°))
    sample_in = [LatLon(14°, 1°), LatLon(26.9°, -65°), LatLon(10.1°, 70°)]
    sample_out = [LatLon(90°, 1°), LatLon(60.1°, 1°), LatLon(-62°, -4.9°), LatLon(-60.1°, 14.9°)]

    @test belt isa LatBeltRegion
    @test LatBeltRegion(; regionName="test", latLim=(0°,90°)) isa LatBeltRegion
    @test LatBeltRegion(; latLim=(0°,90°)) isa LatBeltRegion
    @test LatBeltRegion("test", (0°,90°)) isa LatBeltRegion
    
    a = LatBeltRegion("test", (0°,90°))
    b = LatBeltRegion("test", (0,90))
    c = LatBeltRegion("test", (0rad, (π/2)rad))
    @test a isa LatBeltRegion
    @test b isa LatBeltRegion
    @test c isa LatBeltRegion
    @test a.latLim == b.latLim == c.latLim == (0°,90°)

    @test_throws "UndefKeywordError: keyword argument `latLim` not assigned" LatBeltRegion()
    @test_throws "LAT provided as numbers must be expressed in radians and satisfy -90 ≤ x ≤ 90. 
Consider using `°` (or `rad`) from `Unitful` if you want to pass numbers in degrees (or rad), by doing `x * °` (or `x * rad`)." LatBeltRegion("test", (0°,91°))
    @test_throws "LAT provided as numbers must be expressed in radians and satisfy -90 ≤ x ≤ 90. 
Consider using `°` (or `rad`) from `Unitful` if you want to pass numbers in degrees (or rad), by doing `x * °` (or `x * rad`)." LatBeltRegion("test", (-91°,91°))
    @test_throws "LAT provided as numbers must be expressed in radians and satisfy -90 ≤ x ≤ 90. 
Consider using `°` (or `rad`) from `Unitful` if you want to pass numbers in degrees (or rad), by doing `x * °` (or `x * rad`)." LatBeltRegion("test", (-91°,0°))
    @test_throws "The first LAT limit must be lower than the second one..." LatBeltRegion(; latLim=((π/2)rad, 0rad))
    @test_throws "The first LAT limit must be different than the second one..." LatBeltRegion(; latLim=(90, 90))
    
    @test all(map(x -> in(x, belt), sample_in))
    @test !all(map(x -> in(x, belt), sample_out))
    @test in(LatLon(0.24434609527920614, 0.017453292519943295), belt)
    
    @test filter_points([LatLon(14°, 1°), LatLon(90°, 1°), LatLon(60.1°, 1°), LatLon(26.9°, -65°), LatLon(-62°, -4.9°), LatLon(-60.1°, 14.9°), LatLon(10.1°, 70°)], belt) == sample_in
end