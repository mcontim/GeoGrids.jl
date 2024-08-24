mutable struct GeoRegionEnlarged{D} <: AbstractRegion
    original::GeoRegion{D}
    name::String
    domain::Multi
    convexhull::PolyArea
end
function GeoRegionEnlarged(delta_km; name="enlarged_region", continent="", subregion="", admin="", refRadius=constants.Re_mean, magnitude=3, precision=7)
    gr = GeoRegion(; name, continent, subregion, admin)
    or = offset_region(gr, delta_km; refRadius, magnitude, precision)
    ch = convexhull(or)

    GeoRegionEnlarged(gr, name, or, ch)
end
function GeoRegionEnlarged(gr::GeoRegion, delta_km; name="enlarged_region", refRadius=constants.Re_mean, magnitude=3, precision=7)
    or = offset_region(gr, delta_km; refRadius, magnitude, precision)
    ch = convexhull(or)

    GeoRegionEnlarged(gr, name, or, ch)
end

function _offset_polygon(poly::PolyArea, delta; magnitude=3, precision=7)
    intPoly = map([vertices(poly)...]) do vertex # Avoid CircularVector as output from map
        y = get_lat(vertex) |> ustrip 
        x = get_lon(vertex) |> ustrip
        IntPoint(x, y, magnitude, precision) # Consider LON as X and LAT as Y
    end
    co = ClipperOffset()
    add_path!(co, intPoly, JoinTypeMiter, EndTypeClosedPolygon) # We fix JoinTypeMiter, EndTypeClosedPolygon because it works well with complex polygons, look at Clipper documentation for details.
    offset_polygons = execute(co, delta) # Clipper polygon
    # We can end up with multiple polygons even when starting from a single
    # PolyArea. So we will return all the polygons for this country as a vector
    # of PolyArea.
    geoms = PolyArea[]
    for i in eachindex(offset_polygons)
        ring = map(offset_polygons[i]) do vertex
            lonlat = tofloat(vertex, magnitude, precision)
            LatLon{WGS84Latest}(lonlat[2], lonlat[1]) |> Point
        end
        push!(geoms, PolyArea(ring))
    end
 
    # Return a vector of PolyArea.
    return geoms
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
    intDelta = Float64(IntPoint(delta, delta, magnitude, precision).X) # We use IntPoint to exploit the conversion to IntPoint in Clipping, then we can use either X or Y as delta value.

    numCountries = length(originalRegion.domain) # Number of Countries in GeoRegion
    allGeoms = PolyArea[]
    for idxCountry in 1:numCountries
        # Perform the processing per CountryBorder.
        thisCountryGeoms = originalRegion.domain[idxCountry].latlon.geoms
        for idxGeom in eachindex(thisCountryGeoms)
            # Get the offsetted version of each of the PolyArea composing this Country
            # Perform processing per single PolyArea.
            offsetGeom = _offset_polygon(thisCountryGeoms[idxGeom], intDelta; magnitude, precision)
            append!(allGeoms, offsetGeom)
        end
    end

    return Multi(allGeoms)
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




