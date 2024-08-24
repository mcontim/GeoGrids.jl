## Angle Types
const UnitfulAngleType = Union{typeof(°),typeof(rad)}
const UnitfulAngleQuantity = Quantity{<:Real,<:Any,<:UnitfulAngleType}
const ValidAngle = Union{UnitfulAngleQuantity,Real}

const constants = (
    Re_mean = 6371e3, # Mean Earth Radius [m]
    a = 6378137, # [m] WGS84 semi-major axis
    b = 6356752.315 # [m] WGS84 semi-minor axis
)

## Define Region Types
abstract type AbstractRegion end

"""
    GlobalRegion

Type representing a global region.
"""
struct GlobalRegion <: AbstractRegion end

"""
    GeoRegion{D} <: AbstractRegion

Type representing a geographical region based on CountriesBorders.

## Fields:
- `name::String`: Name of the region
- `continent::String`: Continent of the region
- `subregion::String`: Subregion within the continent
- `admin::String`: Administrative area
- `domain::D`: Domain of the region
- `convexhull::PolyArea`: Convex hull of the region
"""
mutable struct GeoRegion{D} <: AbstractRegion
    name::String
    continent::String
    subregion::String
    admin::String
    domain::D
    convexhull::PolyArea
end

"""
    PolyBorder{T} <: Geometry{🌐,LATLON{T}}

Type representing a polygonal border in both LatLon and Cartesian coordinates.

## Fields:
- `latlon::POLY_LATLON{T}`: The borders in LatLon CRS
- `cart::POLY_CART{T}`: The borders in Cartesian2D CRS
"""
struct PolyBorder{T} <: Geometry{🌐,LATLON{T}}
    latlon::POLY_LATLON{T}
    cart::POLY_CART{T}

    function PolyBorder(latlon::POLY_LATLON{T}) where {T}
        cart = cartesian_geometry(latlon)
        new{T}(latlon, cart)
    end
end

"""
    PolyRegion{T} <: AbstractRegion

Type representing a polygonal region based on PolyArea.

## Fields:
- `name::String`: Name of the region
- `domain::PolyBorder{T}`: Domain of the region as a PolyBorder
"""
mutable struct PolyRegion{T} <: AbstractRegion
    name::String
    domain::PolyBorder{T}
end

"""
    LatBeltRegion <: AbstractRegion

Type representing a latitude belt region.

## Fields:
- `name::String`: Name of the region
- `latLim::Tuple{ValidAngle,ValidAngle}`: Latitude limits of the belt in radians
"""
mutable struct LatBeltRegion <: AbstractRegion
    name::String
    latLim::Tuple{ValidAngle,ValidAngle} # [rad] 

    function LatBeltRegion(name::String, latLim::Tuple{ValidAngle,ValidAngle})
        # Inputs validation    
        _latLim = map(latLim) do l
            l isa Real ? l * ° : l |> u"°" # Convert to Uniful °
        end

        for x in _latLim
            abs(x) ≤ 90° || error(
#! format: off
"LAT provided as numbers must be expressed in radians and satisfy -90 ≤ x ≤ 90. 
Consider using `°` (or `rad`) from `Unitful` if you want to pass numbers in degrees (or rad), by doing `x * °` (or `x * rad`)."
#! format: on   
            )
        end
        _latLim[1] > _latLim[2] && error("The first LAT limit must be lower than the second one...")
        _latLim[1] == _latLim[2] && error("The first LAT limit must be different than the second one...")

        new(name, _latLim)
    end
end

## Define Tessellation Types
abstract type AbstractTiling end

"""
    ICO <: AbstractTiling

Type representing an icosahedral tiling.

## Fields:
- `correction::Number`: Default correction factor for the icosahedral cell grid partial overlap
- `pattern::Symbol`: Default pattern shape to be used with this type of tiling (:circ or :hex)
"""
struct ICO <: AbstractTiling 
    correction::Number
    pattern::Symbol

    function ICO(correction::Number, pattern::Symbol)
        # Input validation
        pattern in (:circ, :hex) || error("Pattern must be :circ or :hex...")

        new(correction, pattern)
    end
end

"""
    HEX <: AbstractTiling

Type representing a hexagonal tiling.

## Fields:
- `direction::Symbol`: Default direction of hexagons in the tiling (:pointy or :flat)
- `pattern::Symbol`: Default pattern shape to be used with this type of tiling (:circ or :hex)
"""
struct HEX <: AbstractTiling 
    direction::Symbol
    pattern::Symbol

    function HEX(direction::Symbol, pattern::Symbol)
        # Input validation
        direction in (:pointy, :flat) || error("Direction must be :pointy or :flat...")
        pattern in (:circ, :hex) || error("Pattern must be :circ or :hex...")

        new(direction, pattern)
    end
end

"""
    H3 <: AbstractTiling

Type representing an H3 tiling.
"""
struct H3 <: AbstractTiling end

"""
    EO

Struct used to create function methods that return more than one output.
Used within multiple methods of the GeoGrids API, usually given as last optional argument.
"""
struct EO end