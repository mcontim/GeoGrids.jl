# GeoGrids.jl

[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tec-esc-tools.io.esa.int/GeoGrids.jl/stable)
[![Docs Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tec-esc-tools.io.esa.int/GeoGrids.jl/dev)
[![Build Status](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/badges/main/pipeline.svg)](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/pipelines)
[![Coverage](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/badges/main/coverage.svg)](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/commits/main)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

This is a package containing functions for Geographical Grids generation for example for terminals distribution for System Level Simulations. **In the next version support for Geo Surface tesselation for cell grid layout will be supported**.

## Exported Functions

    icogrid_geo(;N=nothing, sepAng=nothing, unit=:rad, height=nothing, type=:lla)

This function returns a `Vector` of `Point2` or `LLA` elements, for a `N` points Global grid built with the **Fibonacci Spiral** method.

The grid can be generated starting fom the number of point requested on the grid (`N`) or by the minimum separation angle requested for the points (`sepAng`).


The problem of how to evenly distribute points on a sphere has a very long history. Unfortunately, except for a small handful of cases, it still has not been exactly solved. Therefore, in nearly all situations, we can merely hope to find near-optimal solutions to this problem.

Of these near-optimal solutions, one of the most common simple methods is one based on the **Fibonacci lattice** or **Golden Spiral** or **Fibonacci Spiral**. Furthermore, unlike many of the other iterative or randomised methods such a simulated annealing, the Fibonacci spiral is one of the few direct construction methods that works for arbitrary `N`.

This method of points distribution is **Area Preserving** but not distance preserving.

As convention it has been considered: `LAT=y`, `LON=x`. The output can be returned either in `:deg` or `:rad` units.

---

	meshgrid_geo(gridRes; unit = :rad)

This function creates a 2D Global grid of coordinates with the specified resolution (`gridRes`) given as input and return the `LAT`, `LON` meshgrid_geo similar to the namesake MATLAB function.

As convention it has been considered: `LAT=y`, `LON=x`.

The output is returned in the form of a vector of SVector{2}(lon,lat) (`vec`) and a tuple of two 2D grids (`grid`). The output can be returned either in `:deg` or `:rad` units.


    meshgrid(xin,yin)

Create a 2D grid of coordinates using the input vectors `xin` and `yin`.
The outputs in the form of `SVector(xout,yout)` and `grid=(xout,yout)` contain all possible combinations of the elements of `xin` and `yin`, with `xout` corresponding to the horizontal coordinates and `yout` corresponding to the vertical coordinates.

---

    icogrid(N::Int)
	
This function generates `N` uniformly distributed points on the surface of a unitary sphere using the classic Fibonacci Spiral

---

icogrid_geo, icogrid, meshgrid_geo, meshgrid, 
extract_countries, in_region, filter_points

## Useful Internal Functions

    plot_geo(points_latlon; title="Point Position 3D Map", camera::Symbol=:twodim)

This function takes an AbstractVector of SVector{2, <:Real} of LAT-LON coordinates (deg) and generates a plot on a world map projection using the PlotlyJS package.
