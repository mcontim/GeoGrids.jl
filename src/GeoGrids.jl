module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using Dictionaries
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using Unitful: °, rad, Quantity, @u_str

include("typedef.jl")
include("helper_func.jl")
include("filtering_func.jl")
include("plot_func.jl")
include("ico_func.jl")
include("rect_func.jl")
include("tessellation_func.jl")

export AbstractRegion, GeoRegion, PolyRegion, LatBeltRegion

export icogrid, rectgrid, vecgrid,
extract_countries, in, filter_points, group_by_domain

export °, rad, SimpleLatLon, PolyArea, SVector

end # module GeoGrids