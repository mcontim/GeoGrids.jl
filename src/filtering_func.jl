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
    vertex::Union{Vector{Vector{LLA}, SVector{2, Float64}}, Vector{Meshes.Point{2, Float64}}, Vector{Tuple{Number, Number}}}
end

"""
    CountriesBorders.extract_countries(r::Region)

Extracts the countries from a given region.

It first gets the field names of the `Region` type, excluding the `:regionName`, then maps these field names to their corresponding values in the `Region` instance `r`, creating a collection of pairs. It filters out any pairs where the value is empty. It converts this collection of pairs into a `NamedTuple`, finally, it calls `CountriesBorders.extract_countries` with the `NamedTuple` as keyword arguments.

This function is an overload of `CountriesBorders.extract_countries` that takes a `Region` object as input. It extracts the countries from the given region and returns them.

## Arguments
- `r::Region`: The region from which to extract the countries. It should be an instance of the `Region` type.

## Returns
- The function returns the result of `CountriesBorders.extract_countries(;kwargs...)`.
"""
function CountriesBorders.extract_countries(r::Region)
    # Overload of CountriesBorders.extract_countries taking Region as input
    names = setdiff(fieldnames(Region), (:regionName,))

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

function in_domain(p::LLA, domain::Region)
    countriesList = extract_countries(domain) # extract Meshes.Geometry
    in_domain(p, countriesList) # `in` uses lon-lat
end

function in_domain(p::LLA, domain::PolyArea)
    in_domain(p, domain) # `in` uses lon-lat
end