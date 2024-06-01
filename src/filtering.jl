@kwdef mutable struct Region
    regionName::String = "region_name"
    continent::String = ""
    subregion::String = ""
    admin::String = ""
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