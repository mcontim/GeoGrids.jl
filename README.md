# GeoGrids.jl

[![Docs Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tec-esc-tools.io.esa.int/GeoGrids.jl/stable)
[![Docs Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tec-esc-tools.io.esa.int/GeoGrids.jl/dev)
[![Build Status](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/badges/main/pipeline.svg)](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/pipelines)
[![Coverage](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/badges/main/coverage.svg)](https://gitlab.esa.int/tec-esc-tools/GeoGrids.jl/commits/main)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

This is a package containing functions for Geographical Grids generation for example for terminals distribution for System Level Simulations. **In the next version support for Geo Surface tesselation for cell grid layout will be supported**.

## Exported Functions

    icogrid(;N=nothing, sepAng=nothing, unit=:rad, height=nothing, type=:lla)

This function returns a `Vector` of `Point2` or `LLA` elements, for a `N` points Global grid built with the **Fibonacci Spiral** method.

The grid can be generated starting fom the number of point requested on the grid (`N`) or by the minimum separation angle requested for the points (`sepAng`).

The problem of how to evenly distribute points on a sphere has a very long history. Unfortunately, except for a small handful of cases, it still has not been exactly solved. Therefore, in nearly all situations, we can merely hope to find near-optimal solutions to this problem.

Of these near-optimal solutions, one of the most common simple methods is one based on the **Fibonacci lattice** or **Golden Spiral** or **Fibonacci Spiral**. Furthermore, unlike many of the other iterative or randomised methods such a simulated annealing, the Fibonacci spiral is one of the few direct construction methods that works for arbitrary `N`.

This method of points distribution is **Area Preserving** but not distance preserving.

When the selected output type is `Point2`, as convention it has been considered: `LAT=x`, `LON=y` and the output can be returned either in `:deg` or `:rad` units.

<p align="center">
  <img src="./docs/img/ico.png" alt="Icogrid"/>
</p>

---

	meshgrid(xRes::ValidAngle; yRes::ValidAngle=xRes, height=nothing, unit=:rad, type=:lla)

This function returns a `Matrix` of `Point2` or `LLA` elements representing a 2D Global grid of coordinates with the specified resolutions `xRes` and `yRes` respectively for x and y axes. This function return the `LAT`, `LON` meshgrid similar to the namesake MATLAB function.

When the selected output type is `Point2`, as convention it has been considered: `LAT=x`, `LON=y` and the output can be returned either in `:deg` or `:rad` units.

<p align="center">
  <img src="./docs/img/mesh.png" alt="Meshgrid"/>
</p>

---

in_region

---

filter_points

---

extract_countries

---

## Useful Internal Functions

    _meshgrid(xin,yin)

Create a 2D grid of coordinates using the input vectors `xin` and `yin`.
The output, in the form of `SVector(xout,yout)`, contains all possible combinations of the elements of `xin` and `yin`, with `xout` corresponding to the horizontal coordinates and `yout` corresponding to the vertical coordinates.

---

    _icogrid(N::Int; coord::Symbol=:sphe, spheRadius=1.0)	

This is the base function used by `icogrid`. This function generates `N` uniformly distributed points on the surface of a unitary sphere using the classic Fibonacci Spiral.

The output can be returned as a `SVector` of either, spherical or cartesian coordinates.

---

	plot_geo(points; title="Point Position GEO Map", camera::Symbol=:twodim, kwargs_scatter=(;), kwargs_layout=(;))

This function takes an `Array` of `Union{Point2,LLA,AbstractVector,Tuple}` of LAT-LON coordinates and generates a plot on a world map projection using the PlotlyJS package.

The input is checked and the angles converted in deg if passed as `Unitful` and interpreted as rad if passed as `Real` values.
