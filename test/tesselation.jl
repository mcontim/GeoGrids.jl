@testitem "GeoRegion HEX Layout Tesselation and :hex Pattern (no ExtraOutput)" tags = [:general] begin
    samples = [SimpleLatLon(43.2693, -8.83691), SimpleLatLon(43.6057, -8.11563), SimpleLatLon(36.808, -5.06421), SimpleLatLon(36.792, -2.3703)] # SimpleLatLon{WGS84Latest} coordinates
    corresponding_idxs = [1, 2, 121, 122]
    
    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers = generate_tesselation(reg, 40000, HEX())
    
    @test length(centers) == 122
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "GeoRegion HEX Layout Tesselation and :circ Pattern (no ExtraOutput)" tags = [:general] begin
    samples = [SimpleLatLon(43.2693, -8.83691), SimpleLatLon(43.6057, -8.11563), SimpleLatLon(36.808, -5.06421), SimpleLatLon(36.792, -2.3703)] # SimpleLatLon{WGS84Latest} coordinates
    corresponding_idxs = [1, 2, 121, 122]
    
    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
    centers = generate_tesselation(reg, 40000, HEX(;pattern=:circ))

    @test length(centers) == 122
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "GeoRegion HEX Layout Tesselation and :hex Pattern (with ExtraOutput)" tags = [:general] begin
    samplePoints = [SimpleLatLon(43.2693, -8.83691), SimpleLatLon(43.6057, -8.11563), SimpleLatLon(36.808, -5.06421), SimpleLatLon(36.792, -2.3703)] # SimpleLatLon{WGS84Latest} coordinates
    corresponding_idxs_points = [1, 2, 121, 122]
    sampleNgons = [[SimpleLatLon(43.558,-9.1653), SimpleLatLon(43.2648,-9.27284), SimpleLatLon(42.937,-9.11636), SimpleLatLon(42.9797,-8.51291), SimpleLatLon(43.2764,-8.40112), SimpleLatLon(43.6025,-8.55324), SimpleLatLon(43.558,-9.1653)],
    [SimpleLatLon(36.4876,-2.64153), SimpleLatLon(36.4735,-2.11589), SimpleLatLon(36.7875,-1.96157), SimpleLatLon(37.0961,-2.09562), SimpleLatLon(37.1107,-2.62807), SimpleLatLon(36.7972,-2.77902), SimpleLatLon(36.4876,-2.64153)]] 
    corresponding_idxs_ngon = [1, 122]

    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers, ngon = generate_tesselation(reg, 40000, HEX(), ExtraOutput())

    @test length(centers) == 122
    for i in eachindex(samplePoints) 
        @test centers[corresponding_idxs_points[i]] ≈ samplePoints[i]
    end
    @test length(ngon) == 122
    for i in eachindex(sampleNgons)
        for v in eachindex(sampleNgons[i])
            @test ngon[corresponding_idxs_ngon[i]][v] ≈ sampleNgons[i][v]
        end
    end
end

@testitem "GeoRegion HEX Layout Tesselation and :circ Pattern (with ExtraOutput)" tags = [:general] begin
    samplePoints = [SimpleLatLon(43.2693, -8.83691), SimpleLatLon(43.6057, -8.11563), SimpleLatLon(36.808, -5.06421), SimpleLatLon(36.792, -2.3703)] # SimpleLatLon{WGS84Latest} coordinates
    corresponding_idxs_points = [1, 2, 121, 122]
    sampleNgons = [[SimpleLatLon(42.9096,-8.83691), SimpleLatLon(42.9271,-8.68509), SimpleLatLon(42.9779,-8.5479), SimpleLatLon(43.0572,-8.43861), SimpleLatLon(43.1572,-8.36791), SimpleLatLon(43.2682,-8.34287), SimpleLatLon(43.3795,-8.36619), SimpleLatLon(43.48,-8.43583), SimpleLatLon(43.56,-8.54512), SimpleLatLon(43.6113,-8.68338), SimpleLatLon(43.629,-8.83691), SimpleLatLon(43.6113,-8.99044), SimpleLatLon(43.56,-9.12869), SimpleLatLon(43.48,-9.23798), SimpleLatLon(43.3795,-9.30762), SimpleLatLon(43.2682,-9.33094), SimpleLatLon(43.1572,-9.3059), SimpleLatLon(43.0572,-9.23521), SimpleLatLon(42.9779,-9.12591), SimpleLatLon(42.9271,-8.98872), SimpleLatLon(42.9096,-8.83691), SimpleLatLon(42.9096,-8.83691)],
    [SimpleLatLon(36.4322,-2.3703), SimpleLatLon(36.4498,-2.23211), SimpleLatLon(36.5006,-2.10727), SimpleLatLon(36.58,-2.00789), SimpleLatLon(36.68,-1.94371), SimpleLatLon(36.7911,-1.9211), SimpleLatLon(36.9024,-1.94247), SimpleLatLon(37.0029,-2.00588), SimpleLatLon(37.0827,-2.10526), SimpleLatLon(37.134,-2.23087), SimpleLatLon(37.1517,-2.3703), SimpleLatLon(37.134,-2.50974), SimpleLatLon(37.0827,-2.63535), SimpleLatLon(37.0029,-2.73472), SimpleLatLon(36.9024,-2.79814), SimpleLatLon(36.7911,-2.8195), SimpleLatLon(36.68,-2.7969), SimpleLatLon(36.58,-2.73272), SimpleLatLon(36.5006,-2.63334), SimpleLatLon(36.4498,-2.5085), SimpleLatLon(36.4322,-2.3703), SimpleLatLon(36.4322,-2.3703)]]
    corresponding_idxs_ngon = [1, 122]

    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers, ngon = generate_tesselation(reg, 40000, HEX(; pattern=:circ), ExtraOutput())

    @test length(centers) == 122
    for i in eachindex(samplePoints) 
        @test centers[corresponding_idxs_points[i]] ≈ samplePoints[i]
    end
    @test length(ngon) == 122
    for i in eachindex(sampleNgons)
        for v in eachindex(sampleNgons[i])
            @test ngon[corresponding_idxs_ngon[i]][v] ≈ sampleNgons[i][v]
        end
    end
end

@testitem "GeoRegion HEX Layout Tesselation and :hex Pattern :flat (no ExtraOutput)" tags = [:general] begin
    samples = [SimpleLatLon(42.8428,-9.06506), SimpleLatLon(43.4251,-7.82139), SimpleLatLon(37.5057,-1.64231), SimpleLatLon(36.459,-4.77773),]
    corresponding_idxs = [1, 2, 117, 118]

    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers = generate_tesselation(reg, 40000, HEX(; direction=:flat))
    
    @test length(centers) == 118
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end