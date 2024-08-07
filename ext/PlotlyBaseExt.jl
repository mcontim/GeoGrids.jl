module PlotlyBaseExt

using PlotlyExtensionsHelper
using PlotlyBase

using GeoGrids

## Auxiliary Functions
"""
    _cast_geopoint(p::Union{AbstractVector, Tuple})
    _cast_geopoint(p::SimpleLatLon)

Convert various types of input representations into a `SimpleLatLon` object.
This method assumes that the input coordinates are in degrees. It converts the
latitude and longitude from degrees to radians before creating a `SimpleLatLon`
object.

## Arguments
- `p::Union{AbstractVector, Tuple}`: A 2D point where the first element is the \
latitude and the second element is the longitude, both in degrees.

## Returns
- `SimpleLatLon`: An object representing the geographical point with latitude \
and longitude converted to radians.

## Errors
- Throws an `ArgumentError` if the input `p` does not have exactly two elements.
"""
function _cast_geopoint(p::Union{AbstractVector,Tuple})
    length(p) != 2 && error("The input must be a 2D point...")
    lat = first(p)
    lon = last(p)
    # Inputs are considered in degrees
    return SimpleLatLon(lat * °, lon * °)
end
_cast_geopoint(p::SimpleLatLon) = p

# Produce specific geometries for plots.
"""
    _gen_circle(cx::Number, cy::Number, r::Number, f::Function=identity, n::Int=100)
    _gen_circle(center::SimpleLatLon, r::Number, n::Int=100)

The `_gen_circle` function generates a set of points representing a circle
centered at `(cx, cy)` with a radius `r`. The points are calculated using the
parametric equations for a circle. An optional function `f` can be applied to
each point, and the number of points `n` can be specified to control the
resolution of the circle.

## Arguments
- `cx::Number`: The x-coordinate of the circle's center.
- `cy::Number`: The y-coordinate of the circle's center.
- `r::Number`: The radius of the circle.
- `f::Function=identity`: An optional function to be applied to each point of \
the circle. The default function is `identity`, which returns the points \
unchanged.
- `n::Int=100`: The number of points to generate on the circle. The default \
value is 100.

## Returns
- `Array`: An array of points `(x, y)` on the circle, after applying the \
function `f` to each point.
"""
function _gen_circle(cx::Number, cy::Number, r::Number; f::Function=identity, n::Int=100)
    # Calculate the angle step
    angle = 0:2π/n:2π

    circle_points = map(angle) do ang
        (cx + r * cos(ang), cy + r * sin(ang))
    end

    return map(x -> f.(x), circle_points)
end

function _gen_circle(center::SimpleLatLon, r::Number; earth_local_radius=constants.Re_mean, n::Int=100)
    # Radius in meters.
    # The output is a Vector of values in deg for the sake of simplicity of the plotting.
    cx = center.lon |> ustrip |> deg2rad
    cy = center.lat |> ustrip |> deg2rad
    r = r / earth_local_radius

    return _gen_circle(cx, cy, r; f=rad2deg, n=n)
end

# Internal functions for creating the scatter plots.
"""
    _get_scatter_points(points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}; kwargs...) -> PlotlyJS.Plot

This function takes an array of geographic points and generates a scatter plot using the `scattergeo` function from the PlotlyJS package. The points are converted to a vector of `SimpleLatLon` objects if they are not already. The latitude and longitude of each point are extracted and used to create the scatter plot.

## Arguments
- `points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array of points that can be of type `SimpleLatLon`, `AbstractVector`, or `Tuple`. Each point represents a geographic location.

## Keyword Arguments
- `kwargs`: Additional keyword arguments to customize the `scattergeo` plot. These arguments are passed directly to the `scattergeo` function from PlotlyJS.

## Returns
- A `PlotlyJS.Plot` object representing the scatter plot of the provided geographic points.

See also: [`_cast_geopoint`](@ref)
"""
function _get_scatter_points(points::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}; kwargs...)
    # Markers for the points
    vec_p = map(x -> _cast_geopoint(x), points[:]) # Convert in a vector of SimpleLatLon

    return scattergeo(
        lat=map(x -> x.lat, vec_p), # Vectorize such to be sure to avoid matrices.
        lon=map(x -> x.lon, vec_p), # Vectorize such to be sure to avoid matrices.
        mode="markers",
        marker_size=5,
        kwargs...
    )
end

"""
    _get_scatter_cellcontour(cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}, radius::Number; circ_res=100, kwargs...) -> PlotlyJS.Plot
    _get_scatter_cellcontour(mesh::AbstractVector{<:Ngon}; kwargs...) -> PlotlyJS.Plot

This function has two methods for generating scatter plots:
1. For circular cell contours: Takes an array of cell centers and a radius to generate circular contours around each center.
2. For polygonal meshes: Takes a mesh of `Ngon` objects and generates a scatter plot of the mesh polygons.

# Method 1
## Arguments
- `cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array of points representing the centers of cells. Each point can be of type `SimpleLatLon`, `AbstractVector`, or `Tuple`.
- `radius::Number`: The radius of the circular cell contours.
- `circ_res::Integer=100`: (Optional) The number of points used to approximate the circle. Defaults to 100.
- `kwargs`: Additional keyword arguments to customize the `scattergeo` plot. These arguments are passed directly to the `scattergeo` function from PlotlyJS.

## Returns
- A `PlotlyJS.Plot` object representing the scatter plot of the circular cell contours.

# Method 2
## Arguments
- `mesh::AbstractVector{<:Ngon}`: An array of `Ngon` objects representing a polygonal mesh. Each `Ngon` object should have vertices with `coords.x` and `coords.y` attributes.
- `kwargs`: Additional keyword arguments to customize the `scattergeo` plot. These arguments are passed directly to the `scattergeo` function from PlotlyJS.

## Returns
- A `PlotlyJS.Plot` object representing the scatter plot of the polygonal mesh.
"""
function _get_scatter_cellcontour(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; circ_res=100, kwargs...)
    # This function generates the scatter plot for circular cell contour.
    cellCenters = map(x -> _cast_geopoint(x), cellCenters[:]) # Convert in a vector of SimpleLatLon
    x_plot = [] # deg
    y_plot = [] # deg
    for c in cellCenters
        points = _gen_circle(c, radius; n=circ_res)
        push!(x_plot, [first.(points)..., NaN]...)
        push!(y_plot, [last.(points)..., NaN]...)
    end

    # Markers for the points
    return scattergeo(
        lat=y_plot, # Vectorize such to be sure to avoid matrices.
        lon=x_plot, # Vectorize such to be sure to avoid matrices.
        mode="lines",
        marker_size=1,
        kwargs...
    )
end

function _get_scatter_cellcontour(mesh::AbstractVector{<:Ngon}; kwargs...)
    # Extract scatter plot from mesh.
    meshTrace = []
    for poly in mesh
        thisNgon = map(poly.vertices) do vertex
            (ustrip(vertex.coords.x), ustrip(vertex.coords.y))
        end
        push!(meshTrace, [thisNgon..., (NaN, NaN)]...)
    end

    return scattergeo(
        lat=map(x -> last(x), meshTrace),
        lon=map(x -> first(x), meshTrace),
        mode="lines",
        marker_size=1,
        kwargs...
    )
end

function _get_default_geolayout(; title="Point Position GEO Map", camera::Symbol=:twodim,  kwargs...)
    if camera == :threedim
        projection = "orthographic"
    else
        projection = "natural earth"
    end

    # Create the geo layout
    return Layout(
        geo=attr(
            projection=attr(
                type="robinson",
            ),
            showocean=true,
            # oceancolor =  "rgb(0, 255, 255)",
            oceancolor="rgb(255, 255, 255)",
            showland=true,
            # landcolor =  "rgb(230, 145, 56)",
            landcolor="rgb(217, 217, 217)",
            showlakes=true,
            # lakecolor =  "rgb(0, 255, 255)",
            lakecolor="rgb(255, 255, 255)",
            showcountries=true,
            lonaxis=attr(
                showgrid=true,
                gridcolor="rgb(102, 102, 102)"
            ),
            lataxis=attr(
                showgrid=true,
                gridcolor="rgb(102, 102, 102)"
            )
        ),
        title=title;
        geo_projection_type=projection,
        kwargs...
    )
end

## Core plotting functions.
"""
    plot_unitarysphere(points_cart)

This function takes an SVector{3} of Cartesian coordinates and plots the
corresponding points on a unitary sphere. The sphere is defined by a range of
angles that are discretized into a grid of n_sphere points.

## Arguments:
- `points_cart`: an array of Cartesian coordinates of the points to be plotted \
on the unitary sphere.
## Output:
- Plot of the unitary sphere with the input points represented as markers.
"""
function GeoGrids.plot_unitarysphere(points_cart; kwargs_scatter=(;), kwargs_layout=(;))
    # Reference Sphere
    n_sphere = 100
    u = range(-π, π; length=n_sphere)
    v = range(0, π; length=n_sphere)
    x_sphere = cos.(u) * sin.(v)'
    y_sphere = sin.(u) * sin.(v)'
    z_sphere = ones(n_sphere) * cos.(v)'
    color = ones(size(z_sphere))
    sphere = surface(
        z=z_sphere,
        x=x_sphere,
        y=y_sphere,
        colorscale=[[0, "rgb(2,204,150)"], [1, "rgb(2,204,150)"]],
        showscale=false
    )

    # Take an array of SVector
    markers = scatter3d(;
        x=map(x -> x[1], points_cart),
        y=map(x -> x[2], points_cart),
        z=map(x -> x[3], points_cart),
        mode="markers",
        marker_size=4,
        marker_color="rgb(0,0,0)",
        kwargs_scatter...
    )

    layout = Layout(;
        scene=attr(
            xaxis=attr(
                visible=false,
            ),
            yaxis=attr(
                visible=false,
            ),
            zaxis=attr(
                visible=false,
            ),
        ),
        width=700,
        kwargs_layout...
    )

    # Plot([sphere,markers],layout)
    plotly_plot([sphere, markers], layout)
end

"""
    plot_geo_points(points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    plot_geo_points(points; kwargs...)

This function takes an Array of LAT-LON coordinates and generates a plot on a
world map projection using the PlotlyJS package.

## Arguments
- `points::AbstractVector{SVector{2, <:Real}}:` List of 2-dimensional \
coordinates (lon,lat) in the form of an AbstractVector of SVector{2, <:Real} \
elements (LAT=y, LON=x).
- `title::String`: (optional) Title for the plot, default is "Point Position 3D \
Map".
- `camera::Symbol`: (optional) The camera projection to use, either :twodim \
(default) or :threedim. If :threedim, the map will be displayed as an \
orthographic projection, while :twodim shows the map with a natural earth \
projection.
"""
function GeoGrids.plot_geo_points(points::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Markers for the points
    scatterpoints = _get_scatter_points(points; kwargs_scatter...)

    layout = _get_default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterpoints], layout)
end



function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Fallback method to plot only cell centers
    GeoGrids.plot_geo_points(cellCenters; title, camera, kwargs_scatter, kwargs_layout)
end

function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; title="Cell Layout GEO Map", camera::Symbol=:twodim, circ_res=100, kwargs_centers=(;), kwargs_layout=(;))
    # Create scatter plot for the cells contours.
    scatterContours = _get_scatter_cellcontour(cellCenters, radius; circ_res, kwargs_centers...)
        
    # Create scatter plot for the cell centers.
    k = (; mode="text", text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    scatterCenters = _get_scatter_points(cellCenters; k...)

    # Create layout
    layout = _get_default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterContours, scatterCenters], layout)
end

function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, cellContours::AbstractVector{<:Ngon}; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers=(;), kwargs_contours=(;), kwargs_layout=(;))
    # Create scatter plot for the cells contours.
    scatterContours = _get_scatter_cellcontour(cellContours; kwargs_contours...)
    
    # Create scatter plot for the cell centers.
    k = (; mode="text", text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    scatterCenters = _get_scatter_points(cellCenters; k...)

    # Create layout
    layout = _get_default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterContours, scatterCenters], layout)
end

end # module PlotlyBaseExt