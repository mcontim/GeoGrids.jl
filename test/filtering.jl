using Test
using GeoGrids

@testset "GeoRegion Test" begin
    sample_ita = [(43.727878°,12.843441°), (43.714933°,10.399326°), (37.485829°,14.328285°), (39.330460°,8.430780°), (45.918388°,10.886654°)]
    sample_eu = [(52.218550°, 4.420621°), (41.353144°, 2.167639°), (42.670341°, 23.322592°)]
    
    ita = GeoRegion(regionName="ITA", admin="Italy")
    eu = GeoRegion(;continent="Europe")
    
    sv_ita = map(x -> SVector(x...), sample_ita)
    p_ita = map(x -> Point2(x...), sample_ita)
    tup_ita = sample_ita
    lla_ita = map(x -> LLA(x..., 0.0), sample_ita)
    @test all(in_region(sv_ita, ita))
    @test all(in_region(p_ita, ita))
    @test all(in_region(tup_ita, ita))
    @test all(in_region(lla_ita, ita))
    
    sv_eu = map(x -> SVector(x...), sample_eu)
    p_eu = map(x -> Point2(x...), sample_eu)
    tup_eu = sample_eu
    lla_eu = map(x -> LLA(x..., 0.0), sample_eu)
    @test all(in_region(sv_eu, eu))
    @test all(in_region(p_eu, eu))
    @test all(in_region(tup_eu, eu))
    @test all(in_region(lla_eu, eu))

    @test in_region((0.7631954460103929,0.22416033273563304), ita)
    @test in_region((0.7631954460103929,0.22416033273563304), eu)
    @test !in_region((0.7085271959818754, -0.2072522112608427), eu)
    @test !in_region((52.218550°, 4.420621°), ita)
    
    @test_throws "LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." in_region((93.727878,0.22416033273563304), eu)
    @test_throws "LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." in_region((0.7631954460103929,-91.843441), eu)
    @test_throws "Input at least one argument between continent, subregion and admin..." GeoRegion()

    @test_throws "The domain must be computed from the other inputs..." GeoRegion(;continent="Europe",domain=PolyArea(Point2(0.0,0.0), Point2(0.0,0.5), Point2(0.3,0.5), Point2(0.3,0.0), Point2(0.0,0.0)))

    @test filter_points(sample_ita, ita) == sample_ita
    @test filter_points(lla_ita, ita) == lla_ita
    @test filter_points(sv_eu, eu) == sv_eu
    @test filter_points(p_eu, eu) == p_eu
    @test filter_points([(52.218550°, 4.420621°),(43.727878°,12.843441°),(41.353144°, 2.167639°),(43.714933°,10.399326°)], ita) == [(43.727878°,12.843441°), (43.714933°,10.399326°)]
end

@testset "PolyRegion Test" begin
    
    sample_in = [(43.727878°,12.843441°), (43.714933°,10.399326°), (37.485829°,14.328285°), (39.330460°,8.430780°), (45.918388°,10.886654°)]
    poly = PolyRegion(regionName="POLY", domain=[LLA(10°,-5°,0), LLA(10°,15°,0), LLA(27°,15°,0), LLA(27°,-5°,0), LLA(10°,-5°,0)])

    @test PolyRegion(domain=[LLA(10°,-5°,0), LLA(10°,15°,0), LLA(27°,15°,0), LLA(27°,-5°,0), LLA(10°,-5°,0)]) isa PolyRegion
    @test PolyRegion(domain=[Point2(10°,-5°), Point2(10°,15°), Point2(27°,15°), Point2(27°,-5°), Point2(10°,-5°)]) isa PolyRegion
    @test PolyRegion(domain=[(10°,-5°), (10°,15°), (27°,15°), (27°,-5°), (10°,-5°)]) isa PolyRegion
    @test PolyRegion(domain=[SVector(10°,-5°), SVector(10°,15°), SVector(27°,15°), SVector(27°,-5°), SVector(10°,-5°)]) isa PolyRegion
    @test PolyRegion(domain=[(0.0,0.0), (0.0,0.5), (0.3,0.5), (0.3,0.0), (0.0,0.0)]) isa PolyRegion
    @test PolyRegion(domain=[SVector(0.0,0.0), SVector(0.0,0.5), SVector(0.3,0.5), SVector(0.3,0.0), SVector(0.0,0.0)]) isa PolyRegion
    @test PolyRegion(domain=[Point2(0.0,0.0), Point2(0.0,0.5), Point2(0.3,0.5), Point2(0.3,0.0), Point2(0.0,0.0)]) isa PolyRegion
    
    @test_logs (:warn, "First and last points are not the same, adding them to the end...") PolyRegion(domain=[LLA(10°,-5°,0), LLA(10°,15°,0), LLA(27°,15°,0), LLA(27°,-5°,0)])
    @test_throws "The input domain do not match the expected format..." PolyRegion(domain=Point2(0.0,0.0))
    @test_throws "Input the polygon domain..." PolyRegion()
    
    


    # eu = GeoRegion(;continent = "Europe")
    
    # sv_ita = map(x -> SVector(x...), sample_ita)
    # p_ita = map(x -> Point2(x...), sample_ita)
    # tup_ita = sample_ita
    # lla_ita = map(x -> LLA(x..., 0.0), sample_ita)
    # @test all(in_region(sv_ita, ita))
    # @test all(in_region(p_ita, ita))
    # @test all(in_region(tup_ita, ita))
    # @test all(in_region(lla_ita, ita))
    
    

    # @test in_region((0.7631954460103929,0.22416033273563304), ita)
    # @test in_region((0.7631954460103929,0.22416033273563304), eu)
    # @test !in_region((0.7085271959818754, -0.2072522112608427), eu)
    # @test !in_region((52.218550°, 4.420621°), ita)
    
    # @test_throws "LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." in_region((93.727878,0.22416033273563304), eu)
    # @test_throws "LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`." in_region((0.7631954460103929,-91.843441), eu)

    # @test filter_points(sample_ita, ita) == sample_ita
    # @test filter_points(lla_ita, ita) == lla_ita
    # @test filter_points(sv_eu, eu) == sv_eu
    # @test filter_points(p_eu, eu) == p_eu
    # @test filter_points([(52.218550°, 4.420621°),(43.727878°,12.843441°),(41.353144°, 2.167639°),(43.714933°,10.399326°)], ita) == [(43.727878°,12.843441°), (43.714933°,10.399326°)]
end