module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using Dictionaries
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using Unitful: °, rad, Quantity

include("typedef.jl")
include("helper_func.jl")
include("filtering_func.jl")
include("plot_func.jl")
include("ico_func.jl")
include("mesh_func.jl")

export AbstractRegion, GeoRegion, PolyRegion, LatBeltRegion

export icogrid, meshgrid, vecgrid,
extract_countries, in, filter_points, group_by_domain

export °, rad, SimpleLatLon, PolyArea

end # module GeoGrids