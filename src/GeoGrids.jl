module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using TelecomUtils
using TelecomUtils: _check_angle, ValidAngle, ValidDistance

include("filtering_func.jl")
include("plot_func.jl")
include("fibonacci_func.jl")
include("mesh_func.jl")

export GeoRegion, PolyRegion

export fibonaccigrid, meshgrid, 
extract_countries, in_domain

export °, LLA

end # module GeoGrids