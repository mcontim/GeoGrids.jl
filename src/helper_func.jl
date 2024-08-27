"""
    _wrap_latlon(lat::Number, lon::Number)

The `_wrap_latlon` function normalizes and wraps geographic coordinates,
latitude (`lat`) and longitude (`lon`). It ensures that the latitude is within
the range [-90, 90] degrees and the longitude is within the range [-180, 180)
degrees. This function is useful for handling geographic data where coordinates
might exceed their typical bounds.

## Arguments
- `lat::Number`: The latitude value to be normalized and wrapped, expressed in \
degrees.
- `lon::Number`: The longitude value to be normalized and wrapped, expressed \
in degrees.

## Returns
- `Tuple{Number, Number}`: A tuple `(lat, lon)` in degrees where `lat` is in the \
range [-90, 90] and `lon` is in the range [-180, 180).
"""
function _wrap_latlon(lat::Number, lon::Number)
    # Normalize lat to the range [-180, 180)
    lat = rem(lat, 360, RoundNearest)
    lon = rem(lon, 360, RoundNearest)

    # Wrap to the range [-90, 90] and make the longitude "jump"
    if lat > 90
        lat = 180 - lat
        lon = lon + 180
        lon = rem(lon, 360, RoundNearest)
    elseif lat < -90
        lat = -180 - lat
        lon = lon + 180
        lon = rem(lon, 360, RoundNearest)
    end

    return lat, lon
end

"""
    _add_angular_offset(inputθϕ, offsetθϕ) -> NamedTuple{(:θ, :ϕ), Tuple{Float64, Float64}}

Add an angular offset to given spherical coordinates.

## Arguments
- `inputθϕ::NamedTuple{(:θ, :ϕ), Tuple{Float64, Float64}}`: The input spherical \
coordinates with components `θ` (polar angle) and `ϕ` (azimuthal angle) in \
radians.
- `offsetθϕ::NamedTuple{(:θ, :ϕ), Tuple{Float64, Float64}}`: The offset \
spherical coordinates with components `θ` (polar angle) and `ϕ` (azimuthal \
angle) in radians.

## Returns
- `NamedTuple{(:θ, :ϕ), Tuple{Float64, Float64}}`: The new spherical coordinates \
after applying the angular offset, with components `θ` and `ϕ` in radians.
"""
function _add_angular_offset(inputθϕ, offsetθϕ)
    sϕ, cϕ = sincos(inputθϕ.ϕ)
    sθ, cθ = sincos(inputθϕ.θ)
    sΔϕ, cΔϕ = sincos(offsetθϕ.ϕ)
    sΔθ, cΔθ = sincos(offsetθϕ.θ)

    # Define the orthonormal basis describing a new reference system [r̂, θ̂, ϕ̂] 
    # and it's relation with ECEF cartesian [x̂, ŷ, ẑ] as per
    # [Wikipedia](https://en.wikipedia.org/wiki/Spherical_coordinate_system#Integration_and_differentiation_in_spherical_coordinates)
    r̂ = SA_F64[sθ*cϕ, sθ*sϕ, cθ]
    θ̂ = SA_F64[cθ*cϕ, cθ*sϕ, -sθ]
    ϕ̂ = SA_F64[-sϕ, cϕ, 0]

    # Define the rotation matrix to go from the new local reference system to
    # the ECEF cartesian system. We want the z axis of the new system to be
    # aligned with the direction of the input vector [centre], so the order of
    # axis such to have a right-handed reference system will be [θ̂, ϕ̂, r̂]. At
    # this point we can describe the offset rotation as a vector represented ni
    # this new reference system, as described in:
    # https://math.stackexchange.com/questions/4343044/rotate-vector-by-a-random-little-amount
    # Even if we inverted the axes such to get the z axis aligned with the
    # input, the system of equations still hold to get the ordered [x̂, ŷ, ẑ]
    # axes.
    R = hcat(θ̂, ϕ̂, r̂) # [θ̂, ϕ̂, r̂] -> [x̂, ŷ, ẑ]  

    # Write the offset vector wrt the new referene system.
    vᴵ = [sΔθ * cΔϕ, sΔθ * sΔϕ, cΔθ]

    # Transform the offset vector to the ECEF cartesian system.
    v = R * vᴵ

    # Convert back to spherical coordinates
    r = norm(v)
    θ = acos(v[3] / r)
    ϕ = atan(v[2], v[1])

    return (θ=θ, ϕ=ϕ) # [deg] ALBERTO: ?? Is it deg though? as the acos and atan return values in radians
end

"""
    cartesian_geometry(poly::PolyArea{🌐,<:LATLON})
    cartesian_geometry(multi::Multi{🌐,<:LATLON})

Convert geometries from LatLon to Cartesian coordinate systems.

## Arguments
- `poly::PolyArea{🌐,<:LATLON}`: A polygon in LatLon coordinates.
- `multi::Multi{🌐,<:LATLON}`: A multi-geometry in LatLon coordinates.

## Returns
- `PolyArea` or `Multi`: The converted geometry in Cartesian coordinate system.
"""
function cartesian_geometry(poly::PolyArea{🌐,<:LATLON})
    map(rings(poly)) do r
        map(Meshes.flat, vertices(r)) |> Ring
    end |> splat(PolyArea)
end
cartesian_geometry(multi::Multi{🌐,<:LATLON}) = map(cartesian_geometry, parent(multi)) |> Multi

"""
    latlon_geometry(poly::PolyArea{𝔼{2},<:CART})
    latlon_geometry(multi::Multi{𝔼{2},<:CART})

Convert geometries from Cartesian to LatLon coordinate systems.

## Arguments
- `poly::PolyArea{𝔼{2},<:CART}`: A polygon in Cartesian coordinates.
- `multi::Multi{𝔼{2},<:CART}`: A multi-geometry in Cartesian coordinates.

## Returns
- `PolyArea` or `Multi`: The converted geometry in LatLon coordinate system.
"""
function latlon_geometry(poly::PolyArea{𝔼{2},<:CART})
    map(rings(poly)) do r
        map(vertices(r)) do v
            LatLon{WGS84Latest}(coords(v).y |> ustrip, coords(v).x |> ustrip) |> Point
        end |> Ring
    end |> splat(PolyArea)
end
latlon_geometry(multi::Multi{𝔼{2},<:CART}) = map(latlon_geometry, parent(multi)) |> Multi