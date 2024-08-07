module PlotlyBaseExt

using PlotlyExtensionsHelper
using PlotlyBase
using Unitful: ustrip
using Meshes: Ngon

using GeoGrids

const defaultScatterCellContour = (;
    mode="lines",
    marker=attr(;
        size=1,
        color="rgb(92,97,102)",
    ),
    name="Cell Contour",
    showlegend=false
)

const defaultScatterCellCenters = (;
    mode="text", 
    textfont=attr(; size=10), 
    name="Cell Number",
    showlegend=false
)

const defaultScatterPoints = (;
    mode="markers",
    marker_size=5,
)

const defaultLayoutGeo = (;
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
    )
)

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

# Internal functions for creating the scatter plots.
"""
    _get_scatter_points(points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}; kwargs...) -> PlotlyJS.Plot

This function takes an array of geographic points and generates a scatter plot
using the `scattergeo` function from the PlotlyJS package. The points are
converted to a vector of `SimpleLatLon` objects if they are not already. The
latitude and longitude of each point are extracted and used to create the
scatter plot.

## Arguments
- `points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array of \
points that can be of type `SimpleLatLon`, `AbstractVector`, or `Tuple`. Each \
point represents a geographic location.

## Keyword Arguments
- `kwargs`: Additional keyword arguments to customize the `scattergeo` plot. \
These arguments are passed directly to the `scattergeo` function from \
PlotlyJS.

## Returns
- A `PlotlyJS.Plot` object representing the scatter plot of the provided \
geographic points.

See also: [`_cast_geopoint`](@ref)
"""
function _get_scatter_points(points::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}; kwargs...)
    # Markers for the points
    vec_p = map(x -> _cast_geopoint(x), points[:]) # Convert in a vector of SimpleLatLon

    return scattergeo(;
        lat=map(x -> x.lat, vec_p), # Vectorize such to be sure to avoid matrices.
        lon=map(x -> x.lon, vec_p), # Vectorize such to be sure to avoid matrices.
        defaultScatterPoints...,
        kwargs...
    )
end

"""
    _get_scatter_cellcontour(cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}, radius::Number; circ_res=100, kwargs...) -> PlotlyJS.Plot
    _get_scatter_cellcontour(mesh::AbstractVector{<:Ngon}; kwargs...) -> PlotlyJS.Plot

This function has two methods for generating scatter plots:
1. For circular cell contours: Takes an array of cell centers and a radius to \
generate circular contours around each center.
2. For polygonal meshes: Takes a mesh of `Ngon` objects and generates a scatter \
plot of the mesh polygons.

# Method 1
## Arguments
- `cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array \
of points representing the centers of cells. Each point can be of type \
`SimpleLatLon`, `AbstractVector`, or `Tuple`.
- `radius::Number`: The radius of the circular cell contours.
- `circ_res::Integer=100`: (Optional) The number of points used to approximate \
the circle. Defaults to 100.
- `kwargs`: Additional keyword arguments to customize the `scattergeo` plot. \
These arguments are passed directly to the `scattergeo` function from \
PlotlyJS.

## Returns
- A `PlotlyJS.Plot` object representing the scatter plot of the circular cell \
contours.

# Method 2
## Arguments
- `mesh::AbstractVector{<:Ngon}`: An array of `Ngon` objects representing a \
polygonal mesh. Each `Ngon` object should have vertices with `coords.x` and \
`coords.y` attributes.
- `kwargs`: Additional keyword arguments to customize the `scattergeo` plot. \
These arguments are passed directly to the `scattergeo` function from \
PlotlyJS.

## Returns
- A `PlotlyJS.Plot` object representing the scatter plot of the polygonal mesh.

See also: [`_cast_geopoint`](@ref), [`_gen_circle`](@ref)
"""
function _get_scatter_cellcontour(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; circ_res=100, kwargs...)
    vec_c = map(x -> _cast_geopoint(x), cellCenters[:]) # Convert in a vector of SimpleLatLon

    circ_vec = GeoGrids.circle_tessellation(vec_c, radius; earth_local_radius=GeoGrids.constants.Re_mean, n=circ_res)

    lat=[]
    lon=[]
    for c in circ_vec
        map(x -> push!(lat, x.lat), c)
        map(x -> push!(lon, x.lon), c)
        push!(lat, NaN)
        push!(lon, NaN)
    end

    # Markers for the points
    return scattergeo(;
        lat=lat, # Vectorize such to be sure to avoid matrices.
        lon=lon, # Vectorize such to be sure to avoid matrices.
        defaultScatterCellContour...,
        kwargs...
    )
end

function _get_scatter_cellcontour(mesh::AbstractVector{<:Ngon}; kwargs...)
    # Extract scatter plot from mesh.
    meshTrace = []
    for poly in mesh
        thisNgon = map([poly.vertices..., poly.vertices[1]]) do vertex # Loop through vertices to create the hexagon for plotting
            (ustrip(vertex.coords.x), ustrip(vertex.coords.y))
        end
        push!(meshTrace, [thisNgon..., (NaN, NaN)]...)
    end

    return scattergeo(;
        lat=map(x -> last(x), meshTrace),
        lon=map(x -> first(x), meshTrace),
        defaultScatterCellContour...,
        kwargs...
    )
end

"""
    _default_geolayout(; title::String="Point Position GEO Map", camera::Symbol=:twodim, kwargs...) -> PlotlyJS.Layout

This function generates a default geographic layout for a PlotlyJS plot. It sets
up the layout with a geographic projection, ocean and land colors, and grid
lines for latitude and longitude. The projection type is chosen based on the
camera perspective: "orthographic" for 3D and "natural earth" for 2D.

## Keyword Arguments
- `title::String="Point Position GEO Map"`: The title of the plot. Defaults to \
"Point Position GEO Map".
- `camera::Symbol=:twodim`: The camera perspective of the plot. Can be `:twodim` \
for a 2D view or `:threedim` for a 3D view.
- `kwargs`: Additional keyword arguments to customize the layout further. These \
arguments are passed directly to the `Layout` constructor.

## Returns
- A `PlotlyJS.Layout` object representing the default geographic layout with the \
specified options.
"""
function _default_geolayout(; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs...)
    projection = camera == :threedim ? "orthographic" : "natural earth"

    # Create the geo layout
    return Layout(;
        defaultLayoutGeo...,
        title=title,
        geo_projection_type=projection,
        kwargs...
    )
end

## Core plotting functions.
"""
    plot_geo_points(points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}; title::String="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter::NamedTuple=(); kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot

This function generates a geographic plot for a given array of points. It
creates a scatter plot of the points using `_get_scatter_points` and sets up the
layout with `_default_geolayout`. The plot is created using the
`plotly_plot` function from PlotlyJS.

## Arguments
- `points::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array of \
points to be plotted. Each point can be of type `SimpleLatLon`, \
`AbstractVector`, or `Tuple` containing latitude and longitude.

## Keyword Arguments
- `title::String="Point Position GEO Map"`: The title of the plot. Defaults to \
"Point Position GEO Map".
- `camera::Symbol=:twodim`: The camera perspective of the plot. Can be `:twodim` \
for a 2D view or other supported camera views.
- `kwargs_scatter::NamedTuple=()` : Additional keyword arguments for customizing \
the scatter plot. These arguments are passed directly to the \
`_get_scatter_points` function.
- `kwargs_layout::NamedTuple=()` : Additional keyword arguments for customizing \
the plot layout. These arguments are passed directly to the \
`_default_geolayout` function.

## Returns
- A `PlotlyJS.Plot` object representing the geographic plot of the provided \
points.

See also: [`_get_scatter_points`](@ref), [`_default_geolayout`](@ref),
[`plot_geo_cells`](@ref)
"""
function GeoGrids.plot_geo_points(points::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Markers for the points
    scatterpoints = _get_scatter_points(points; kwargs_scatter...)

    layout = _default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterpoints], layout)
end

"""
    plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}; title::String="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter::NamedTuple=(), kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot
    plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}, radius::Number; title::String="Cell Layout GEO Map", camera::Symbol=:twodim, circ_res::Integer=100, kwargs_centers::NamedTuple=(), kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot
    plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}, cellContours::AbstractVector{<:Ngon}; title::String="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers::NamedTuple=(), kwargs_contours::NamedTuple=(), kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot

This function generates geographic plots for cell layouts with three methods:
1. Plotting only the cell centers.
2. Plotting the cell centers along with circular contours.
3. Plotting the cell centers along with polygonal contours.

# Method 1: Plot Cell Centers Only
## Arguments
- `cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array \
of points representing the centers of cells. Each point can be of type \
`SimpleLatLon`, `AbstractVector`, or `Tuple`.
- `title::String="Cell Layout GEO Map"`: The title of the plot. Defaults to \
"Cell Layout GEO Map".
- `camera::Symbol=:twodim`: The camera perspective of the plot. Can be `:twodim` \
for a 2D view or other supported camera views.
- `kwargs_scatter::NamedTuple=()` : Additional keyword arguments for customizing \
the scatter plot. These arguments are passed directly to the \
`GeoGrids.plot_geo_points` function.
- `kwargs_layout::NamedTuple=()` : Additional keyword arguments for customizing \
the plot layout. These arguments are passed directly to the \
`GeoGrids.plot_geo_points` function.

## Returns
- A `PlotlyJS.Plot` object representing the geographic plot of the cell centers.

# Method 2: Plot Cell Centers with Circular Contours
## Arguments
- `cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array \
of points representing the centers of cells. Each point can be of type \
`SimpleLatLon`, `AbstractVector`, or `Tuple`.
- `radius::Number`: The radius of the circular cell contours.
- `title::String="Cell Layout GEO Map"`: The title of the plot. Defaults to \
"Cell Layout GEO Map".
- `camera::Symbol=:twodim`: The camera perspective of the plot. Can be `:twodim` \
for a 2D view or other supported camera views.
- `circ_res::Integer=100`: (Optional) The number of points used to approximate \
the circle. Defaults to 100.
- `kwargs_centers::NamedTuple=()` : Additional keyword arguments for customizing \
the scatter plot of cell centers. These arguments are passed directly to the \
`_get_scatter_points` function.
- `kwargs_layout::NamedTuple=()` : Additional keyword arguments for customizing \
the plot layout. These arguments are passed directly to the \
`_default_geolayout` function.

## Returns
- A `PlotlyJS.Plot` object representing the geographic plot of the cell centers \
and their circular contours.

# Method 3: Plot Cell Centers with Polygonal Contours
## Arguments
- `cellCenters::Array{<:Union{SimpleLatLon, AbstractVector, Tuple}}`: An array \
of points representing the centers of cells. Each point can be of type \
`SimpleLatLon`, `AbstractVector`, or `Tuple`.
- `cellContours::AbstractVector{<:Ngon}`: An array of `Ngon` objects \
representing the contours of the cells.
- `title::String="Cell Layout GEO Map"`: The title of the plot. Defaults to \
"Cell Layout GEO Map".
- `camera::Symbol=:twodim`: The camera perspective of the plot. Can be `:twodim` \
for a 2D view or other supported camera views.
- `kwargs_centers::NamedTuple=()` : Additional keyword arguments for customizing \
the scatter plot of cell centers. These arguments are passed directly to the \
`_get_scatter_points` function.
- `kwargs_contours::NamedTuple=()` : Additional keyword arguments for \
customizing the scatter plot of cell contours. These arguments are passed \
directly to the `_get_scatter_cellcontour` function.
- `kwargs_layout::NamedTuple=()` : Additional keyword arguments for customizing \
the plot layout. These arguments are passed directly to the \
`_default_geolayout` function.

## Returns
- A `PlotlyJS.Plot` object representing the geographic plot of the cell centers \
and their polygonal contours.

See also: [`_get_scatter_points`](@ref), [`_get_scatter_cellcontour`](@ref),
[`_default_geolayout`](@ref), [`plot_geo_points`](@ref)
"""
function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers=(;), kwargs_layout=(;))
    # Fallback method to plot only cell centers
    k = (; defaultScatterCellCenters..., text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    GeoGrids.plot_geo_points(cellCenters; title, camera, kwargs_scatter=k, kwargs_layout)
end

function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, cellContours::AbstractVector{<:Ngon}; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers=(;), kwargs_contours=(;), kwargs_layout=(;))
    # Create scatter plot for the cells contours.
    scatterContours = _get_scatter_cellcontour(cellContours; kwargs_contours...)

    # Create scatter plot for the cell centers.
    k = (; defaultScatterCellCenters..., text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    scatterCenters = _get_scatter_points(cellCenters; k...)

    # Create layout
    layout = _default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterContours, scatterCenters], layout)
end

function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers=(;), kwargs_contours=(;), kwargs_layout=(;))
    # Create scatter plot for the cells contours.
    scatterContours = _get_scatter_cellcontour(cellCenters, radius; kwargs_contours...)

    # Create scatter plot for the cell centers.
    k = (; defaultScatterCellCenters..., text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    scatterCenters = _get_scatter_points(cellCenters; k...)

    # Create layout
    layout = _default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterContours, scatterCenters], layout)
end

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

end # module PlotlyBaseExt