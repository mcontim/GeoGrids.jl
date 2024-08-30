"""
    GeoRegionEnlarged{D,P} <: AbstractRegion

Type representing an enlarged geographical region based on a GeoRegion.

Fields:
- `original::GeoRegion{D,P}`: The original GeoRegion
- `name::String`: Name of the enlarged region
- `domain::MultiBorder{P}`: Domain of the enlarged region
- `convexhull::PolyBorder{P}`: Convex hull of the enlarged region

# Constructors

    GeoRegionEnlarged(delta; kwargs...)
    GeoRegionEnlarged(gr::GeoRegion, delta; kwargs...)

Create an enlarged GeoRegion either from scratch or from an existing GeoRegion.

## Arguments
- `delta`: Distance to enlarge the region by, in meters
- `gr::GeoRegion`: The original GeoRegion to enlarge (for the second constructor)

## Keyword Arguments
- `name::String="enlarged_region"`: Name of the enlarged region
- `continent::String=""`: Continent of the region (only for the first constructor)
- `subregion::String=""`: Subregion within the continent (only for the first constructor)
- `admin::String=""`: Administrative area (only for the first constructor)
- `resolution::Int=110`: Resolution of the geographical data (only for the first constructor)
- `refRadius::Float64=constants.Re_mean`: Reference radius of the Earth
- `magnitude::Int=3`: Magnitude for polygon offsetting
- `precision::Int=7`: Precision for polygon offsetting

## Returns
- `GeoRegionEnlarged`: The enlarged geographical region
"""
mutable struct GeoRegionEnlarged{D,P} <: AbstractRegion
    original::GeoRegion{D,P}
    name::String
    domain::MultiBorder{P}
    convexhull::PolyBorder{P}
end

function GeoRegionEnlarged(delta::Number; name="enlarged_georegion", continent="", subregion="", admin="", resolution=110, refRadius=constants.Re_mean, magnitude=3, precision=7)
    gr = GeoRegion(; name, continent, subregion, admin, resolution)

    GeoRegionEnlarged(gr, delta; name, refRadius, magnitude, precision)
end

function GeoRegionEnlarged(gr::GeoRegion, delta::Number; name="enlarged_georegion", refRadius=constants.Re_mean, magnitude=3, precision=7)
    orLatLon = offset_region(gr, delta; refRadius, magnitude, precision)
    orCart = cartesian_geometry(orLatLon)
    or = MultiBorder(orLatLon, orCart)

    chCart = convexhull(orCart)
    chLatlon = latlon_geometry(chCart)
    ch = PolyBorder(chLatlon, chCart)

    GeoRegionEnlarged(gr, name, or, ch)
end

"""
    PolyRegionEnlarged{P} <: AbstractRegion

Struct representing an enlarged polygonal region.

Fields:
- `original::PolyRegion{P}`: The original PolyRegion
- `name::String`: Name of the enlarged region
- `domain::MultiBorder{P}`: Domain of the enlarged region as a MultiBorder

# Constructors

    PolyRegionEnlarged(deltaDist; kwargs...)
    PolyRegionEnlarged(pr::PolyRegion, deltaDist; kwargs...)

Create an enlarged PolyRegion either from scratch or from an existing PolyRegion.

## Arguments
- `deltaDist`: Distance to enlarge the region by, in meters
- `pr::PolyRegion`: The original PolyRegion to enlarge (for the second constructor)

## Keyword Arguments
- `name::String="enlarged_polyregion"`: Name of the enlarged region
- `domain`: Domain of the region (only for the first constructor)
- `refRadius::Float64=constants.Re_mean`: Reference radius of the Earth
- `magnitude::Int=3`: Magnitude for polygon offsetting
- `precision::Int=7`: Precision for polygon offsetting

## Returns
- `PolyRegionEnlarged`: The enlarged polygonal region
"""
mutable struct PolyRegionEnlarged{P} <: AbstractRegion
    original::PolyRegion{P}
    name::String
    domain::MultiBorder{P}
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