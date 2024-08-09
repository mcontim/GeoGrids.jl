## HEX
@testitem "GeoRegion HEX Layout Tesselation and :hex Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(43.2693, -8.83691), SimpleLatLon(43.6057, -8.11563), SimpleLatLon(36.808, -5.06421), SimpleLatLon(36.792, -2.3703)] # SimpleLatLon{WGS84Latest} coordinates
    corresponding_idxs = [1, 2, 121, 122]
    
    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers = generate_tesselation(reg, 40000, HEX())
    
    @test length(centers) == 122
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "GeoRegion HEX Layout Tesselation and :circ Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(43.2693, -8.83691), SimpleLatLon(43.6057, -8.11563), SimpleLatLon(36.808, -5.06421), SimpleLatLon(36.792, -2.3703)] # SimpleLatLon{WGS84Latest} coordinates
    corresponding_idxs = [1, 2, 121, 122]
    
    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
    centers = generate_tesselation(reg, 40000, HEX(;pattern=:circ))

    @test length(centers) == 122
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "GeoRegion HEX Layout Tesselation and :hex Pattern (with ExtraOutput)" tags = [:tesselation] begin
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

@testitem "GeoRegion HEX Layout Tesselation and :circ Pattern (with ExtraOutput)" tags = [:tesselation] begin
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

@testitem "GeoRegion HEX Layout Tesselation and :hex Pattern :flat (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(42.8428,-9.06506), SimpleLatLon(43.4251,-7.82139), SimpleLatLon(37.5057,-1.64231), SimpleLatLon(36.459,-4.77773),]
    corresponding_idxs = [1, 2, 117, 118]

    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers = generate_tesselation(reg, 40000, HEX(; direction=:flat))
    
    @test length(centers) == 118
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "PolyRegion HEX Layout Tesselation and :hex Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(79.9691,5.0),SimpleLatLon(79.6441,7.98881),SimpleLatLon(60.0123,7.14867),SimpleLatLon(60.3001,8.25311)]
    corresponding_idxs = [1, 2, 318, 319]

    reg = PolyRegion(;domain=[SimpleLatLon(60,-5), SimpleLatLon(80,0), SimpleLatLon(80,10), SimpleLatLon(60,15)])
	centers = generate_tesselation(reg, 40000, HEX())
    
    @test length(centers) == 319
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

## ICO
@testitem "GlobalRegion ICO Layout Tesselation and :circ Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(83.991,0.0),SimpleLatLon(79.5826,-137.508),SimpleLatLon(-79.5826,88.6025),SimpleLatLon(-83.991,-48.9053)]
    corresponding_idxs = [1, 2, 181, 182]

    reg = GlobalRegion()
	centers = generate_tesselation(reg, 1000000, ICO())
    
    @test length(centers) == 182
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "GlobalRegion ICO Layout Tesselation and :hex Pattern (with ExtraOutput)" tags = [:tesselation] begin
    samplePoints = [SimpleLatLon(83.991,0.0),SimpleLatLon(79.5826,-137.508),SimpleLatLon(-79.5826,88.6025),SimpleLatLon(-83.991,-48.9053)]
    corresponding_idxs_points = [1, 2, 181, 182]
    sampleNgons = [[SimpleLatLon(66.8411,-2.78182), SimpleLatLon(75.8026,15.7204), SimpleLatLon(82.6627,18.6819), SimpleLatLon(83.991,0.0), SimpleLatLon(83.4003,-18.4249), SimpleLatLon(66.8411,-2.78182)],
    [SimpleLatLon(-82.3641,-67.4582), SimpleLatLon(-83.991,-48.9053), SimpleLatLon(-83.4003,-30.4803), SimpleLatLon(-66.8411,-46.1235), SimpleLatLon(-75.8026,-64.6257), SimpleLatLon(-82.3641,-67.4582)]]
    corresponding_idxs_ngon = [1, 182]

    reg = GlobalRegion()
	centers,ngon = generate_tesselation(reg, 1000000, ICO(;pattern=:hex), ExtraOutput())
    
    @test length(centers) == 182
    for i in eachindex(samplePoints) 
        @test centers[corresponding_idxs_points[i]] ≈ samplePoints[i]
    end

    @test length(ngon) == 182
    for i in eachindex(sampleNgons)
        for v in eachindex(sampleNgons[i])
            @test ngon[corresponding_idxs_ngon[i]][v] ≈ sampleNgons[i][v]
        end
    end
end

@testitem "LatBeltRegion ICO Layout Tesselation and :circ Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(9.89685,41.5062), SimpleLatLon(9.78996,-96.0016), SimpleLatLon(-9.78996,25.0621), SimpleLatLon(-9.89685,-112.446)]
    corresponding_idxs = [1, 2, 187, 188]

    reg = LatBeltRegion(latLim=(-10,10))
	centers = generate_tesselation(reg, 400000, ICO())
    
    @test length(centers) == 188
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "LatBeltRegion ICO Layout Tesselation and :hex Pattern (with ExtraOutput)" tags = [:tesselation] begin
    samplePoints = [SimpleLatLon(9.89685,41.5062), SimpleLatLon(9.78996,-96.0016), SimpleLatLon(-9.78996,25.0621), SimpleLatLon(-9.89685,-112.446)]
    corresponding_idxs_points = [1, 2, 187, 188]

    sampleNgons = [[SimpleLatLon(11.8183,45.104),SimpleLatLon(13.921,40.8336),SimpleLatLon(9.54199,37.4515),SimpleLatLon(8.05959,37.8844),SimpleLatLon(5.89612,42.1999),SimpleLatLon(10.2875,45.5542),SimpleLatLon(11.8183,45.104)],
    [SimpleLatLon(-11.8183,-116.044),SimpleLatLon(-13.921,-111.773),SimpleLatLon(-9.54199,-108.391),SimpleLatLon(-8.05959,-108.824),SimpleLatLon(-5.89611,-113.139),SimpleLatLon(-10.2875,-116.494),SimpleLatLon(-11.8183,-116.044)]]
    corresponding_idxs_ngon = [1, 188]

    reg = LatBeltRegion(latLim=(-10,10))
	centers,ngon = generate_tesselation(reg, 400000, ICO(;pattern=:hex), ExtraOutput())

    @test length(centers) == 188
    for i in eachindex(samplePoints) 
        @test centers[corresponding_idxs_points[i]] ≈ samplePoints[i]
    end

    @test length(ngon) == 188
    for i in eachindex(sampleNgons)
        for v in eachindex(sampleNgons[i])
            @test ngon[corresponding_idxs_ngon[i]][v] ≈ sampleNgons[i][v]
        end
    end
end

@testitem "PolyRegion ICO Layout Tesselation and :circ Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(79.9456,4.99995), SimpleLatLon(79.6831,9.73597), SimpleLatLon(60.0598,-3.47868), SimpleLatLon(60.0243,8.92039)]
    corresponding_idxs = [1, 2, 218, 219]

    reg = PolyRegion(;domain=[SimpleLatLon(60,-5), SimpleLatLon(80,0), SimpleLatLon(80,10), SimpleLatLon(60,15)])
	centers = generate_tesselation(reg, 40000, ICO(;correction=1.7))
    
    @test length(centers) == 219
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "PolyRegion ICO Layout Tesselation and :hex Pattern (with ExtraOutput)" tags = [:tesselation] begin
    samplePoints = [SimpleLatLon(79.9456,4.99995), SimpleLatLon(79.6831,9.73597), SimpleLatLon(60.0598,-3.47868), SimpleLatLon(60.0243,8.92039)]
    corresponding_idxs_points = [1, 2, 218, 219]
    sampleNgons = [[SimpleLatLon(79.2839,5.7835),SimpleLatLon(80.0631,6.07365),SimpleLatLon(81.0731,4.99257),SimpleLatLon(80.8394,4.30809),SimpleLatLon(79.929,3.94491),SimpleLatLon(78.9239,4.90667),SimpleLatLon(79.2839,5.7835)],
        [SimpleLatLon(60.0209,9.55066),SimpleLatLon(60.4379,9.40303),SimpleLatLon(60.6574,8.86491),SimpleLatLon(60.0377,8.28825),SimpleLatLon(59.6336,8.42962),SimpleLatLon(59.4002,8.98413),SimpleLatLon(60.0209,9.55066)]]
    corresponding_idxs_ngon = [1, 219]
    
    reg = PolyRegion(;domain=[SimpleLatLon(60,-5), SimpleLatLon(80,0), SimpleLatLon(80,10), SimpleLatLon(60,15)])
	centers, ngon = generate_tesselation(reg, 40000, ICO(;correction=1.7, pattern=:hex), ExtraOutput())

    @test length(centers) == 219
    for i in eachindex(samplePoints) 
        @test centers[corresponding_idxs_points[i]] ≈ samplePoints[i]
    end

    @test length(ngon) == 219
    for i in eachindex(sampleNgons)
        for v in eachindex(sampleNgons[i])
            @test ngon[corresponding_idxs_ngon[i]][v] ≈ sampleNgons[i][v]
        end
    end
end

@testitem "GeoRegion ICO Layout Tesselation and :circ Pattern (no ExtraOutput)" tags = [:tesselation] begin
    samples = [SimpleLatLon(43.5772,-7.50902),SimpleLatLon(43.4468,-5.70002),SimpleLatLon(36.6657,-3.58858),SimpleLatLon(36.285,-5.82463)]
    corresponding_idxs = [1, 2, 103, 104]

    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers = generate_tesselation(reg, 40000, ICO())
    
    @test length(centers) == 104
    for i in eachindex(samples) 
        @test centers[corresponding_idxs[i]] ≈ samples[i]
    end
end

@testitem "GeoRegion ICO Layout Tesselation and :hex Pattern (with ExtraOutput)" tags = [:tesselation] begin
    samplePoints = [SimpleLatLon(43.5772,-7.50902),SimpleLatLon(43.4468,-5.70002),SimpleLatLon(36.6657,-3.58858),SimpleLatLon(36.285,-5.82463)]
    corresponding_idxs_points = [1, 2, 103, 104]
    sampleNgons = [[SimpleLatLon(43.2175,-7.50902), SimpleLatLon(43.235,-7.35644), SimpleLatLon(43.2858,-7.21855), SimpleLatLon(43.3651,-7.1087), SimpleLatLon(43.4651,-7.03764), SimpleLatLon(43.5761,-7.01247), SimpleLatLon(43.6874,-7.03589), SimpleLatLon(43.7879,-7.10588), SimpleLatLon(43.8679,-7.21573), SimpleLatLon(43.9192,-7.35469), SimpleLatLon(43.9369,-7.50902), SimpleLatLon(43.9192,-7.66334), SimpleLatLon(43.8679,-7.8023), SimpleLatLon(43.7879,-7.91215), SimpleLatLon(43.6874,-7.98214), SimpleLatLon(43.5761,-8.00557), SimpleLatLon(43.4651,-7.9804), SimpleLatLon(43.3651,-7.90933), SimpleLatLon(43.2858,-7.79948), SimpleLatLon(43.235,-7.6616), SimpleLatLon(43.2175,-7.50902), SimpleLatLon(43.2175,-7.50902)],
    [SimpleLatLon(35.9252,-5.82463),SimpleLatLon(35.9428,-5.68733),SimpleLatLon(35.9937,-5.56329),SimpleLatLon(36.073,-5.46457),SimpleLatLon(36.1731,-5.40081),SimpleLatLon(36.2841,-5.37836),SimpleLatLon(36.3954,-5.3996),SimpleLatLon(36.4959,-5.46261),SimpleLatLon(36.5757,-5.56134),SimpleLatLon(36.627,-5.68612),SimpleLatLon(36.6447,-5.82463),SimpleLatLon(36.627,-5.96314),SimpleLatLon(36.5757,-6.08792),SimpleLatLon(36.4959,-6.18665),SimpleLatLon(36.3954,-6.24966),SimpleLatLon(36.2841,-6.27089),SimpleLatLon(36.1731,-6.24845),SimpleLatLon(36.073,-6.18469),SimpleLatLon(35.9937,-6.08597),SimpleLatLon(35.9428,-5.96193),SimpleLatLon(35.9252,-5.82463),SimpleLatLon(35.9252,-5.82463)]]
    corresponding_idxs_ngon = [1, 104]
    
    reg = GeoRegion(; regionName="Tassellation", admin="Spain")
	centers, ngon = generate_tesselation(reg, 40000, ICO(), ExtraOutput())

    @test length(centers) == 104
    for i in eachindex(samplePoints) 
        @test centers[corresponding_idxs_points[i]] ≈ samplePoints[i]
    end

    @test length(ngon) == 104
    for i in eachindex(sampleNgons)
        for v in eachindex(sampleNgons[i])
            @test ngon[corresponding_idxs_ngon[i]][v] ≈ sampleNgons[i][v]
        end
    end
end

@testitem "Test missing Functions" tags = [:tesselation] begin
    reg = GlobalRegion()
    @test_throws "H3 tassellation is not yet implemented in this version..." generate_tesselation(reg,10.0,H3())
end