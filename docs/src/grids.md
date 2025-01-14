# Grids

**GeoGrids.jl** offers a straightforward way to generate grids on a sphere, including Fibonacci and rectangular patterns. This builds on a long history of methods developed to evenly distribute points or create practical grid layouts on spherical surfaces, a challenge in fields like geospatial analysis and climate modeling. The module aims to provide a simple, flexible tool for working with these grids in a variety of applications.

```@setup plot
# Setting up some templating
using PlotlyBase
using PlotlyDocumenter
using GeoGrids
```

## Icosahedral Grid

The function `icogrid` returns a `Vector` of `Point{🌐,<:LatLon{WGS84Latest}}` elements, representing a global grid built with an icosahedral-based method.

```@example plot
grid = icogrid(sepAng=10)
plot = plot_geo_points(grid; title="Ico Grid")
to_documenter(plot) # hide
```

At least one of `N`, the number of points to generate, or `sepAng`, the separation angle between points, must be provided.

The problem of how to evenly distribute points on a sphere has a very long history. Unfortunately, except for a small handful of cases, it still has not been exactly solved. Therefore, in nearly all situations, we can merely hope to find near-optimal solutions to this problem. Of these near-optimal solutions, the icosahedral grid is one approach that provides a more uniform distribution of points on a sphere compared to simple latitude-longitude grids. It starts with a regular icosahedron inscribed in a sphere and then subdivides its faces to create a finer mesh. This method of point distribution aims to provide a more uniform coverage of the Earth's surface, which can be particularly useful for global-scale simulations or analyses.

The function returns points in the WGS84 coordinate system, represented as latitude-longitude pairs.

## Rectangular Grid

The function `rectgrid` generates a rectangular grid of points on the Earth's surface. It returns a `Matrix` of `Point{🌐,<:LatLon{WGS84Latest}}` elements, representing a global grid with the specified parameters. This rectangular grid can be useful for various geospatial applications, such as creating evenly spaced sampling points across the globe or defining a regular grid for data analysis and visualization.

```@example plot
grid = rectgrid(10)[:]
plot = plot_geo_points(grid; title="Rect Grid")
to_documenter(plot) # hide
```

## Vector Grid

The `vecgrid` function generates a vector of latitude points ranging from 0° (the equator) to 90° (the North Pole) at a fixed longitude of 0°.  It returns a `Vector` of `Point{🌐,<:LatLon{WGS84Latest}}` elements, representing a grid of latitudes with the specified resolution.

This vector grid can be useful for various applications that require sampling or analysis along a meridian, such as studying latitudinal variations in climate data, or creating a basis for more complex grid structures.

```@example plot
grid = vecgrid(10)
plot = plot_geo_points(grid; title="Vector Grid")
to_documenter(plot) # hide
```

The `gridRes` parameter must be provided, which is the resolution for the latitude grid spacing. This can be a real number (interpreted as degrees) or a `ValidAngle`.
