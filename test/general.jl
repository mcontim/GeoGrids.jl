@testitem "Theory Notebook Functions" tags = [:general] begin
    @test GeoGrids.fibonaccisphere_optimization1(100) isa Vector{SVector{3,Float64}}
    @test GeoGrids.fibonaccisphere_alternative1(100) isa Vector{SVector{3,Float64}}
end

@testitem "Icogrid Functions" tags = [:general] begin
    @test GeoGrids._icogrid(100; coord=:cart) isa Vector{SVector{3,Float64}}
    @test GeoGrids._icogrid(100; coord=:sphe) isa Vector{SVector{2,Float64}}

    @test icogrid(N=100) isa Vector{<:SimpleLatLon}

    a = icogrid(sepAng=5)
    b = icogrid(sepAng=5°)
    c = icogrid(sepAng=deg2rad(5) * rad)

    @test a isa Vector{<:SimpleLatLon}
    @test b isa Vector{<:SimpleLatLon}
    @test c isa Vector{<:SimpleLatLon}
    @test length(a) == 1260
    @test length(b) == 1260
    @test length(c) == 1260

    @test a[1].lat ≈ 87.7171f0°
    @test a[1].lon ≈ 0.0f0°
    @test a[end].lat ≈ -87.7171f0°
    @test a[end].lon ≈ 37.7251f0°
    @test b[1].lat ≈ 87.7171f0°
    @test b[1].lon ≈ 0.0f0°
    @test b[end].lat ≈ -87.7171f0°
    @test b[end].lon ≈ 37.7251f0°
    @test c[1].lat ≈ 87.7171f0°
    @test c[1].lon ≈ 0.0f0°
    @test c[end].lat ≈ -87.7171f0°
    @test c[end].lon ≈ 37.7251f0°

    @test_logs (:warn, "Input sepAng is negative, it will be converted to positive...") icogrid(sepAng=-5°)
    @test_throws "The sepAng provided as numbers must be expressed in radians and satisfy -360° ≤ x ≤ 360°. 
Consider using `°` (or `rad`) from `Unitful` if you want to pass numbers in degrees (or rad), by doing `x * °` (or `x * rad`)." icogrid(sepAng=361°)
end

@testitem "Mesh Grid Functions" tags = [:general] begin
    @test rectgrid(5) isa Matrix{<:SimpleLatLon}
    @test rectgrid(5°) isa Matrix{<:SimpleLatLon}
    @test rectgrid(deg2rad(5) * rad) isa Matrix{<:SimpleLatLon}
    @test rectgrid(5; yRes=3) isa Matrix{<:SimpleLatLon}
    @test rectgrid(5°; yRes=3°) isa Matrix{<:SimpleLatLon}
    @test rectgrid(deg2rad(5) * rad; yRes=deg2rad(3) * rad) isa Matrix{<:SimpleLatLon}

    @test_throws "Resolution of x is too large, it must be smaller than 180°..." rectgrid(181°)
    @test_throws "Resolution of y is too large, it must be smaller than 180°..." rectgrid(5°; yRes=181°)

    @test_logs (:warn, "Input xRes is negative, it will be converted to positive...") rectgrid(-5°; yRes=3°)
    @test_logs (:warn, "Input yRes is negative, it will be converted to positive...") rectgrid(5°; yRes=-3°)

    a = rectgrid(5)
    b = rectgrid(5°)
    c = rectgrid(deg2rad(5) * rad)
    @test length(a) == 2664
    @test length(b) == 2664
    @test length(c) == 2664

    @test a[1, 1].lat ≈ -90°
    @test a[1, 1].lon ≈ -180°
    @test a[end, end].lat ≈ 90°
    @test a[end, end].lon ≈ 175°
    @test abs(a[1, 2].lon - a[1, 1].lon) ≈ 5°
    @test abs(a[1, 2].lat - a[1, 1].lat) ≈ 0°
    @test abs(a[2, 1].lon - a[1, 1].lon) ≈ 0°
    @test abs(a[2, 1].lat - a[1, 1].lat) ≈ 5°
    @test b[1, 1].lat ≈ -90°
    @test b[1, 1].lon ≈ -180°
    @test b[end, end].lat ≈ 90°
    @test b[end, end].lon ≈ 175°
    @test abs(b[1, 2].lon - b[1, 1].lon) ≈ 5°
    @test abs(b[1, 2].lat - b[1, 1].lat) ≈ 0°
    @test abs(b[2, 1].lon - b[1, 1].lon) ≈ 0°
    @test abs(b[2, 1].lat - b[1, 1].lat) ≈ 5°
    @test c[1, 1].lat ≈ -90°
    @test c[1, 1].lon ≈ -180°
    @test c[end, end].lat ≈ 90°
    @test c[end, end].lon ≈ 175°
    @test abs(c[1, 2].lon - c[1, 1].lon) ≈ 5°
    @test abs(c[1, 2].lat - c[1, 1].lat) ≈ 0°
    @test abs(c[2, 1].lon - c[1, 1].lon) ≈ 0°
    @test abs(c[2, 1].lat - c[1, 1].lat) ≈ 5°
end

@testitem "Vec Grid Functions" tags = [:general] begin
    @test vecgrid(5) isa Vector{<:SimpleLatLon}
    @test vecgrid(5°) isa Vector{<:SimpleLatLon}
    @test vecgrid(deg2rad(5) * rad) isa Vector{<:SimpleLatLon}

    @test_throws "Resolution of grid is too large, it must be smaller than 90°..." vecgrid(91)
    @test_logs (:warn, "Input gridRes is negative, it will be converted to positive...") vecgrid(-deg2rad(5) * rad)

    a = vecgrid(5)
    @test length(a) == 19
    @test abs(a[1].lat - a[2].lat) ≈ 5°
end

@testitem "Helper Functions" tags = [:general] begin
    r = GeoRegion(regionName="ITA", admin="Italy")
    @test extract_countries(r) == r.domain
end