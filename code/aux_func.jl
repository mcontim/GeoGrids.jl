function plot_geo_2D(points_latlon)
	# Markers for the points
	# Take an array of SVector
	points = scattergeo(
		lat = map(x -> x[1], points_latlon),
		lon = map(x -> x[2], points_latlon),
		mode = "markers",
		marker_size = 5
	)
	
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
		title = "Point Position 2D Map"
	)
	
	plot([points],layout)
end

function plot_geo_3D(points_latlon)
	# Markers for the points
	# Take an array of SVector
	points = scattergeo(
		lat = map(x -> x[1], points_latlon),
		lon = map(x -> x[2], points_latlon),
		mode = "markers",
		marker_size = 5
	)
	
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
		title = "Point Position 3D Map";
		geo_projection_type = "orthographic"
	)
	
	plot([points],layout)
end

function plot_unitarysphere(points_cart)
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
	
	plot([sphere,markers],layout)
end

function plot_geo(points_latlon; title="Point Position 3D Map", camera::Symbol=:twodim)
	# Markers for the points
	# Take an array of SVector
	points = scattergeo(
		lat = map(x -> x[1], points_latlon),
		lon = map(x -> x[2], points_latlon),
		mode = "markers",
		marker_size = 5
	)
	
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
		if camera == :threedim
			geo_projection_type = "orthographic"
		end
	)
	
	plot([points],layout)
end