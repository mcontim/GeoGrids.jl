module GeoGrids

using LinearAlgebra
using StaticArrays
using AngleBetweenVectors
using PlotlyExtensionsHelper

include("filtering.jl")
include("plot_func.jl")
include("fibonacci_func.jl")
include("mesh_func.jl")

export fibonaccigrid, meshgrid

end # module GeoGrids
