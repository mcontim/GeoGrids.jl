# Tessellation

**GeoGrids.jl** provides functionality for creating tessellated cell layouts on geographical regions. The package supports different tessellation types and can work with various region types.

```@setup plot
using PlotlyBase
using PlotlyDocumenter
using GeoGrids
```

## Tessellation Types

GeoGrids.jl supports two main types of tessellation:

- `HEX`: Hexagonal tessellation with either `:pointy` or `:flat` orientation
- `ICO`: Icosahedral grid tessellation with customizable correction factor and pattern (`:hex` or `:circle`)

## Global Tessellation

The simplest form of tessellation covers the entire globe using an icosahedral pattern:

```@example plot
region = GlobalRegion()
centers, tiles = generate_tesselation(region, 1400e3, ICO(), EO())
plot = plot_geo_cells(centers, tiles; title="Global Icosahedral Tessellation")
to_documenter(plot) # hide
```

## Regional Tessellation

### Geographical Region

You can create tessellations for specific countries or groups of countries:

```@example plot
region = GeoRegion(admin="Italy;Spain")
centers, tiles = generate_tesselation(region, 50e3, HEX(), EO())
plot = plot_geo_cells(centers, tiles; title="Hexagonal Tessellation of Italy and Spain")
to_documenter(plot) # hide
```

### Latitude Belt Region

Create tessellations for specific latitude bands:

```@example plot
region = LatBeltRegion(lim=(-10,10))
centers, tiles = generate_tesselation(region, 500e3, ICO(), EO())
plot = plot_geo_cells(centers, tiles; title="Equatorial Belt Tessellation")
to_documenter(plot) # hide
```

### Custom Polygon Region

Define tessellations for custom polygon regions:

```@example plot
region = PolyRegion(domain=[
    LatLon(10°, -5°), 
    LatLon(10°, 15°), 
    LatLon(27°, 15°), 
    LatLon(27°, -5°)
])
centers, tiles = generate_tesselation(region, 100e3, HEX(), EO())
plot = plot_geo_cells(centers, tiles; title="Custom Region Tessellation")
to_documenter(plot) # hide
```

## Tessellation Parameters

### Cell Size

The `radius` parameter (in meters) determines the size of the tessellation cells. This represents the nominal radius of each cell:

```@example plot
# Small cells
region = GeoRegion(admin="Italy")
centers1, tiles1 = generate_tesselation(region, 25e3, HEX(), EO())
plot1 = plot_geo_cells(centers1, tiles1; title="25km Cell Radius")
to_documenter(plot1) # hide
```

### Hexagonal Orientation

For `HEX` tessellation, you can choose between `:pointy` (default) and `:flat` orientations:

```@example plot
# Pointy-topped hexagons
region = GeoRegion(admin="France")
centers1, tiles1 = generate_tesselation(region, 75e3, HEX(direction=:pointy), EO())
plot1 = plot_geo_cells(centers1, tiles1; title="Pointy-topped Hexagons")
to_documenter(plot1) # hide
```

```@example plot
# Flat-topped hexagons
region = GeoRegion(admin="France")
centers2, tiles2 = generate_tesselation(region, 75e3, HEX(direction=:flat), EO())
plot2 = plot_geo_cells(centers2, tiles2; title="Flat-topped Hexagons")
to_documenter(plot2) # hide
```

## Usage Notes

- The actual cell sizes may vary slightly from the specified radius due to the Earth's curvature
- For large regions, consider using larger cell sizes to maintain reasonable computation times
- The `EO` parameter is used to generate both cell centers and tile boundaries
- Cell boundaries are returned as vectors of points forming closed polygons