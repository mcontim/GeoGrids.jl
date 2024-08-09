module GeoGrids

using AngleBetweenVectors
using CoordRefSystems
using CountriesBorders
using Dictionaries
using LinearAlgebra
using Meshes
using PlotlyExtensionsHelper
using StaticArrays
using Unitful: °, rad, Quantity, @u_str, ustrip

include("typedef.jl")
include("helper_func.jl")
include("filtering_func.jl")
include("plot_func.jl")
include("ico_func.jl")
include("rect_func.jl")
include("tessellation_func.jl")

export AbstractRegion, GlobalRegion, GeoRegion, PolyRegion, LatBeltRegion, 
UnitfulAngleType, UnitfulAngleQuantity, ValidAngle,
AbstractTiling, ICO, HEX, H3,
ExtraOutput

export icogrid, rectgrid, vecgrid,
extract_countries, in, filter_points, group_by_domain,
gen_hex_lattice, generate_tesselation, my_tesselate, my_tesselate_circle, my_tesselate_hexagon

export °, rad, SimpleLatLon, PolyArea, SVector

end # module GeoGrids 