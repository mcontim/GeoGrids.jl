module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using TelecomUtils

include("filtering_func.jl")
include("plot_func.jl")
include("fibonacci_func.jl")
include("mesh_func.jl")

export Region
export fibonaccigrid, meshgrid, 
extract_countries, in_domain

end # module GeoGrids