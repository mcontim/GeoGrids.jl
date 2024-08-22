module GeoGrids

using AngleBetweenVectors
using Clipper
using CoordRefSystems
using CoordRefSystems: Deg
using CountriesBorders
using CountriesBorders.GeoTablesConversion: LATLON, CART, POLY_LATLON, POLY_CART, cartesian_geometry
using Dictionaries
using LinearAlgebra
using Meshes
using Meshes: 🌐, WGS84Latest, coords
using PlotlyExtensionsHelper
using StaticArrays
using Unitful: °, rad, Quantity, @u_str, ustrip

include("basic_types.jl")
include("poly_offsetting.jl")
include("helper_func.jl")
include("interface_func.jl")
include("ico_func.jl")
include("rect_func.jl")
include("filtering_func.jl")
include("tessellation_func.jl")
include("plot_func.jl")

export AbstractRegion, GlobalRegion, GeoRegion, PolyRegion, LatBeltRegion,
    AbstractTiling, ICO, HEX, H3
# UnitfulAngleType, UnitfulAngleQuantity, ValidAngle,

export icogrid, rectgrid, vecgrid,
    extract_countries, filter_points, group_by_domain,
    gen_hex_lattice, generate_tesselation, _tesselate, gen_circle_pattern, gen_hex_pattern,
    borders, centroid, in, get_lat, get_lon,
    EO

export °, rad, ustrip,
    LatLon, Cartesian, WGS84Latest, coords, PolyArea, Point,
    SVector

end # module GeoGrids 