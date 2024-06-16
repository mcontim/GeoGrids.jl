module GeoGrids

using AngleBetweenVectors
using CountriesBorders
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using TelecomUtils
using TelecomUtils: ValidAngle, ValidDistance, _check_angle

include("typedef.jl")
include("helper_func.jl")
include("filtering_func.jl")
include("plot_func.jl")
include("ico_func.jl")
include("mesh_func.jl")

export GeoRegion, PolyRegion, LatBeltRegion

export icogrid, meshgrid, 
extract_countries, in_region, filter_points

export °, LLA,
Point2, PolyArea,
SVector

end # module GeoGrids