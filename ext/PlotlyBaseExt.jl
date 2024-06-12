module PlotlyBaseExt
using PlotlyExtensionsHelper
using PlotlyBase

using GeoGrids
using StaticArrays
using TelecomUtils: ValidAngle, ValidDistance

"""
	plot_unitarysphere(points_cart)

This function takes an SVector{3} of Cartesian coordinates and plots the corresponding points on a unitary sphere. 
The sphere is defined by a range of angles that are discretized into a grid of n_sphere points.

## Arguments:
- `points_cart`: an array of Cartesian coordinates of the points to be plotted on the unitary sphere.
## Output:
- Plot of the unitary sphere with the input points represented as markers.
"""
function GeoGrids.plot_unitarysphere(points_cart)
	# Reference Sphere
	n_sphere = 100
	u = range(-π, π; length = n_sphere)
	v = range(0, π; length = n_sphere)
	x_sphere = cos.(u) * sin.(v)'
	y_sphere = sin.(u) * sin.(v)'
	z_sphere = ones(n_sphere) * cos.(v)'
	color = ones(size(z_sphere))
	sphere = surface(z=z_sphere, x=x_sphere, y=y_sphere, surfacecolor = color, colorbar=false)
	
	# Take an array of SVector
	markers = scatter3d(
		x = map(x -> x[1], points_cart),
		y = map(x -> x[2], points_cart),
		z = map(x -> x[3], points_cart),
		mode = "markers",
		marker_size = 4,
		marker_color = "rgb(0,0,0)",
		)

	layout = Layout(title = "Point on Unitary Sphere")
	
	# Plot([sphere,markers],layout)
	plotly_plot([sphere,markers],layout)
end

"""
	plot_geo(points; title="Point Position 3D Map", camera::Symbol=:twodim)

This function takes an AbstractVector of SVector{2, <:Real} of LAT-LON coordinates (deg) and generates a plot on a world map projection using the PlotlyJS package.

## Arguments
- `points::AbstractVector{SVector{2, <:Real}}:` List of 2-dimensional coordinates (lon,lat) in the form of an AbstractVector of SVector{2, <:Real} elements (LAT=y, LON=x).
- `title::String`: (optional) Title for the plot, default is "Point Position 3D Map".
- `camera::Symbol`: (optional) The camera projection to use, either :twodim (default) or :threedim. If :threedim, the map will be displayed as an orthographic projection, while :twodim shows the map with a natural earth projection.
"""
function GeoGrids.plot_geo(points::Array{Point2}; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))
	# Markers for the points
	# Take an array of SVector
	points = scattergeo(
		lat = map(x -> first(x.coords), points),
		lon = map(x -> last(x.coords), points),
		mode = "markers",
		marker_size = 5,
		kwargs_scatter...
	)

	if camera == :threedim
		projection = "orthographic"
	else
		projection = "natural earth"
	end
	
	# Create the geo layout
	layout = Layout(
		geo =  attr(
			projection =  attr(
			type =  "robinson",
			),
			showocean =  true,
			# oceancolor =  "rgb(0, 255, 255)",
			oceancolor =  "rgb(255, 255, 255)",
			showland =  true,
			# landcolor =  "rgb(230, 145, 56)",
			landcolor =  "rgb(217, 217, 217)",
			showlakes =  true,
			# lakecolor =  "rgb(0, 255, 255)",
			lakecolor =  "rgb(255, 255, 255)",
			showcountries =  true,
			lonaxis =  attr(
				showgrid =  true,
				gridcolor =  "rgb(102, 102, 102)"
			),
			lataxis =  attr(
				showgrid =  true,
				gridcolor =  "rgb(102, 102, 102)"
			)
		),
		title = title;
		geo_projection_type = projection,
		kwargs_layout...
	)
	
	# Plot([points],layout)
	plotly_plot([points],layout)
end

GeoGrids.plot_geo(points; kwargs...) = GeoGrids.plot_geo(_transform_point_plot(points); kwargs...)

"""
    _transform_point_plot(p::Union{AbstractVector, Tuple, LLA})
	_transform_point_plot(p::LLA)
	_transform_point_plot(points::Union{Vector(AbstractVector), Vector{Tuple}, Vector{LLA}})

Transforms a point `p` of different types to a Point2gg.

# Arguments
- `p::Union{AbstractVector, Tuple, LLA}`: A point in 2D space or a latitude-longitude-altitude (LLA) coordinate.

# Returns
- `Point2`: A 2D point with the first and last elements of `p` as its coordinates.
"""
function _transform_point_plot(p::Union{AbstractVector, Tuple}) 
	lat = to_radians(first(p))
    lon = to_radians(last(p))

    # Input validation
    (lat < -π/2 || lat > π/2) && error("LAT provided as numbers must be expressed in radians and satisfy -π/2 ≤ x ≤ π/2. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
    (lon < -π || lon > π) && error("LON provided as numbers must be expressed in radians and satisfy -π ≤ x ≤ π. Consider using `°` from `Unitful` (Also re-exported by GeoGrids) if you want to pass numbers in degrees, by doing `x * °`.")
	
    return Point2(rad2deg(lon), rad2deg(lat))
end
_transform_point_plot(p::LLA) = Point2(rad2deg(p.lat), rad2deg(p.lon))
_transform_point_plot(points::Array{<:Union{AbstractVector,Tuple,LLA}}) = map(x -> _transform_point_plot(x), points)

end