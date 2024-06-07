"""
    in_region(p::LLA, domain::Union{GeometrySet,PolyArea})
    in_region(p::LLA, domain::Union{GeoRegion, PolyRegion}) = in_region(p, domain.domain)
    in_region(p::Union{Tuple{Float64, Float64},StaticVector{2,Float64}}, domain::Union{GeometrySet,PolyArea})
    in_region(p::Union{Tuple{Float64, Float64},StaticVector{2,Float64}}, domain::Union{GeoRegion, PolyRegion}) = in_region(p, domain.domain)
    in_region(p::Point2, domain::Union{GeometrySet,PolyArea})
    in_region(p::Point2, domain::Union{GeoRegion, PolyRegion}) = in_region(p, domain.domain)

This function determines if a given point belongs to a 2-dimensional `Meshes.Domain` object. The `Meshes.Domain` object represents a geometric domain, which is essentially a 2D region in space, specified by its bounds and discretization. 

The function first converts the input tuple into a `Meshes.Point` object, which is then checked if it falls inside the given `Meshes.Domain` object.
The `Meshes.Domain` can be either a `GeometrySet` or a `PolyArea` object.

## Arguments
* `p`: A tuple of two numbers `(x,y)` representing a point in 2D space. 
* `domain::Union{GeometrySet,PolyArea}`: A `Meshes.Domain` object representing a 2D region in space. 

### Output
The function returns a boolean value: `true` if the point represented by the input tuple falls inside the `Meshes.Domain` object and `false` otherwise. 
"""
function in_region(p::LLA, domain::Union{GeometrySet, PolyArea})
    _p = (p.lon, p.lat) # Input already in radians, checked in LLA()
    Meshes.Point2(_p) in domain # Meshes.Point in Meshes.Geometry
end

function in_region(p::Union{Tuple{Float64, Float64}, StaticVector{2,Float64}}, domain::Union{GeometrySet, PolyArea})
    _p = _point_check(p) # Input check
	Meshes.Point2(_p) in domain
end

in_region(p::Point2, domain::Union{GeometrySet, PolyArea}) = in_region(p.coords, domain) # in_region(p::StaticVector{2,Float64}, domain::Union{GeometrySet, PolyArea})

in_region(p::Union{LLA, StaticVector{2,Float64}, Point2, Tuple{Float64,Float64}}, domain::Union{GeoRegion, PolyRegion}) = in_region(p, domain.domain)

function in_region(points::Union{Vector{LLA}, Vector{StaticVector{2,Float64}}, Vector{Point2}, Vector{Tuple{Float64,Float64}}}, domain::Union{GeometrySet, PolyArea})
    mask = map(x -> in_region(x, domain), points) # Bool mask
    return mask
end

in_region(points::Union{Vector{LLA}, Vector{StaticVector{2,Float64}}, Vector{Point2}, Vector{Tuple{Float64,Float64}}}, domain::Union{GeoRegion, PolyRegion}) = in_region(points, domain.domain)

"""
    filter_points(points::Union{Vector{LLA}, Vector{StaticVector{2,Float64}}, Vector{Point2}, Vector{Tuple{Float64,Float64}}}, domain::Union{GeometrySet, PolyArea})
    filter_points(points::Union{Vector{LLA}, Vector{StaticVector{2,Float64}}, Vector{Point2}, Vector{Tuple{Float64,Float64}}}, domain::Union{GeoRegion, PolyRegion})
    
Filters a list of points based on whether they fall within a specified geographical domain.

## Arguments
- `points`: A vector of points. The points can be of type `LLA`, `StaticVector{2,Float64}`, `Point2`, or `Tuple{Float64,Float64}`.
- `domain`: A geographical domain which can be of type `GeoRegion` or `PolyRegion`, in alternative a `Meshes.Domain` of type `GeometrySet` or `PolyArea`.

## Returns
- A vector of points that fall within the specified domain, subsection of the input vector.
"""
function filter_points(points::Union{Vector{LLA}, Vector{StaticVector{2,Float64}}, Vector{Point2}, Vector{Tuple{Float64,Float64}}}, domain::Union{GeometrySet, PolyArea})
    mask = in_region(points, domain)
    return points[mask]
end

filter_points(points::Union{Vector{LLA}, Vector{StaticVector{2,Float64}}, Vector{Point2}, Vector{Tuple{Float64,Float64}}}, domain::Union{GeoRegion, PolyRegion}) = filter_points(points, domain.domain)