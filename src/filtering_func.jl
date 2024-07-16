"""
    in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeometrySet, PolyArea}) -> Bool
    in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeoRegion, PolyRegion}) -> Bool
    in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::LatBeltRegion) -> Bool
    in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeometrySet, PolyArea}) -> Array{Bool}
    in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeoRegion, PolyRegion}) -> Array{Bool}
    in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::LatBeltRegion) -> Array{Bool}

This function determines if a given point belongs to a 2-dimensional `Meshes.Domain` object. The `Meshes.Domain` object represents a geometric domain, which is essentially a 2D region in space, specified by its bounds and discretization. 

The function first converts the input tuple into a `Point` object, which is then checked if it falls inside the given `Meshes.Domain` object.
The `Meshes.Domain` can be either a `GeometrySet` or a `PolyArea` object.

## Arguments
* `p`: A point, or a vector of points in 2D space. 
* `domain::Union{GeometrySet,PolyArea}`: A `Meshes.Domain` object representing a 2D space. 

### Output
The function returns a boolean value: `true` if the point falls inside the `Meshes.Domain` object and `false` otherwise. The output has the same shape of the input.
"""
# function in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeometrySet, PolyArea})
#     # Prepare the input.
#     _p = _check_geopoint(p; rev=true)
#     # Check if the point is inside the domain, using a Predicates from Meshes instead of an ExactPredicates.
#     # There is a certain error margin for the point being exaclty inside, on the border or slightly outside. 
#     # However, for the purpose of checking a point belonging to a certain geographical region, this margin 
#     # of error is acceptable.
# 	_p in domain
# end

# in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeoRegion, PolyRegion}) = in_region(p, domain.domain)

# function in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeometrySet, PolyArea})
#     mask = map(x -> in_region(x, domain), points) # Bool mask
#     return mask
# end

# in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeoRegion, PolyRegion}) = in_region(points, domain.domain)

# function in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::LatBeltRegion)
#     # Prepare the input.
#     _p = _check_geopoint(p; unit=:rad)
#     # Check if the LAT of the point is inside the Latitude Belt region.
#     domain.latLim[1] < first(_p.coords) < domain.latLim[2] ? true : false 
# end

# function in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::LatBeltRegion)
#     mask = map(x -> in_region(x, domain), points) # Bool mask
#     return mask
# end

######################
Base.in(point::SimpleLatLon, domain::Union{GeoRegion, PolyRegion}) = Base.in(point, domain.domain)
Base.in(point::SimpleLatLon, domain::LatBeltRegion) = domain.latLim[1] < point.lat < domain.latLim[2]
Base.in(point::SimpleLatLon, domain::Array{<:AbstractRegion}) = error("The domain should be a single element of type <:AbstractRegion")
######################


"""
    filter_points(points::Union{Vector{LLA}, Vector{AbstractVector}, Vector{Point2}, Vector{Tuple}}, domain::Union{GeometrySet, PolyArea, LatBeltRegion}) -> Vector{Input Type}
    filter_points(points::Union{Vector{LLA}, Vector{AbstractVector}, Vector{Point2}, Vector{Tuple}}, domain::Union{GeoRegion, PolyRegion}) -> Vector{Input Type}
    
Filters a list of points based on whether they fall within a specified geographical domain.

## Arguments
- `points`: A vector of points. The points can be of type `LLA`, `AbstractVector`, `Point2`, or `Tuple`.
- `domain`: A geographical domain which can be of type `GeoRegion` or `PolyRegion`, in alternative a `Meshes.Domain` of type `GeometrySet` or `PolyArea`.

## Returns
- A vector of points that fall within the specified domain, subsection of the input vector.
"""
# function filter_points(points::Array{<:Union{LLA, AbstractVector, Point2, Tuple}}, domain::Union{GeometrySet, PolyArea, LatBeltRegion})
#     # mask = in_region(points, domain)
#     # return points[mask]
#     filt = filter(x -> in_region(x, domain), points)
#     return filt
# end
# filter_points(points::Array{<:Union{LLA, AbstractVector, Point2, Tuple}}, domain::Union{GeoRegion, PolyRegion}) = filter_points(points, domain.domain)

function filter_points(points::Array{<:SimpleLatLon}, domain::Union{GeoRegion, PolyRegion, LatBeltRegion})
    filt = filter(x -> in(x, domain), points)
    return filt
end


"""
    group_by_domain(points::Array{<:Union{LLA, AbstractVector, Point2, Tuple}}, domains::Array; unique=true)

Group points by regions defined in the `domains` array.

## Arguments
- `points`: An array of points. Points can be of type `LLA`, `AbstractVector`, `Point2`, or `Tuple`.
- `domains`: An array of domains which can contain `GeoRegion`, `PolyRegion`, `LatBeltRegion` or a mix of the three. Each domain should have a `regionName` attribute.
- `unique`: A boolean flag. If `true`, a point is assigned to the first region it belongs to and is not considered for subsequent regions. If `false`, a point can belong to multiple regions. Default is `true`.

## Returns
- A dictionary where keys are region names and values are arrays of points belonging to that region.

## Errors
- Throws an error if the region names in `domains` are not unique.

## Notes
- The order of the `domains` array is important when `unique=true`. Points are assigned to regions in the order they appear in the `domains` array.
- The function uses the `in_region` function to determine if a point belongs to a region.
"""
# function group_by_domain(points::Array{<:Union{LLA, AbstractVector, Point2, Tuple}}, domains::Array; flagUnique=true)
#     # Check region names validity
#     names = map(x -> x.regionName, domains)
#     length(unique(names)) == length(names) || error("The region names passed to group_by must be unique...")
    
#     groups = Dictionary(map(x -> x.regionName, domains), map(_ -> eltype(points)[], domains))

#     for p in points
#         for dom in domains
#             vec = groups[dom.regionName]
#             if in_region(p, dom)
#                 push!(vec, p)
#                 flagUnique && break
#             end
#         end
#     end

#     return groups
# end
function group_by_domain(points::Array{<:SimpleLatLon}, domains::Array; flagUnique=true)
    # Check region names validity
    names = map(x -> x.regionName, domains)
    length(unique(names)) == length(names) || error("The region names passed to group_by must be unique...")
    
    groups = Dictionary(map(x -> x.regionName, domains), map(_ -> eltype(points)[], domains))

    for p in points
        for dom in domains
            vec = groups[dom.regionName]
            if p in dom
                push!(vec, p)
                flagUnique && break
            end
        end
    end

    return groups
end