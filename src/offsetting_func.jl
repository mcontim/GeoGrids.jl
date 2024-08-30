"""
    offset_region(originalRegion::GeoRegion, deltaDist; refRadius=constants.Re_mean, magnitude=3, precision=7)
    offset_region(originalRegion::PolyRegion, deltaDist; refRadius=constants.Re_mean, magnitude=3, precision=7)

Offset a GeoRegion or PolyRegion by a given distance. This function offsets each polygon in
the region separately and combines the results into a Multi geometry.

## Arguments
- `originalRegion::Union{GeoRegion,PolyRegion}`: The original region to be offset.
- `deltaDist`: The distance to offset the region by, in meters. Positive for \
enlargement, negative for shrinking.
- `refRadius::Float64=constants.Re_mean`: The reference radius to use for the \
Earth.
- `magnitude::Int=3`: The number of integer digits for IntPoint conversion.
- `precision::Int=7`: The total number of digits to be considered for each \
coordinate in IntPoint conversion.

## Returns
- `Multi`: A Multi geometry containing the offset polygons.

## Notes
- For GeoRegion, only the outer ring of each polygon is considered for offsetting.
- For PolyRegion, if multiple outer rings are produced, inner rings are ignored \
and separate PolyAreas are created for each outer ring.
"""
function offset_region(originalRegion::GeoRegion{D,P}, deltaDist; refRadius=constants.Re_mean, magnitude=3, precision=7) where {D,P}
    # `magnitude` represents the number of integer digits while `precision` the
    # total number of digits that will be considered for each of the coordinates
    # for the `IntPoint` conversion. Look at Clipper documentation for more
    # details. `delta` is the distance to offset the polygon by, it is a
    # positive value for enlargement or negative number for shrinking. The value
    # should be expressed in m.

    # Compute the delta value to be used in the offsetting process (in deg)
    delta = rad2deg(deltaDist / refRadius)
    intDelta = Float64(IntPoint(delta, delta, magnitude, precision).X) # We use IntPoint to exploit the conversion to IntPoint in Clipping, then we can use either X or Y as delta value. Clipper wants Float64

    numCountries = length(originalRegion.domain) # Number of Countries in GeoRegion
    allGeoms = map(1:numCountries) do idxCountry
        # Perform the processing per CountryBorder.
        thisCountryGeoms = originalRegion.domain[idxCountry].latlon.geoms
        map(eachindex(thisCountryGeoms)) do idxGeom
            # Perform processing per single PolyArea. Get the offsetted version
            # of each of the PolyArea composing this Country. 
            # //NOTE: 
            # Only outer ring (i.e., [1] is considered for the enlargement of the
            # GeoRegion. We avoid considering the inner rings since they are not
            # relevant for our application.
            outerRing = rings(thisCountryGeoms[idxGeom])[1]
            offsetRings = _offset_ring(outerRing, intDelta; magnitude, precision)
            # Create a separate PolyArea for each of the offset rings.
            map(offsetRings) do ring
                PolyArea(ring)
            end
        end |> splat(vcat)
    end |> splat(vcat)

    return Multi(map(identity, allGeoms))
end

function offset_region(originalRegion::PolyRegion, deltaDist; refRadius=constants.Re_mean, magnitude=3, precision=7)
    delta = rad2deg(deltaDist / refRadius)
    intDelta = Float64(IntPoint(delta, delta, magnitude, precision).X) # We use IntPoint to exploit the conversion to IntPoint in Clipping, then we can use either X or Y as delta value.

    vecRings = rings(originalRegion.domain.latlon)
    numRings = length(vecRings) # Number of Countries in GeoRegion

    allGeoms = if numRings == 1
        outerRing = _offset_ring(vecRings[1], intDelta; magnitude, precision)
        PolyArea(outerRing)
    else
        # Create outer ring.
        outerRing = _offset_ring(vecRings[1], intDelta; magnitude, precision)
        if length(outerRing) > 1
            # Multiple outer rings: we create a separate PolyArea for each of the outer rings.
            @warn "The offsetting of the PolyRegion produced multiple outer rings. All the inner rings will be ignored and separte PolyArea will be created for each of the outer ring."
            map(outerRing) do ring
                PolyArea(ring)
            end
        else
            # Single outer ring: we create a single PolyArea with the outer ring and all the inner rings.
            # Process inner rings.
            holes = map(vecRings[2:numRings]) do ring
                _offset_ring(ring, -intDelta; magnitude, precision) # delta for inner rings is the opposite of the delta for the outer ring.
            end
            PolyArea([outerRing, holes...])
        end
    end

    return Multi(map(identity, allGeoms))
end

"""
    _offset_ring(ring::Ring{🌐,<:LatLon{WGS84Latest}}, delta; magnitude=3, precision=7, rings=false)

Offset a ring by a given delta value. This function uses the Clipper library
for polygon offsetting. It may return multiple rings even when starting from
a single Ring.

## Arguments
- `ring::Ring{🌐,<:LatLon{WGS84Latest}}`: The ring to be offset.
- `delta`: The distance to offset the ring by. Positive for enlargement, \
negative for shrinking.
- `magnitude::Int=3`: The number of integer digits for IntPoint conversion.
- `precision::Int=7`: The total number of digits to be considered for each \
coordinate in IntPoint conversion.
- `rings::Bool=false`: Unused parameter, kept for backwards compatibility.

## Returns
- Vector of `Ring{🌐,<:LatLon{WGS84Latest}}`: The resulting offset rings.
"""
function _offset_ring(ring::RING_LATLON{T}, delta; magnitude=3, precision=7, rings=false) where T
    # delta translated in deg wrt the Earrth radius
    intPoly = map([vertices(ring)...]) do vertex # Use splat to avoid CircularVector as output from map
        y = get_lat(vertex) |> ustrip
        x = get_lon(vertex) |> ustrip
        IntPoint(x, y, magnitude, precision) # Consider LON as X and LAT as Y
    end
    co = ClipperOffset()
    add_path!(co, intPoly, JoinTypeMiter, EndTypeClosedPolygon) # We fix JoinTypeMiter, EndTypeClosedPolygon because it works well with complex polygons, look at Clipper documentation for details.
    offset_polygons = execute(co, delta) # Clipper polygon
    # We can end up with multiple polygons even when starting from a single
    # Ring. So we will return all the polygons generate for this Ring as A#
    # a vector of Rings. Afterwards they will be used as outer or inner rings.
    outRings = map(eachindex(offset_polygons)) do i
        map(offset_polygons[i]) do vertex
            lonlat = tofloat(vertex, magnitude, precision)
            LatLon{WGS84Latest}(lonlat[2] |> T, lonlat[1] |> T) |> Point # Use consistent type precision for the coordinates.
        end |> Ring
    end

    # Return a vector of Ring.
    return outRings
end