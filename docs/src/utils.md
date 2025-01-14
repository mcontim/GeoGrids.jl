# Utility Functions

**GeoGrids.jl** provides several utility functions for visualizing geographical data. These functions are built on top of PlotlyJS and offer convenient ways to plot points, cells, and regions on a world map.

```@setup plot
using PlotlyBase
using PlotlyDocumenter
using GeoGrids
```

## Plotting Points

The `plot_geo_points` function visualizes points on a geographical map:

```@example plot
# Generate some points
points = icogrid(sepAng=10)

# Basic point plotting
plot = plot_geo_points(
    points; 
    title="Global Point Distribution",
)
to_documenter(plot) # hide
```

You can customize the visualization with various parameters:

```@example plot
# Points with custom layout
region = GeoRegion(admin="Spain")
points = filter_points(icogrid(sepAng=2), region)

plot = plot_geo_points(
    points;
    title="Points in Spain",
    kwargs_layout=(;
        geo_fitbounds="locations"
    ),
    kwargs_scatter=(;
        marker_size=8,
        marker_color="red"
    )
)
to_documenter(plot) # hide
```

## Plotting Cells

The `plot_geo_cells` function visualizes tessellation cells on a map:

```@example plot
# Generate a tessellation
region = GeoRegion(admin="Italy")
centers, tiles = generate_tesselation(region, 50e3, HEX(), EO())

# Plot the cell layout
plot = plot_geo_cells(
    centers, 
    tiles;
    title="Hexagonal Cells Over Italy",
    kwargs_layout=(;
        geo_fitbounds="locations"
    )
)
to_documenter(plot) # hide
```

## Plotting Regions

The `plot_geo_poly` function visualizes region boundaries:

```@example plot
# Create an enlarged region
region = GeoRegionOffset(
    delta=10e3, 
    admin="Austria", 
    resolution=110
)

# Plot the region boundaries
plot = plot_geo_poly(
    region.domain;
    title="Austria with 10km Buffer",
    kwargs_layout=(;
        geo_fitbounds="locations"
    )
)
to_documenter(plot) # hide
```

## Common Parameters

All plotting functions accept these common parameters:
- `title`: Plot title (String)
- `kwargs_layout`: Dictionary of layout parameters for PlotlyJS
- `kwargs_scatter`: Dictionary of scatter trace parameters for PlotlyJS

### Useful Layout Parameters
- `geo_scope`: Set map scope ("world", "europe", "asia", etc.)
- `geo_showland`: Show landmasses (Boolean)
- `geo_showocean`: Show oceans (Boolean)
- `geo_fitbounds`: Automatically fit view to data ("locations")
- `geo_projection_type`: Map projection type ("equirectangular", "mercator", etc.)

### Useful Scatter Parameters
- `marker_size`: Size of points
- `marker_color`: Color of points or cell boundaries
- `marker_symbol`: Symbol type for points
- `line_width`: Width of cell or region boundaries
