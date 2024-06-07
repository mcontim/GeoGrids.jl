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
                _check_point(p)                
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