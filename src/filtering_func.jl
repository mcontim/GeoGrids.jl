"""
    Base.in(point::SimpleLatLon, domain::Union{GeoRegion, PolyRegion})
    Base.in(point::SimpleLatLon, domain::LatBeltRegion)
    Base.in(point::SimpleLatLon, domain::Array{<:AbstractRegion})

Check if a geographical point is within a specified region.

## Arguments
- `point::SimpleLatLon`: The geographical point to be checked.
- `domain::Union{GeoRegion, PolyRegion}`: The region in which the point is to be checked. The region is represented by the `domain` attribute.

## Returns
- `Bool`: Returns `true` if the point is within the region, `false` otherwise.
"""
Base.in(point::SimpleLatLon, domain::Union{GeoRegion, PolyRegion}) = Base.in(point, domain.domain)
Base.in(point::SimpleLatLon, domain::LatBeltRegion) = domain.latLim[1] < point.lat < domain.latLim[2]
Base.in(point::SimpleLatLon, domain::Array{<:AbstractRegion}) = error("The domain should be a single element of type <:AbstractRegion")

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