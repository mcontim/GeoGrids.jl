"""
    offset_region(originalRegion::GeoRegion, deltaDist; refRadius=constants.Re_mean, magnitude=3, precision=7)

Offset a GeoRegion by a given distance. This function offsets each polygon in
the GeoRegion separately and combines the results into a Multi geometry.

## Arguments
- `originalRegion::GeoRegion`: The original region to be offset.
- `deltaDist`: The distance to offset the region by, in meters. Positive for \
enlargement, negative for shrinking.
- `refRadius::Float64=constants.Re_mean`: The reference radius to use for the \
Earth.
- `magnitude::Int=3`: The number of integer digits for IntPoint conversion.
- `precision::Int=7`: The total number of digits to be considered for each \
coordinate in IntPoint conversion.

## Returns
- `Multi`: A Multi geometry containing the offset polygons.
"""
function offset_region(originalRegion::GeoRegion, deltaDist; refRadius=constants.Re_mean, magnitude=3, precision=7)
    # `magnitude` represents the number of integer digits while `precision` the
    # total number of digits that will be considered for each of the coordinates
    # for the `IntPoint` conversion. Look at Clipper documentation for more
    # details. `delta` is the distance to offset the polygon by, it is a
    # positive value for enlargement or negative number for shrinking. The value
    # should be expressed in m.

    # Compute the delta value to be used in the offsetting process (in deg)
    delta = rad2deg(deltaDist / refRadius)
    intDelta = Float64(IntPoint(delta, delta, magnitude, precision).X) # We use IntPoint to exploit the conversion to IntPoint in Clipping, then we can use either X or Y as delta value.

    numCountries = length(originalRegion.domain) # Number of Countries in GeoRegion
    allGeoms = map(1:numCountries) do idxCountry
        # Perform the processing per CountryBorder.
        thisCountryGeoms = originalRegion.domain[idxCountry].latlon.geoms
        map(eachindex(thisCountryGeoms)) do idxGeom
            # Get the offsetted version of each of the PolyArea composing this Country
            # Perform processing per single PolyArea.
            _offset_polygon(thisCountryGeoms[idxGeom], intDelta; magnitude, precision)
        end |> splat(vcat)
    end |> splat(vcat)

    return Multi(map(identity, allGeoms))
end

"""
    _offset_polygon(poly::PolyArea, delta; magnitude=3, precision=7)

Offset a polygon by a given delta value. This function uses the Clipper library
for polygon offsetting. It may return multiple polygons even when starting from
a single PolyArea.

## Arguments
- `poly::PolyArea`: The polygon to be offset.
- `delta`: The distance to offset the polygon by. Positive for enlargement, \
negative for shrinking.
- `magnitude::Int=3`: The number of integer digits for IntPoint conversion.
- `precision::Int=7`: The total number of digits to be considered for each \
coordinate in IntPoint conversion.

## Returns
- Vector of `PolyArea`: The resulting offset polygons.
"""
function _offset_polygon(poly::PolyArea{🌐,<:LatLon{WGS84Latest}}, delta; magnitude=3, precision=7)
    # delta translated in deg wrt the Earrth radius
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
    geoms = map(eachindex(offset_polygons)) do i
        ring = map(offset_polygons[i]) do vertex
            lonlat = tofloat(vertex, magnitude, precision)
            LatLon{WGS84Latest}(lonlat[2], lonlat[1]) |> Point
        end
        PolyArea(ring)
    end

    # Return a vector of PolyArea.
    return geoms
end