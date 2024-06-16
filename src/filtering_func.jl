"""
    in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeometrySet, PolyArea}) -> Bool
    in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeoRegion, PolyRegion}) -> Bool
    in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeometrySet, PolyArea}) -> Array{Bool}
    in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeoRegion, PolyRegion}) -> Array{Bool}

This function determines if a given point belongs to a 2-dimensional `Meshes.Domain` object. The `Meshes.Domain` object represents a geometric domain, which is essentially a 2D region in space, specified by its bounds and discretization. 

The function first converts the input tuple into a `Point` object, which is then checked if it falls inside the given `Meshes.Domain` object.
The `Meshes.Domain` can be either a `GeometrySet` or a `PolyArea` object.

## Arguments
* `p`: A point, or a vector of points in 2D space. 
* `domain::Union{GeometrySet,PolyArea}`: A `Meshes.Domain` object representing a 2D space. 

### Output
The function returns a boolean value: `true` if the point falls inside the `Meshes.Domain` object and `false` otherwise. The output has the same shape of the input.
"""
function in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeometrySet, PolyArea})
    # Prepare the input.
    _p = _check_geopoint(p; rev=true)
    # Check if the point is inside the domain, using a Predicates from Meshes instead of an ExactPredicates.
    # There is a certain error margin for the point being exaclty inside, on the border or slightly outside. 
    # However, for the purpose of checking a point belonging to a certain geographical region, this margin 
    # of error is acceptable.
	_p in domain
end

in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::Union{GeoRegion, PolyRegion}) = in_region(p, domain.domain)

# function in_region(p::Union{LLA, Point2, AbstractVector, Tuple}, domain::LatBeltRegion)
#     # Prepare the input.
#     _p = _check_geopoint(p)

#     firs(_p) < domain.latLim[2] && 
#     _p in domain
# end

function in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeometrySet, PolyArea})
    mask = map(x -> in_region(x, domain), points) # Bool mask
    return mask
end
in_region(points::Array{<:Union{LLA, Point2, AbstractVector, Tuple}}, domain::Union{GeoRegion, PolyRegion}) = in_region(points, domain.domain)

"""
    filter_points(points::Union{Vector{LLA}, Vector{AbstractVector}, Vector{Point2}, Vector{Tuple}}, domain::Union{GeometrySet, PolyArea}) -> Vector{Input Type}
    filter_points(points::Union{Vector{LLA}, Vector{AbstractVector}, Vector{Point2}, Vector{Tuple}}, domain::Union{GeoRegion, PolyRegion}) -> Vector{Input Type}
    
Filters a list of points based on whether they fall within a specified geographical domain.

## Arguments
- `points`: A vector of points. The points can be of type `LLA`, `AbstractVector`, `Point2`, or `Tuple`.
- `domain`: A geographical domain which can be of type `GeoRegion` or `PolyRegion`, in alternative a `Meshes.Domain` of type `GeometrySet` or `PolyArea`.

## Returns
- A vector of points that fall within the specified domain, subsection of the input vector.
"""
function filter_points(points::Array{<:Union{LLA, AbstractVector, Point2, Tuple}}, domain::Union{GeometrySet, PolyArea})
    mask = in_region(points, domain)
    return points[mask]
end

filter_points(points::Array{<:Union{LLA, AbstractVector, Point2, Tuple}}, domain::Union{GeoRegion, PolyRegion}) = filter_points(points, domain.domain)