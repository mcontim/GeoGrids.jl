module GeoGrids

using LinearAlgebra
using StaticArrays
using AngleBetweenVectors
using PlotlyBase

include("../code/aux_func.jl")
include("../code/fibonacci_func.jl")
include("../code/mesh_func.jl")

export fibonaccigrid, meshgrid

end # module GeoGrids
