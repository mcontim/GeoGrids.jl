module PlotlyBaseExt

using PlotlyExtensionsHelper
using PlotlyBase

using GeoGrids

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

function _get_scatter_points(points::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}; kwargs...)
    # Markers for the points
    vec_p = map(x -> GeoGrids._cast_geopoint(x), points[:]) # Convert in a vector of SimpleLatLon
    scatterpoints = scattergeo(
        lat=map(x -> x.lat, vec_p), # Vectorize such to be sure to avoid matrices.
        lon=map(x -> x.lon, vec_p), # Vectorize such to be sure to avoid matrices.
        mode="markers",
        marker_size=5,
        kwargs...
    )

    return scatterpoints
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

    if camera == :threedim
        projection = "orthographic"
    else
        projection = "natural earth"
    end

    # Create the geo layout
    layout = Layout(
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
        kwargs_layout...
    )

    plotly_plot([scatterpoints], layout)
end

function _get_scatter_cells(cellCenter::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number, type::Symbol=:hex; hex_direction::Symbol=:pointy, circ_res=100,kwargs...)
    cellCenter = map(x -> GeoGrids._cast_geopoint(x), cellCenter[:]) # Convert in a vector of SimpleLatLon
    x_plot = [] # deg
	y_plot = [] # deg
	for c in cellCenter
        points = if type == :hex
            GeoGrids._gen_hex_vertices(c, radius; direction=hex_direction)
        elseif type == :circ
            GeoGrids._gen_circle(c, radius; n=circ_res)
        else
            error("Unrecognised type for cell shape, only :hex or :circ are supported...")
        end
		push!(x_plot, [first.(points)..., NaN]...)
		push!(y_plot, [last.(points)..., NaN]...)
	end
	
    # Markers for the points
    scatterpoints = scattergeo(
        lat = y_plot, # Vectorize such to be sure to avoid matrices.
        lon = x_plot, # Vectorize such to be sure to avoid matrices.
        mode = "lines",
        marker_size = 1,
        kwargs...
    )

    return scatterpoints
end

function GeoGrids.plot_geo_cells(cellCenter::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Fallback method to plot only cell centers
    GeoGrids.plot_geo_points(cellCenter; title, camera, kwargs_scatter, kwargs_layout)
end

function GeoGrids.plot_geo_cells(cellCenter::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius::Number; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Plot with circles
end

function GeoGrids.plot_geo_cells(cellCenter::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, mesh::AbstractVector{<:Ngon}; title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Plot with hex mesh

# let
# 	traces = []
# 	vertex = mesh2.vertices
# 	polygons = mesh2.topology.connec[idx_sel]
# 	for poly in polygons
# 		for idx in poly.indices
# 			v = vertex[idx]
# 			push!(traces, (ustrip(v.coords.x), ustrip(v.coords.y)))
# 		end
# 		push!(traces, (ustrip(vertex[poly.indices[1]].coords.x), ustrip(vertex[poly.indices[1]].coords.y))) # add first vertex
# 		push!(traces, (NaN,NaN))
# 	end

# 	plot(scattergeo(
# 		lat = map(x -> last(x), traces),
# 		lon = map(x -> first(x), traces),
# 		mode = "lines",
# 		marker_size = 1,
# 	))
# end
end

function GeoGrids.plot_geo_cells(cellCenter::Array{<:Union{SimpleLatLon,AbstractVector,Tuple}}, radius, type::Symbol=:hex; hex_direction=:pointy, title="Cell Layout GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
    # Markers for the points
    scatterpoints = _get_scatter_cells(cellCenter, radius, type; hex_direction, kwargs_scatter...)

    if camera == :threedim
        projection = "orthographic"
    else
        projection = "natural earth"
    end

    # Create the geo layout
    layout = Layout(
        geo=attr(
            # projection=attr(
            #     type="robinson",
            # ),
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
        kwargs_layout...
    )

    plotly_plot([scatterpoints], layout)
end

end # module PlotlyBaseExt