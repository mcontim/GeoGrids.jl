# Angle Types
const UnitfulAngleType = Union{typeof(°),typeof(rad)}
const UnitfulAngleQuantity = Quantity{<:Real,<:Any,<:UnitfulAngleType}
const ValidAngle = Union{UnitfulAngleQuantity,Real}

abstract type AbstractRegion end

"Type of Geographical region based on CountriesBorders."
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
PolyRegion(name, domain::Vector{<:SimpleLatLon}) = PolyRegion(name, PolyArea(map(Point, domain)))
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