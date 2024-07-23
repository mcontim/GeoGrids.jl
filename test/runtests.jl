using GeoGrids
using Aqua
using TestItemRunner

Aqua.test_all(GeoGrids; ambiguities = false) 
Aqua.test_ambiguities(GeoGrids)

@run_package_tests