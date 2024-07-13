# @kwdef mutable struct CellsInit
#     "The cell sizing is driven by a specific satellite altitude [m]"
#     satAlt::Float64 = 0.0  
#     "The cell sizing is driven by a minimum elevation [deg]" # //TODO: evaluate the possibility of using the scan too
#     minEl::Float64 = 0.0  
#     "Inclination for the orbital plane of the reference satellite [deg]"
#     satIncl::Float64 = 0.0  
#     "Reference for the satellite antenna beamwidth@boresight [deg]" # //TODO: evaluate if using AntennaSat type for this
#     bwBoresightSat::Float64 = 0.0  
#     "Maximum latitude to be covered with cells [deg]"
#     maxLatCovered::Float64 = 999  
#     "The type of grid to generate the cells can be an icosahedral or grown by latitude [:ico | :leg]"
#     gridType::Symbol  = :ico 
#     "Scan angle for the sizing (related to minEl) [Updated in make_cells] [deg]"
#     satScanAng::Float64 = 0.0  
#     "Antenna BW at the sizing scan angle [Updated in make_cells] [deg]"
#     satAntBW::Float64 = 0.0  
#     "Cell Earth center angle [Updated in make_cells] [deg]"
#     cellEarthAng::Float64 = 0.0  
#     "Flags list to apply cell filtering rules"
#     filterCell::filterCellFlags
# end

# satAlt, minEl
# function make_cells!(cellsInit; em::EllipsoidModel)    
#     ellipsoid = get_ellipsoid(em)

#     ## Earth-Space Geometry ----------------------------------------------------------------------------------
#     ρ = asin(ellipsoid.a ./ (ellipsoid.a + cellsInit.satAlt)) # [rad]
#     η = asin(cosd(cellsInit.minEl)*sin(ρ)) # [rad]
#     λ = π/2 - η + deg2rad(cellsInit.minEl) # [rad]

#     if cellsInit.maxLatCovered == 999
#         if cellsInit.satIncl == 999
#             error("Satellite orbital plane reference inclination or Max LAT to be covered must be specified.")
#         else
#             @warn("maxLatCovered is not specified. Automatically computed based on the other cellsInit paramenters.")
#             cellsInit.maxLatCovered = cellsInit.satIncl + rad2deg(λ)
#         end
#     end

#     # Find earth angle for scan cell at sizing elevation angle
#     scanAng = asin(cosd(cellsInit.minEl)*sin(ρ)); # 5-56b [1]
#     satAntBW = deg2rad(cellsInit.bwBoresightSat)/cos(scanAng); # 1.63 [2] [radians] 
#     # Lambda@(scan+beamScan_radius) - Lambda@scanSizing = Earth_centralAngle for the cell
#     # Half cone angle of the cell at Eart h centre
#     cellEarthAng = (π/2 - acos(sin(scanAng+satAntBW/2)/sin(ρ)) - (scanAng+satAntBW/2)) - (π/2 - acos(sin(scanAng)/sin(ρ)) - (scanAng)) # 5-27 [1] [rad] take in consideration both antenna scan angle distortion and geometrical distortion
#     # //COMMENT: (sphere_surface_area/spherical_cap_area), (4*pi*R^2)/(2*pi*R^2*(1-cos(central_angle))) [https://en.wikipedia.org/wiki/Spherical_cap] a correction factor of 1.2 is considered for cell overlap
#     Ncells = 1.2 * 4π ./ (2π * (1 .- cos.(cellEarthAng))) # approximate number of cells required to cover the are of interest

#     ## Generate cells Centres --------------------------------------------------------------------------------    
#     if cellsInit.gridType == :leg   
#         geoCoord = celldeploy_legacy(Ncells)    
#     else
#         geoCoord = sort(vec(fibonaccigrid(;N=Ncells)), by = x -> x[2]) # Sort cells positions by LAT  
#     end
    
#     cells = map(geoCoord) do p
#         cell_lla = LLA(reverse(p)...) # Default altitude 0.0
#         cell_ecef = get_ecef(cell_lla; ellipsoid) 
#         Cell(position = CellPosition(cell_ecef, cell_lla))
#     end	

#     # Update cellsInit with the sinzing angles
#     # cellsInit can be modified because passed by reference (because it is a mutable struct)
#     cellsInit.satScanAng   = scanAng
#     cellsInit.satAntBW     = satAntBW
#     cellsInit.cellEarthAng = cellEarthAng

#     return cells
# end


# function celldeploy_legacy(N)
#     # //UGLY: improve code, avoid push!() 
#     a = 4π*1^2/N # surface of a cell (spherical cap) on a unit sphere
#     M_Theta = round(π/sqrt(a)) # how many circles are in pi (half circle), total number of circle from 90:-90 //NOTE: maybe you can use something different than sqrt(a) like 2*theta of the spherical cap
#     # M_Theta looks like the squaring of the circle sqrt(a) is the edge of the equiarea square of that circle. So it is like to consider how many edge of the square you can accomodate in -90:90 [https://en.wikipedia.org/wiki/Squaring_the_circle]
#     # d_theta and d_phi are basically the diameter of each cell, represented as the Earth central angle
#     d_theta = π/M_Theta # represent 2*theta of the spherical cap
#     d_phi = a/d_theta # ? it's equal to d_theta
    
#     cellCoord = []
#     for i = 0:M_Theta-1 # from 90 to -90 LAT
#         Theta_ThisTheta = π*(i+0.5)/M_Theta # center of the m-th tier (theta angle from Earth center - spherical cap like) of circles (steps of LAT), you need to normalize on the total number of circle from 90:-90 (M_Theta)
#         M_Phi = round(2π*sin(Theta_ThisTheta)/d_phi) # number of circles for this LAT tier (360, all the LON) - circonference/cell_diameter
#         for j = 0:M_Phi-1
#             Phi_ThisTheta = 2π*j/M_Phi # position of the centers (steps of LON)  
#             # Wrap LON in -180:180
#             Phi_ThisTheta > π ? temp_lon=Phi_ThisTheta-2π : temp_lon=Phi_ThisTheta    
#             push!(cellCoord, SVector(temp_lon, π/2-Theta_ThisTheta)) # lon-lat
#         end
#     end

#     return cellCoord
# end





# function plot_cells_geo(cellTuple...; N=1000, title="Cells Position GEO Map", camera::Symbol=:twodim)
# 	# Check the number of Cells to be plotted, if to high plot only centers, otherwise also the contour
# 	count = 0
# 	for i ∈ eachindex(cellTuple)
# 		count += length(cellTuple[i][1])
# 	end

# 	if count < N 
# 		# //FIX: implement function similar to MATLAB scircle1
# 	else
# 		# Plot only markers for the cell centers
# 		markers = []
# 		for p ∈ eachindex(cellTuple)
# 			push!(markers,
# 				scattergeo(;
# 					lat = map(x -> rad2deg(x.lat), cellTuple[p][1]),
# 					lon = map(x -> rad2deg(x.lon), cellTuple[p][1]),
# 					mode = "markers",
# 					marker_size = 5,
# 					marker_color = cellTuple[p][2]			
# 				)
# 			)
# 		end
# 	end

# 	if camera == :threedim
# 		projection = "orthographic"
# 	else
# 		projection = "natural earth"
# 	end
	
# 	# Create the geo layout
# 	layout = Layout(
# 		geo =  attr(
# 			projection =  attr(
# 			type =  "robinson",
# 			),
# 			showocean =  true,
# 			# oceancolor =  "rgb(0, 255, 255)",
# 			oceancolor =  "rgb(255, 255, 255)",
# 			showland =  true,
# 			# landcolor =  "rgb(230, 145, 56)",
# 			landcolor =  "rgb(217, 217, 217)",
# 			showlakes =  true,
# 			# lakecolor =  "rgb(0, 255, 255)",
# 			lakecolor =  "rgb(255, 255, 255)",
# 			showcountries =  true,
# 			lonaxis =  attr(
# 				showgrid =  true,
# 				gridcolor =  "rgb(102, 102, 102)"
# 			),
# 			lataxis =  attr(
# 				showgrid =  true,
# 				gridcolor =  "rgb(102, 102, 102)"
# 			)
# 		),
# 		title = title;
# 		geo_projection_type = projection
# 	)
	
# 	plotly_plot([markers...],layout)
# end