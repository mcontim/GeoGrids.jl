"""
    filter_points(points::AbstractVector{<:LatLon}, domain::Union{GeoRegion, PolyRegion, LatBeltRegion}) -> Vector{Input Type}
    
Filters a list of points based on whether they fall within a specified
geographical domain.

## Arguments
- `points`: An array of points. The points are `LatLon`.
- `domain`: A geographical domain which can be of type `GeoRegion` or \
`PolyRegion`, in alternative a `Meshes.Domain` of type `GeometrySet` or \
`PolyArea`.
- `::EO`: An `EO` object for additional output containing the \
indices of the filtered points (wrt the input).

## Returns
- A vector of points that fall within the specified domain, subsection of the \
input vector. The output is of the same type as the input.
"""
function filter_points(points::AbstractVector{<:Union{LatLon,Point{🌐,<:LatLon{WGS84Latest}}}}, domain::Union{PolyRegion,LatBeltRegion})
    filtered = filter(x -> in(x, domain), points)

    return filtered
end
function filter_points(points::AbstractVector{<:Union{LatLon,Point{🌐,<:LatLon{WGS84Latest}}}}, domain::GeoRegion)
    intermediateFilter = filter(x -> in(x, domain.convexhull), points) # quick check over the convexhull
    filtered = filter(x -> in(x, domain), intermediateFilter) # accurate check over the actual domain

    return filtered
end

function filter_points(points::AbstractVector{<:Union{LatLon,Point{🌐,<:LatLon{WGS84Latest}}}}, domain::Union{PolyRegion,LatBeltRegion}, ::EO)
    indices = findall(x -> in(x, domain), points)

    return points[indices], indices
end
function filter_points(points::AbstractVector{<:Union{LatLon,Point{🌐,<:LatLon{WGS84Latest}}}}, domain::GeoRegion, ::EO)
    originalIdxInConvexhull = findall(x -> in(x, domain.convexhull), points) # quick check over the convexhull
    finalIdx = findall(x -> in(x, domain), points[originalIdxInConvexhull]) # accurate check over the actual domain

    return points[originalIdxInConvexhull[finalIdx]], originalIdxInConvexhull[finalIdx]
end

"""
    group_by_domain(points::AbstractVector{<:LatLon}, domains::AbstractVector; flagUnique=true)

Group points by regions defined in the `domains` array.

## Arguments
- `points`: An array of points. Points are of type `LatLon`.
- `domains`: An array of domains which can contain `GeoRegion`, `PolyRegion`, \
`LatBeltRegion` or a mix of the three. Each domain should have a `name` \
attribute.
- `unique`: A boolean flag. If `true`, a point is assigned to the first region \
it belongs to and is not considered for subsequent regions. If `false`, a \
    point can belong to multiple regions. Default is `true`.

## Returns
- A dictionary where keys are region names and values are arrays of points \
belonging to that region. The output is of the same type as the input.

## Errors
- Throws an error if the region names in `domains` are not unique.

## Notes
- The order of the `domains` array is important when `unique=true`. Points are \
assigned to regions in the order they appear in the `domains` array.
- The function uses the `in` function to determine if a point belongs to a \
region.
"""
# function group_by_domain(points::AbstractVector{<:Union{LatLon, Point{🌐,<:LatLon{WGS84Latest}}}}, domains::AbstractVector; flagUnique=true)
#     # Check region names validity
#     names = map(x -> x.name, domains)
#     length(unique(names)) == length(names) || error("The region names passed to group_by must be unique...")

#     groups = Dictionary(map(x -> x.name, domains), map(_ -> eltype(points)[], domains))

#     for p in points
#         for dom in domains
#             vec = groups[dom.name]
#             if p in dom
#                 push!(vec, p)
#                 flagUnique && break
#             end
#         end
#     end

#     return groups
# end
function group_by_domain(points::AbstractVector{<:Union{LatLon,Point{🌐,<:LatLon{WGS84Latest}}}}, domains::AbstractVector; flagUnique=true)
    # Check region names validity
    names = map(x -> x.name, domains)
    length(unique(names)) == length(names) || error("The region names passed to group_by must be unique...")

    groups = Dictionary(map(x -> x.name, domains), map(_ -> eltype(points)[], domains))

    for p in points
        for dom in domains
            vec = groups[dom.name]
            if _check_in(p, dom)
                push!(vec, p)
                flagUnique && break
            end
        end
    end

    return groups
end

function _check_in(p, dom::GeoRegion)
    if p in dom.convexhull # quick check over the convexhull
        if p in dom # accurate check over the actual domain
            return true
        end
    end

    return false
end

function _check_in(p, dom::Union{PolyRegion,LatBeltRegion})
    if p in dom # accurate check over the actual domain
        return true
    end

    return false
end