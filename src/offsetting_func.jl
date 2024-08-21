using Meshes
using GeoInterface

"""
    offset_polyarea(poly::PolyArea, offset::Real, direction::Symbol=:outward) -> PolyArea

Offset a PolyArea by a given amount in the specified direction.

# Arguments
- `poly::PolyArea`: The input polygon to be offset.
- `offset::Real`: The distance by which to offset the polygon.
- `direction::Symbol`: The direction of the offset, either `:outward` (default) or `:inward`.

# Returns
- `PolyArea`: A new PolyArea that is the result of offsetting the input polygon.

# Note
This function attempts to preserve the shape of the original polygon as much as possible.
For complex polygons or large offsets, some simplification may occur.
"""
function offset_polyarea(poly::PolyArea, offset::Real, direction::Symbol=:outward)
    # Ensure the direction is valid
    direction in [:outward, :inward] || throw(ArgumentError("Direction must be either :outward or :inward"))
    
    # Convert PolyArea to a polygon
    polygon = Polygon(poly)
    
    # Determine the sign of the offset based on the direction
    offset_sign = direction == :outward ? 1 : -1
    
    # Get the boundary of the polygon
    boundary = GeoInterface.coordinates(polygon)[1]
    
    # Offset each edge of the polygon
    offsetted_points = offset_polygon_edges(boundary, offset * offset_sign)
    
    # Create a new PolyArea from the offsetted points
    PolyArea([Point(p) for p in offsetted_points])
end

"""
    offset_polygon_edges(points::Vector{<:Point}, offset::Real) -> Vector{Point}

Offset the edges of a polygon defined by a sequence of points.

# Arguments
- `points::Vector{<:Point}`: The sequence of points defining the polygon.
- `offset::Real`: The distance by which to offset the edges.

# Returns
- `Vector{Point}`: A new sequence of points defining the offsetted polygon.
"""
function offset_polygon_edges(points::Vector{<:Point}, offset::Real)
    n = length(points)
    offsetted_points = similar(points)
    
    for i in 1:n
        prev = points[mod1(i-1, n)]
        curr = points[i]
        next = points[mod1(i+1, n)]
        
        # Calculate edge normals
        v1 = curr - prev
        v2 = next - curr
        n1 = Point(-v1.y, v1.x)
        n2 = Point(-v2.y, v2.x)
        
        # Normalize and scale normals
        n1 = n1 / √(n1.x^2 + n1.y^2) * offset
        n2 = n2 / √(n2.x^2 + n2.y^2) * offset
        
        # Calculate offset points
        p1 = curr + n1
        p2 = curr + n2
        
        # Intersect offset lines to get new corner point
        offsetted_points[i] = line_intersection(prev + n1, p1, p2, next + n2)
    end
    
    offsetted_points
end

"""
    line_intersection(p1::Point, p2::Point, p3::Point, p4::Point) -> Point

Calculate the intersection point of two lines defined by two points each.

# Arguments
- `p1::Point`, `p2::Point`: Two points defining the first line.
- `p3::Point`, `p4::Point`: Two points defining the second line.

# Returns
- `Point`: The intersection point of the two lines.
"""
function line_intersection(p1::Point, p2::Point, p3::Point, p4::Point)
    x1, y1 = p1.x, p1.y
    x2, y2 = p2.x, p2.y
    x3, y3 = p3.x, p3.y
    x4, y4 = p4.x, p4.y
    
    den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    if den == 0
        # Lines are parallel, return midpoint
        return Point((x1 + x2 + x3 + x4) / 4, (y1 + y2 + y3 + y4) / 4)
    end
    
    t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
    
    x = x1 + t * (x2 - x1)
    y = y1 + t * (y2 - y1)
    
    Point(x, y)
end


"""
    plot_offset_comparison(original::PolyArea, offset::PolyArea)

Plot the original and offset PolyArea objects for comparison.

# Arguments
- `original::PolyArea`: The original polygon
- `offset::PolyArea`: The offset polygon

# Returns
- `Plot`: A plot object showing both polygons
"""
function plot_offset_comparison(original::PolyArea, offset::PolyArea)
    # Convert PolyArea objects to arrays of coordinates
    original_coords = [(p.x, p.y) for p in original.points]
    offset_coords = [(p.x, p.y) for p in offset.points]
    
    # Create the plot
    p = plot(
        legend=:topright,
        aspect_ratio=:equal,
        title="Original vs Offset Polygon",
        xlabel="X",
        ylabel="Y"
    )
    
    # Plot original polygon
    plot!(p, first.(original_coords), last.(original_coords), 
          label="Original", color=:blue, linewidth=2)
    
    # Plot offset polygon
    plot!(p, first.(offset_coords), last.(offset_coords), 
          label="Offset", color=:red, linewidth=2, linestyle=:dash)
    
    # Add markers for vertices
    scatter!(p, first.(original_coords), last.(original_coords), 
             label="Original Vertices", color=:blue, markersize=4)
    scatter!(p, first.(offset_coords), last.(offset_coords), 
             label="Offset Vertices", color=:red, markersize=4)
    
    return p
end


# //NOTE: NExt Step: 
# [x] Use Clipping.jl for offsetting the polygon
# [] Starting from the example notebook `polygon_offset.jl`, understand the relation between the value δ and the increase/decrease in polygon area
# [] Test the package with CountriesBorders to see if it works with those domains
# [] Map the value of δ to a Lat-Lon quantity for enlargement/decrease in area
# [] Write an interface function between CountriesBorders/Meshes and Clipping.jl

# [] Investigate alternative packages for polygon offsetting:
#    - GeometryBasics.jl: Provides basic geometric types and operations
#    - Meshes.jl: Offers advanced mesh processing capabilities
#    - LazySets.jl: Includes polygon operations and may support offsetting
#    - Clipper.jl: A Julia wrapper for the Clipper library, which supports polygon offsetting
# [] Compare the features and performance of these packages with Clipping.jl
# [] Choose the most suitable package for our polygon offsetting needs




