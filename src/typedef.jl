## Angle Types
const UnitfulAngleType = Union{typeof(°),typeof(rad)}
const UnitfulAngleQuantity = Quantity{<:Real,<:Any,<:UnitfulAngleType}
const ValidAngle = Union{UnitfulAngleQuantity,Real}

## Define Region Types
abstract type AbstractRegion end

"Type of global region."
struct GlobalRegion <: AbstractRegion end

"Type of geographical region based on CountriesBorders."
mutable struct GeoRegion{D} <: AbstractRegion
    regionName::String
    continent::String
    subregion::String
    admin::String
    domain::D
end
function GeoRegion(; regionName="region_name", continent="", subregion="", admin="")
    all(isempty(v) for v in (continent, subregion, admin)) && error("Input at least one argument between continent, subregion and admin...")

    nt = (; continent, subregion, admin)
    kwargs = (k => v for (k, v) in pairs(nt) if !isempty(v))
    domain = CountriesBorders.extract_countries(; kwargs...)

    GeoRegion(regionName, continent, subregion, admin, domain)
end

struct PolyBorder{T} <: Geometry{🌐,LATLON{T}}
    "The borders in LatLon CRS"
    latlon::POLY_LATLON{T}
    "The borders in Cartesian2D CRS"
    cart::POLY_CART{T}

    function PolyBorder(latlon::POLY_LATLON{T}) where {T}
        cart = cartesian_geometry(latlon)
        new{T}(latlon, cart)
    end
end

"Type of polygonal region based on PolyArea."
mutable struct PolyRegion{T} <: AbstractRegion
    regionName::String
    domain::PolyBorder{T}
end
PolyRegion(regionName, domain::Vector{<:LatLon}) = PolyRegion(regionName, PolyBorder(PolyArea(map(Point, domain))))
PolyRegion(; regionName::String="region_name", domain) = PolyRegion(regionName, domain)

"Type of region representinga a latitude belt region."
mutable struct LatBeltRegion <: AbstractRegion
    regionName::String
    latLim::Tuple{ValidAngle,ValidAngle} # [rad] 

    function LatBeltRegion(regionName::String, latLim::Tuple{ValidAngle,ValidAngle})
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

        new(regionName, _latLim)
    end
end
LatBeltRegion(; regionName::String="region_name", latLim) = LatBeltRegion(regionName, latLim)

## Define Tessellation Types
abstract type AbstractTiling end
struct ICO <: AbstractTiling 
    "Default correction factor for the icosahedral cell grid partial overlap"
    correction::Number
    "Default pattern shape to be used with this type of tiling"
    pattern::Symbol

    function ICO(correction::Number, pattern::Symbol)
        # Input validation
        pattern in (:circ, :hex) || error("Pattern must be :circ or :hex...")

        new(correction, pattern)
    end
end
ICO(; correction::Number=3/2, pattern::Symbol=:circ) = ICO(correction, pattern)
struct HEX <: AbstractTiling 
    "Default direction of hexagons in the tiling"
    direction::Symbol
    "Default pattern shape to be used with this type of tiling"
    pattern::Symbol

    function HEX(direction::Symbol, pattern::Symbol)
        # Input validation
        direction in (:pointy, :flat) || error("Direction must be :pointy or :flat...")
        pattern in (:circ, :hex) || error("Pattern must be :circ or :hex...")

        new(direction, pattern)
    end
end
HEX(; direction::Symbol=:pointy, pattern::Symbol=:hex) = HEX(direction, pattern)

struct H3 <: AbstractTiling end

"""
Struct used to create function methods that return more than one output.
Used within multiple methods of the GeoGrids API, usually given as last optional argument.
"""
struct ExtraOutput end

const constants = (
    Re_mean = 6371e3, # Mean Earth Radius [m]
    a = 6378137, # [m] WGS84 semi-major axis
    b = 6356752.315 # [m] WGS84 semi-minor axis
)