abstract type AbstractRegion end

mutable struct GeoRegion
    regionName::String
    continent::String
    subregion::String
    admin::String
    domain::GeometrySet
    
    # Inner Constructor for inputs sanity check.
    # No positional arguments allowed.
    function GeoRegion(;regionName="region_name", continent="", subregion="", admin="", domain=nothing)
        all(isempty(v) for v in (continent, subregion, admin)) && error("Input at least one argument between continent, subregion and admin...")
    
        _domain = if isnothing(domain)
            nt = (;continent, subregion, admin)
            kwargs = (k=>v for (k,v) in pairs(nt) if !isempty(v))
            CountriesBorders.extract_countries(;kwargs...)
        else
            error("The domain must be computed from the other inputs...")
        end

        new(regionName, continent, subregion, admin, _domain)
    end
end

"""
If a PolyArea is provided, the points are considered as LON-LAT, in rad, as it is in Meshes.jl domain. For all the other cases, with single points, unless it is a Vector{LLA}, the points has to be expressed as LAT-LON and values must be in ValidAngle. In all other cases, the points are reordered such to be in LON-LAT and a PolyArea with only an outer chain is built. If the chain is open a point equal to the first one is added at the end."	
"""
mutable struct PolyRegion
    regionName::String
    domain::PolyArea
    
    # Inner Constructor for inputs sanity check.
    # No positional arguments allowed.
    function PolyRegion(;regionName::String="region_name", domain=nothing)
        function _polyarea_from_vertex(domainGen)
            points = map(domainGen) do p
                _check_geopoint(p)                
            end
            # Check if the first and last points are the same to create a valid polygon
            if first(points) != last(points)
                @warn "First and last points are not the same, adding them to the end..."
                push!(points, points[1])
            end
            PolyArea(points) # Create a simple PolyArea with only the Outer Chain
        end

        # Inputs check
        isnothing(domain) && error("Input the polygon domain...")

        _domain = if domain isa PolyArea
            domain
        elseif (domain isa Vector{<:Tuple}) || (domain isa Vector{<:AbstractVector})
            _polyarea_from_vertex(domain)
        elseif (domain isa Vector{Point2})
            points = map(x -> x.coords, domain)
            _polyarea_from_vertex(points)
        elseif typeof(domain) == Vector{LLA}
            points = map(x -> (x.lon, x.lat), domain)
            _polyarea_from_vertex(points)
        else
            error("The input domain do not match the expected format...")
        end

        new(regionName, _domain)
    end
end

## Aux Functions
"""
    CountriesBorders.extract_countries(r::GeoRegion)

Extracts the countries from a given region.

It first gets the field names of the `GeoRegion` type, excluding the `:regionName`, then maps these field names to their corresponding values in the `GeoRegion` instance `r`, creating a collection of pairs. It filters out any pairs where the value is empty. It converts this collection of pairs into a `NamedTuple`, finally, it calls `CountriesBorders.extract_countries` with the `NamedTuple` as keyword arguments.

This function is an overload of `CountriesBorders.extract_countries` that takes a `GeoRegion` object as input. It extracts the countries from the given region and returns them.

## Arguments
- `r::GeoRegion`: The region from which to extract the countries. It should be an instance of the `GeoRegion` type.

## Returns
- The function returns the result of `CountriesBorders.extract_countries(;kwargs...)`.
"""
function CountriesBorders.extract_countries(r::GeoRegion)
    # Overload of CountriesBorders.extract_countries taking GeoRegion as input
    names = setdiff(fieldnames(GeoRegion), (:regionName,:domain))

    all_pairs = map(names) do n
        n => getfield(r,n)
    end 
    
    kwargs = NamedTuple(filter(x -> !isempty(x[2]), all_pairs))
    @info kwargs
    CountriesBorders.extract_countries(;kwargs...)
end