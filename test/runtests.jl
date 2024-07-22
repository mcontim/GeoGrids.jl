using GeoGrids
using Aqua
using TestItemRunner

Aqua.test_all(GeoGrids; ambiguities = false) 
Aqua.test_ambiguities(GeoGrids)

@run_package_tests

# using SafeTestsets
# @safetestset "General" begin include("general.jl") end
# @safetestset "Filtering Functions" begin include("filtering.jl") end