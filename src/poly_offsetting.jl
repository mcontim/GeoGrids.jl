# mutable struct GeoRegionEnlarged <: AbstractRegion
#     standardRegion::GeoRegion
#     enlargedRegion::GeoRegion

#     function GeoRegionEnlarged(standardRegion::GeoRegion, delta::Real)
#         # Add code for enlargement of the region

#         # new(standardRegion, enlargedRegion)
#     end
# end
# //NOTE: Alternative definition as a subtype of GeoRegion
mutable struct GeoRegionEnlarged <: GeoRegion
    original::GeoRegion
    domain::Multi

    function GeoRegionEnlarged(original::GeoRegion, delta::Real)
        # Add code for enlargement of the region

        # new(standardRegion, enlargedRegion)
    end
end

function _offset_polygon(poly::PolyArea, delta; magnitude=3, precision=7)
    intPoly = map(vertices(poly)) do vertex
        y = get_lat(vertex) |> ustrip 
        x = get_lon(vertex) |> ustrip
        IntPoint(x, y, magnitude, precision) # Consider LON as X and LAT as Y
    end
    co = ClipperOffset()
    add_path!(co, intPoly, JoinTypeMiter, EndTypeClosedPolygon) # We fix JoinTypeMiter, EndTypeClosedPolygon because it works well with complex polygons, look at Clipper documentation for details.
    offset_polygons = execute(co, delta)

    # We can end up with multiple polygons even when starting from a single
    # PolyArea. So we will return all the polygons for this country as a vector
    # of PolyArea.
    polyAreas = PolyArea[]
    for i in eachindex(offset_polygons)
        ring = map(offset_polygons[i]) do vertex
            lat = tofloat(vertex.Y, magnitude, precision)
            lon = tofloat(vertex.X, magnitude, precision)
            LatLon{WGS84Latest}(lat, lon) |> Point
        end
        push!(polyAreas, PolyArea(ring))
    end
 
    return polyAreas
end

function offset_region(originalRegion::GeoRegion, delta_km; refRadius=constants.Re_mean, magnitude=3, precision=7)
    # `magnitude` represents the number of integer digits while `precision` the
    # total number of digits that will be considered for each of the coordinates
    # for the `IntPoint` conversion. Look at Clipper documentation for more
    # details. `delta` is the distance to offset the polygon by, it is a
    # positive value for enlargement or negative number for shrinking. The value
    # should be expressed in km.

    # Compute the delta value to be used in the offsetting process
    delta = delta_km / refRadius
    intDelta = IntPoint(delta, delta, magnitude, precision).X # We use IntPoint to exploit the conversion to IntPoint in Clipping, then we can use either X or Y as delta value.

    numCountries = length(originalRegion.domain) # Number of Countries in GeoRegion
    for idxCountry in 1:numCountries
        country = originalRegion.domain[idxCountry]
        # (; admin, latlon, resolution, table_idx, valid_polyareas) = country

        offsetPolyAreas = map(latlon.geoms) do geom
            # Get the offsetted version of each of the PolyArea composing the country
            offsetPolyAreas_thisGeom = _offset_polygon(geom, intDelta; magnitude, precision)
            # //TODO: Keep coding such to end up with a vector of PolyArea which will be used to build a Multi. The Multi will be then the new enlargedRegion. Avoid using CountryBorder and basic GeoRegion structure. However, since GeoRegion can take a parametric domain and we already defined all the filtering functions for GeoRegion, maube we cn use the Multi as domain for an enlarged GeoRegion. Alternatively we can also build a subtype of GeoRegion which will have a unique field with the Multi representing the enlarged region. And the current functions working with GeoRegion will keep working as they are (almost).
        end
    end


 

end

# //NOTE: NExt Step: 
# [x] Use Clipping.jl for offsetting the polygon
# [x] Starting from the example notebook `polygon_offset.jl`, understand the relation between the value δ and the increase/decrease in polygon area
# [] Test the package with CountriesBorders to see if it works with those domains
# [] Map the value of δ to a Lat-Lon quantity for enlargement/decrease in area
# [] Write an interface function between CountriesBorders/Meshes and Clipping.jl

# [] Investigate alternative packages for polygon offsetting:
#    - GeometryBasics.jl: Provides basic geometric types and operations
#    - Meshes.jl: Offers advanced mesh processing capabilities
#    - LazySets.jl: Includes polygon operations and may support offsetting
#    - Clipper.jl: A Julia wrapper for the Clipper library, which supports polygon offsetting
# [] Compare the features and performance of these packages with Clipping.jl
# [] Choose the most suitable package for our polygon offsetting needs




