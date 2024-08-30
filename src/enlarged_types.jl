"""
    GeoRegionEnlarged{D} <: AbstractRegion

Type representing an enlarged geographical region based on a GeoRegion.

Fields:
- `original::GeoRegion{D}`: The original GeoRegion
- `name::String`: Name of the enlarged region
- `domain::MultiBorder`: Domain of the enlarged region
- `convexhull::PolyBorder`: Convex hull of the enlarged region

# Constructors

    GeoRegionEnlarged(deltaDist; kwargs...)
    GeoRegionEnlarged(gr::GeoRegion, deltaDist; kwargs...)

Create an enlarged GeoRegion either from scratch or from an existing GeoRegion.

## Arguments
- `deltaDist`: Distance to enlarge the region by
- `gr::GeoRegion`: The original GeoRegion to enlarge (for the second constructor)

## Keyword Arguments
- `name::String="enlarged_region"`: Name of the enlarged region
- `continent::String=""`: Continent of the region (only for the first constructor)
- `subregion::String=""`: Subregion within the continent (only for the first constructor)
- `admin::String=""`: Administrative area (only for the first constructor)
- `refRadius::Float64=constants.Re_mean`: Reference radius of the Earth
- `magnitude::Int=3`: Magnitude for polygon offsetting
- `precision::Int=7`: Precision for polygon offsetting

## Returns
- `GeoRegionEnlarged`: The enlarged geographical region
"""
mutable struct GeoRegionEnlarged{D,P} <: AbstractRegion # Use parametric precision (e.g., Float32, Float64) for the coordinates.
    original::GeoRegion{D}
    name::String
    domain::MultiBorder{P}
    convexhull::PolyBorder{P}
end

function GeoRegionEnlarged(deltaDist; name="enlarged_georegion", continent="", subregion="", admin="", resolution=110, refRadius=constants.Re_mean, magnitude=3, precision=7)
    gr = GeoRegion(; name, continent, subregion, admin, resolution)

    GeoRegionEnlarged(gr, deltaDist; name, refRadius, magnitude, precision)
end

function GeoRegionEnlarged(gr::GeoRegion, deltaDist; name="enlarged_georegion", refRadius=constants.Re_mean, magnitude=3, precision=7)
    orLatLon = offset_region(gr, deltaDist; refRadius, magnitude, precision)
    orCart = cartesian_geometry(orLatLon)
    or = MultiBorder(orLatLon, orCart)

    chCart = convexhull(orCart)
    chLatlon = latlon_geometry(chCart)
    ch = PolyBorder(chLatlon, chCart)

    GeoRegionEnlarged(gr, name, or, ch)
end

mutable struct PolyRegionEnlarged{P} <: AbstractRegion # Use parametric precision (e.g., Float32, Float64) for the coordinates.
    original::PolyRegion{P}
    name::String
    domain::MultiBorder{P}
    # No convexhull needed for PolyRegion, it is always a single polygon, fast for filtering functions.
end

function PolyRegionEnlarged(deltaDist; name="enlarged_polyregion", domain, refRadius=constants.Re_mean, magnitude=3, precision=7)
    pr = PolyRegion(name, domain)

    PolyRegionEnlarged(pr, deltaDist; name, refRadius, magnitude, precision)
end

function PolyRegionEnlarged(pr::PolyRegion, deltaDist; name="enlarged_polyregion", refRadius=constants.Re_mean, magnitude=3, precision=7)
    orLatLon = offset_region(pr, deltaDist; refRadius, magnitude, precision)
    orCart = cartesian_geometry(orLatLon)
    or = MultiBorder(orLatLon, orCart)

    PolyRegionEnlarged(pr, name, or)
end

# PolyRegion(name, domain::Vector{<:LatLon}) = PolyRegion(name, PolyBorder(PolyArea(map(Point, domain))))
# PolyRegion(; name::String="region_name", domain) = PolyRegion(name, domain)