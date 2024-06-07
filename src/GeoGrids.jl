module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using TelecomUtils
using TelecomUtils: ValidAngle, ValidDistance

include("helper_func.jl")
include("typedef.jl")
include("filtering_func.jl")
include("plot_func.jl")
include("fibonacci_func.jl")
include("mesh_func.jl")

export GeoRegion, PolyRegion

export fibonaccigrid, meshgrid_geo, 
extract_countries, in_region, filter_points

export °, LLA

end # module GeoGrids