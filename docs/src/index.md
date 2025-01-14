# GeoGrids.jl

**GeoGrids.jl** is a Julia package for generating and manipulating geographical grids, particularly useful for system-level simulations and geospatial analysis. The package provides tools for creating various types of grids, defining geographical regions, and performing spatial operations.

## Features

- **Grid Generation**: Create uniform point distributions using icosahedral, rectangular, or vector grid patterns
- **Region Definition**: Define areas of interest using latitude belts, country boundaries, or custom polygons
- **Tessellation**: Generate cell layouts with hexagonal or icosahedral patterns
- **Filtering**: Efficiently filter and group points based on geographical regions

## Quick Example

Here's a simple example that demonstrates some key features of GeoGrids.jl:

```@example overview
using GeoGrids
using PlotlyBase
using PlotlyDocumenter

# Create a geographical region for France
region = GeoRegion(admin="France")

# Generate a hexagonal cell layout
centers, tiles = generate_tesselation(region, 75e3, HEX(), EO())

# Create the plot
plot = plot_geo_cells(
    centers, 
    tiles; 
    title="75km Hexagonal Cells Over France",
    kwargs_layout=(;geo_fitbounds="locations")
)
to_documenter(plot) # hide
```

This example shows how to:
1. Define a geographical region using a country name
2. Create a hexagonal tessellation with 75km cell radius
3. Visualize the resulting cell layout

## Getting Started

To install GeoGrids.jl, use Julia's package manager:

```julia
using Pkg
Pkg.add("GeoGrids")
```

Then import the package:

```julia
using GeoGrids
```

For more detailed information, see the documentation for each component.

