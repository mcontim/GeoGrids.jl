@kwdef mutable struct Region
    regionName::String = "region_name"
    continent::String = ""
    subregion::String = ""
    admin::String = ""
end

function _extract_countries(r::Region)
    names = setdiff(fieldnames(Region), (:regionName,))
     
    all_pairs = map(names) do n
       n => getfield(r,n)
    end 
    
    kwargs = NamedTuple(filter(x -> !isempty(x[2]), all_pairs))
    @info kwargs
    CountriesBorders.extract_countries(;kwargs...)
 end
 