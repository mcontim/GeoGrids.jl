abstract type AbstractRegion end

@kwdef mutable struct GeoRegion
    regionName::String = "region_name"
    continent::String = nothing
    subregion::String = nothing
    admin::String = nothing
    domain::GeometrySet = nothing
    
    # Inner Constructor for inputs sanity check
    function GeoRegion(regionName="region_name", continent=nothing, subregion=nothing, admin=nothing, domain=nothing)
        isnothing(continent) && isnothing(subregion) && isnothing(admin) && error("Input at least one argument between continent, subregion and admin...")
    
        kwargs = (;) # Collect kwargs for `CountriesBorders.extract_countries`
        _continent = if isnothing(continent)
            ""
        else
            kwargs = (; kwargs..., continent = continent)
            continent
        end
        _subregion = if isnothing(subregion)
            ""
        else
            kwargs = (; kwargs..., subregion = subregion)
            subregion
        end
        _admin = if isnothing(admin)
            ""
        else
            kwargs = (; kwargs..., admin = admin)
            admin
        end
        _domain = if isnothing(domain)
            CountriesBorders.extract_countries(;kwargs...)
        else
            @warn "GeoRegion domain is not automatically generated from the other arguments, check inputs consistency..."
            domain
        end

        new(regionName, _continent, _subregion, _admin, _domain)
    end
end

"""
If a PolyArea is provided, the points are considered as LON-LAT, in rad, as it is in Meshes.jl domain. For all the other cases, with single points, unless it is a Vector{LLA}, the points has to be expressed as LAT-LON and values must be in ValidAngle. In all other cases, the points are reordered such to be in LON-LAT and a PolyArea with only an outer chain is built. If the chain is open a point equal to the first one is added at the end."	
"""
@kwdef mutable struct PolyRegion
    regionName::String = "region_name"
    domain::PolyArea = nothing
    
    # Inner Constructor for inputs sanity check
    function PolyRegion(regionName::String="region_name", domain::Union{Vector{LLA}, Vector{SVector{2, Float64}}, Vector{Point2}, Vector{Tuple{Float64, Float64}}, PolyArea} = nothing)
        function _polyarea_from_vertex(domain)
            points = map(domain) do p
                _point_check(p)                
            end
            # Check if the first and last points are the same to create a valid polygon
            if !(first(points[1])==first(points[end])) || !(last(points[1])==last(points[end]))
                @warn "First and last points are not the same, adding them to the end..."
                push!(points, points[1])
            end
            PolyArea(points) # Create a simple PolyArea with only the Outer Chain
        end

        # Inputs check
        isnothing(domain) && error("Input the polygon domain...")

        _domain = if domain isa PolyArea
            domain
        elseif (domain isa Vector{Tuple{Float64, Float64}}) || (domain isa Vector{SVector{2, Float64}})
            _polyarea_from_vertex(domain)
        elseif (domain isa Vector{Point2})
            points = map(x -> x.coords, domain)
            _polyarea_from_vertex(points)
        elseif typeof(domain) == Vector{Vector{LLA}}
            points = map(x -> (x.lon, x.lat), domain)
            PolyArea(points) # Create a simple PolyArea with only the Outer Chain        
        else
            error("The input domain do not match the expected format...")
        end

        new(regionName, _domain)
    end
end

###########################################################################################
##                                    Helper Functions                                   ##
###########################################################################################
"""
    _point_check(p)

Checks the validity of the given point `p` in terms of latitude (LAT) and longitude (LON) values. The function expects the input to be in radians and within the valid range for LAT and LON. If you want to pass numbers in degrees, consider using `°` from Unitful (Also re-exported by TelecomUtils) by doing `x * °`.

## Arguments
- `p`: A tuple representing a point on the globe where the first element is the latitude (LAT) and the second element is the longitude (LON).

## Returns
- A tuple with the longitude and latitude values converted to radians.
"""
function _point_check(p)
    _check_angle(first(p); limit = π/2, msg = "LAT must be provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2 Consider using `°` from Unitful (Also re-exported by TelecomUtils) if you want to pass numbers in degrees, by doing `x * °`.") # Check LAT
    _check_angle(last(p); limit = π, msg = "LON must be provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π Consider using `°` from Unitful (Also re-exported by TelecomUtils) if you want to pass numbers in degrees, by doing `x * °`.") # Check LON
    
    return (to_radians(last(p)), to_radians(first(p)))
end

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