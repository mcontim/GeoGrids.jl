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
    _cast_geopoint(p::LatLon)

Convert various types of input representations into a `LatLon` object.
This method assumes that the input coordinates are in degrees. It converts the
latitude and longitude from degrees to radians before creating a `LatLon`
object.

## Arguments
- `p::Union{AbstractVector, Tuple}`: A 2D point where the first element is the \
latitude and the second element is the longitude, both in degrees.

## Returns
- `LatLon`: An object representing the geographical point with latitude \
and longitude converted to radians.

## Errors
- Throws an `ArgumentError` if the input `p` does not have exactly two elements.
"""
function _cast_geopoint(p::Union{AbstractVector,Tuple})
    length(p) != 2 && error("The input must be a 2D point...")
    lat = first(p)
    lon = last(p)
    # Inputs are considered in degrees
    return LatLon(lat * °, lon * °)
end
_cast_geopoint(p::LatLon) = p

# Internal functions for creating the scatter plots.
"""
    _get_scatter_points(points::Array{<:Union{LatLon, AbstractVector, Tuple}}; kwargs...) -> PlotlyJS.Plot

This function takes an array of geographic points and generates a scatter plot
using the `scattergeo` function from the PlotlyJS package. The points are
converted to a vector of `LatLon` objects if they are not already. The
latitude and longitude of each point are extracted and used to create the
scatter plot.

## Arguments
- `points::Array{<:Union{LatLon, AbstractVector, Tuple}}`: An array of \
points that can be of type `LatLon`, `AbstractVector`, or `Tuple`. Each \
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
function _get_scatter_points(points::Array{<:Union{LatLon,AbstractVector,Tuple}}; kwargs...)
    # Markers for the points
    vec_p = map(x -> _cast_geopoint(x), points[:]) # Convert in a vector of LatLon

    return scattergeo(;
        lat=map(x -> x.lat, vec_p), # Vectorize such to be sure to avoid matrices.
        lon=map(x -> x.lon, vec_p), # Vectorize such to be sure to avoid matrices.
        defaultScatterPoints...,
        kwargs...
    )
end

"""
    _get_scatter_cellcontour(polygons::AbstractVector{<:AbstractVector{<:LatLon}}; kwargs...)

This function creates a geographic scatter plot of cell contours based on the
input polygons. Each polygon is processed to extract its vertices' latitude and
longitude, which are then used to plot the contours on a geographic map.

## Arguments
- `polygons::AbstractVector{<:AbstractVector{<:LatLon}}`: A vector of \
polygons, where each polygon is represented by a vector of `LatLon` \
objects. Each `LatLon` object holds latitude and longitude information.

## Keyword Arguments
- `kwargs...`: Additional keyword arguments to customize the scatter plot. These \
are passed directly to the `scattergeo` function, allowing customization of \
the plot's appearance (e.g., color, line style, marker options).

## Returns
- A `scattergeo` plot object: The scatter plot visualization of the cell \
contours, ready for rendering in a geographic plot.
"""
function _get_scatter_cellcontour(polygons::AbstractVector{<:AbstractVector{<:LatLon}}; kwargs...)
    # Extract scatter plot from mesh.
    polygonsTrace = []
    for ngon in polygons
        thisNgon = map(ngon) do vertex # Loop through vertices to create the hexagon for plotting
            (ustrip(vertex.lat), ustrip(vertex.lon))
        end
        push!(polygonsTrace, [thisNgon..., (NaN, NaN)]...)
    end

    return scattergeo(;
        lat=map(x -> first(x), polygonsTrace),
        lon=map(x -> last(x), polygonsTrace),
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
    plot_geo_points(points::Array{<:Union{LatLon, AbstractVector, Tuple}}; title::String="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter::NamedTuple=(); kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot

This function generates a geographic plot for a given array of points. It
creates a scatter plot of the points using `_get_scatter_points` and sets up the
layout with `_default_geolayout`. The plot is created using the
`plotly_plot` function from PlotlyJS.

## Arguments
- `points::Array{<:Union{LatLon, AbstractVector, Tuple}}`: An array of \
points to be plotted. Each point can be of type `LatLon`, \
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
function GeoGrids.plot_geo_points(points::Array{<:Union{LatLon,AbstractVector,Tuple}}; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Markers for the points
    scatterpoints = _get_scatter_points(points; kwargs_scatter...)

    layout = _default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterpoints], layout)
end
GeoGrids.plot_geo_points(point::Union{LatLon,AbstractVector,Tuple}; kwargs...) = GeoGrids.plot_geo_points([point]; kwargs...)

"""
    plot_geo_cells(cellCenters::Array{<:Union{LatLon, AbstractVector, Tuple}}; title::String="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter::NamedTuple=(), kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot
    plot_geo_cells(cellCenters::Array{<:Union{LatLon, AbstractVector, Tuple}}, cellContours::AbstractVector{<:AbstractVector{<:LatLon}}; title::String="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers::NamedTuple=(), kwargs_contours::NamedTuple=(), kwargs_layout::NamedTuple=()) -> PlotlyJS.Plot

This function generates geographic plots for cell layouts with three methods:
1. Plotting only the cell centers.
3. Plotting the cell centers along with polygonal contours.

# Method 1: Plot Cell Centers Only
## Arguments
- `cellCenters::Array{<:Union{LatLon, AbstractVector, Tuple}}`: An array \
of points representing the centers of cells. Each point can be of type \
`LatLon`, `AbstractVector`, or `Tuple`.
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

# Method 3: Plot Cell Centers with Polygonal Contours
## Arguments
- `cellCenters::Array{<:Union{LatLon, AbstractVector, Tuple}}`: An array \
of points representing the centers of cells. Each point can be of type \
`LatLon`, `AbstractVector`, or `Tuple`.
- `cellContours::AbstractVector{<:AbstractVector{<:LatLon}}`: An array of `Ngon` objects \
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
function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{LatLon,AbstractVector,Tuple}}; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers=(;), kwargs_layout=(;))
    # Fallback method to plot only cell centers
    k = (; defaultScatterCellCenters..., text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    GeoGrids.plot_geo_points(cellCenters; title, camera, kwargs_scatter=k, kwargs_layout)
end
GeoGrids.plot_geo_cells(cellCenter::Union{LatLon,AbstractVector,Tuple}; kwargs...) = GeoGrids.plot_geo_points([cellCenter]; kwargs...)

function GeoGrids.plot_geo_cells(cellCenters::Array{<:Union{LatLon,AbstractVector,Tuple}}, cellContours::AbstractVector{<:AbstractVector{<:LatLon}}; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_centers=(;), kwargs_contours=(;), kwargs_layout=(;))
    # Create scatter plot for the cells contours.
    scatterContours = _get_scatter_cellcontour(cellContours; kwargs_contours...)

    # Create scatter plot for the cell centers.
    k = (; defaultScatterCellCenters..., text=map(x -> string(x), 1:length(cellCenters)), kwargs_centers...) # Default for text mode for cellCenters
    scatterCenters = _get_scatter_points(cellCenters; k...)

    # Create layout
    layout = _default_geolayout(; title, camera, kwargs_layout...)

    plotly_plot([scatterContours, scatterCenters], layout)
end
GeoGrids.plot_geo_cells(cellCenter::Union{LatLon,AbstractVector,Tuple}, cellContour::AbstractVector{<:LatLon}; kwargs...) = GeoGrids.plot_geo_cells([cellCenter], [cellContour]; kwargs...)

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