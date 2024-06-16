using SafeTestsets
using GeoGrids
using Aqua

# Aqua.test_all(GeoGrids; ambiguities = false) 
# Aqua.test_ambiguities(GeoGrids)
# @safetestset "General" begin include("general.jl") end
@safetestset "Filtering Functions" begin include("filtering.jl") end