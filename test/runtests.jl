using SafeTestsets
using GeoGrids
using Aqua

# Aqua.test_all(GeoGrids; ambiguities = false) 
# Aqua.test_ambiguities(GeoGrids)
@safetestset "General Tests" begin include("general.jl") end