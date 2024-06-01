module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using LinearAlgebra
using PlotlyExtensionsHelper
using StaticArrays

include("filtering.jl")
include("plot_func.jl")
include("fibonacci_func.jl")
include("mesh_func.jl")

export fibonaccigrid, meshgrid, extract_countries

end # module GeoGrids
