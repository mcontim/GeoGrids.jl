abstract type AbstractRegion end

@kwdef mutable struct GeoRegion
    regionName::String = "region_name"
    continent::String
    subregion::String
    admin::String
end

function GeoRegion(regionName::String="region_name", continent::String=nothing, subregion::String=nothing, admin::String=nothing)
    # Inputs check
    isnothing(continent) && isnothing(subregion) && isnothing(admin) && error("Input at least one argument between continent, subregion and admin...")

    _continent = isnothing(continent) ? "" : continent
    _subregion = isnothing(subregion) ? "" : subregion
    _admin = isnothing(admin) ? "" : admin

    return GeoRegion(regionName, _continent, _subregion, _admin)
end

@kwdef mutable struct PolyRegion
    regionName::String = "region_name"
    "Unless it ia a Vector{LLA}, the points has to be expressed as lon-lat and values must be in rad"	
    vertex::Union{Vector{LLA}, Vector{SVector{2, Float64}}, Vector{Point2}, Vector{Tuple{Float64, Float64}}, PolyArea}
end

function PolyRegion(regionName::String="region_name", vertex::Union{Vector{LLA}, Vector{SVector{2, Float64}}, Vector{Point2}, Vector{Tuple{Float64, Float64}}, PolyArea} = nothing)
    # Inputs check
    isnothing(vertex) && error("Input the polygon vertex...")

    _vertex = if vertex isa PolyArea
        vertex
    elseif (vertex isa Vector{Point2}) || (vertex isa Vector{Tuple{Float64, Float64}}) 
        PolyArea(vertex)
    elseif typeof(vertex) == Vector{Vector{LLA}}
        points = map(vertex) do p
            (rad2deg(p.lon), rad2deg(p.lat))
        end
        PolyArea(points)
    elseif typeof(vertex) == Vector{SVector{2, Float64}}
        points = map(vertex) do p
            (first(p), last(p))
        end
        PolyArea(points)
    else
        error("The input vertex do not match the expected format...")
    end

    return PolyRegion(regionName, _vertex)
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
    names = setdiff(fieldnames(GeoRegion), (:regionName,))

    all_pairs = map(names) do n
        n => getfield(r,n)
    end 
    
    kwargs = NamedTuple(filter(x -> !isempty(x[2]), all_pairs))
    @info kwargs
    CountriesBorders.extract_countries(;kwargs...)
end





"""
    Base.in(p::Tuple{Number, Number}, domain::Meshes.Domain)`

This function determines if a given point `(x, y)` represented as a tuple of two numbers, belongs to a 2-dimensional `Meshes.Domain` object. The `Meshes.Domain` object represents a geometric domain, which is essentially a 2D region in space, specified by its bounds and discretization. 

The function first converts the input tuple into a `Meshes.Point` object, which is then checked if it falls inside the given `Meshes.Domain` object.

### Arguments
* `p::Tuple{Number, Number}`: A tuple of two numbers `(x,y)` representing a point in 2D space. 
* `domain::Meshes.Domain`: A `Meshes.Domain` object representing a 2D region in space. 

### Output
The function returns a boolean value: `true` if the point represented by the input tuple falls inside the `Meshes.Domain` object and `false` otherwise. 
"""
# function in_domain(p::Tuple{Number, Number}, domain::Meshes.Domain)
# 	Meshes.Point{2, Float64}(p) in domain
# end

# function in_domain(p::SVector{2,Number}, domain::Meshes.Domain)
# 	Meshes.Point{2, Float64}(p) in domain
# end

function in_domain(p::LLA, domain)
    _p = (rad2deg(p.lon), rad2deg(p.lat))
	Meshes.Point{2, Float64}(_p) in domain # Meshes.Point in Meshes.Geometry
end

function in_domain(p::LLA, domain::GeoRegion)
    countriesList = extract_countries(domain) # extract Meshes.Geometry
    in_domain(p, countriesList) # `in` uses lon-lat
end

function in_domain(p::LLA, domain::PolyArea)
    in_domain(p, domain) # `in` uses lon-lat
end