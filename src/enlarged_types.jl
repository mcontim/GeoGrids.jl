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
mutable struct GeoRegionEnlarged{D} <: AbstractRegion
    original::GeoRegion{D}
    name::String
    domain::MultiBorder
    convexhull::PolyBorder
end

function GeoRegionEnlarged(deltaDist; name="enlarged_region", continent="", subregion="", admin="", refRadius=constants.Re_mean, magnitude=3, precision=7)
    gr = GeoRegion(; name, continent, subregion, admin)

    GeoRegionEnlarged(gr, deltaDist; name, refRadius, magnitude, precision)
end

function GeoRegionEnlarged(gr::GeoRegion, deltaDist; name="enlarged_region", refRadius=constants.Re_mean, magnitude=3, precision=7)
    orLatLon = offset_region(gr, deltaDist; refRadius, magnitude, precision)
    orCart = cartesian_geometry(orLatLon)
    or = MultiBorder(orLatLon, orCart)

    chCart = convexhull(orCart)
    chLatlon = latlon_geometry(chCart)
    ch = PolyBorder(chLatlon, chCart)

    GeoRegionEnlarged(gr, name, or, ch)
end