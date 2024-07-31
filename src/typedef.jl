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

"Type of polygonal region based on PolyArea."
mutable struct PolyRegion <: AbstractRegion
    regionName::String
    domain::PolyArea
end
PolyRegion(regionName, domain::Vector{<:SimpleLatLon}) = PolyRegion(regionName, PolyArea(map(Point, domain)))
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
struct ICO <: AbstractTiling end
struct HEX <: AbstractTiling end
struct H3 <: AbstractTiling end

mutable struct TilingInit
    "Radius of the single element (cell)"
    radius::Number  
    "Tessellation type (:ICO | :HEX | :H3)"
    type::Symbol 
    "Region to be tessellated"
    region::AbstractRegion

    function TilingInit(radius, type=:ICO, region=GlobalRegion())
        # Input validation
        type in (:ICO, :HEX, :H3) || error("Tessellation type must be :ICO, :HEX or :H3")
        region isa AbstractRegion || error("Region must be of type AbstractRegion...")
        (region isa GlobalRegion && type in (:ICO, :H3)) || error("Tessellation of type :HEX cannot be used with global region...")

        new(radius, type, region)
    end
end
TilingInit(; radius, type=:ICO, region=GlobalRegion()) = TilingInit(radius, type, region)

const constants = (
    Re_mean = 6371e3, # Mean Earth Radius [m]
)