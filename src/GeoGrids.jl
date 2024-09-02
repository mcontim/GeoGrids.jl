module GeoGrids

using AngleBetweenVectors
using Clipper
using CoordRefSystems
using CoordRefSystems: Deg
using CountriesBorders
using CountriesBorders.GeoTablesConversion: LATLON, CART, POLY_LATLON, POLY_CART, MULTI_LATLON, MULTI_CART, RING_LATLON, RING_CART
using Dictionaries
using LinearAlgebra
using Meshes
using Meshes: 🌐, WGS84Latest, coords
using PlotlyExtensionsHelper
using StaticArrays
using Unitful: °, rad, Quantity, Length, @u_str, ustrip

include("basic_types.jl")
include("enlarged_types.jl")
include("interface_func.jl")
include("helper_func.jl")
include("offsetting_func.jl")
include("ico_func.jl")
include("rect_func.jl")
include("filtering_func.jl")
include("tessellation_func.jl")
include("plot_func.jl")

export AbstractRegion, GlobalRegion, GeoRegion, PolyRegion, LatBeltRegion,
    GeoRegionEnlarged, PolyRegionEnlarged,
    MultiBorder, PolyBorder,
    AbstractTiling, ICO, HEX, H3,
    EO
    # UnitfulAngleType, UnitfulAngleQuantity, ValidAngle,
    
export icogrid, rectgrid, vecgrid,
    extract_countries, filter_points, group_by_domain,
    gen_hex_lattice, generate_tesselation, _tesselate, gen_circle_pattern, gen_hex_pattern,
    borders, centroid, in, get_lat, get_lon, latlon_geometry, cartesian_geometry,
    offset_region

export °, rad, ustrip,
    LatLon, Cartesian, WGS84Latest, coords, PolyArea, Point,
    SVector

end # module GeoGrids 

# //TODO:
# [x] Add tests for enlarged types and offsetting functions.
# [x] Add tests for plotting functions for enlarged regions.
# [x] Add documetnation on README for region enlargement.
# [] Add filtering and grouping functions for enlarged regions.
# [] Merge PR.
# [] Add ValidDistance support (Issue)
# [] Version bump to 0.5.0