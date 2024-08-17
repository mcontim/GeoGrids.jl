"""
    rectgrid(xRes::ValidAngle; yRes::ValidAngle=xRes) -> Array{LatLon, 2}

Create a rectangular grid of latitude and longitude points with a specified grid
resolutions. The function validates the input resolutions to ensure they are
within the range of `-180°` to `180°`. If a negative resolution is provided, it
is converted to a positive value with a warning. The resolution values are used
to create a rectangular grid covering the entire range of latitudes `[-90°,
90°]` and longitudes `[-180°, 180°)`. 

## Arguments
- `xRes::ValidAngle`: The resolution for the latitude grid spacing. This can be \
a real number (interpreted as degrees) or a `ValidAngle`.
- `yRes::ValidAngle`: The resolution for the longitude grid spacing. This is \
optional and defaults to `xRes` if not provided. This can be a real number \
(interpreted as degrees) or a `ValidAngle`.

## Returns
- A 2D array of `Point{🌐,<:LatLon{WGS84Latest}}` objects representing the grid of latitude and \
longitude points.
"""
function rectgrid(xRes::ValidAngle; yRes::ValidAngle=xRes)
    # Input Validation   
    _xRes = let
        x = xRes isa Real ? xRes * ° : xRes |> u"°" # Convert to Uniful °
        abs(x) ≤ 180° || error("Resolution of x is too large, it must be smaller than 180°...")
        if x < 0
            @warn "Input xRes is negative, it will be converted to positive..."
            abs(x)
        else
            x
        end
    end

    _yRes = let
        x = yRes isa Real ? yRes * ° : yRes |> u"°" # Convert to Uniful °
        abs(x) ≤ 180° || error("Resolution of y is too large, it must be smaller than 180°...")
        if x < 0
            @warn "Input yRes is negative, it will be converted to positive..."
            abs(x)
        else
            x
        end
    end

    # Create the rectangular grid of elements LatLon
    mat = [LatLon(x, y) for x in -90°:_xRes:90°, y in (-180°:_yRes:180°)[2:end]]

    return mat
end

"""
    vecgrid(gridRes::ValidAngle) -> Vector{LatLon}

Generate a vector of latitude points from the equator to the North Pole with a
specified resolution. The function validates the input resolution to ensure it
is within the range of `-90°` to `90°`. If a negative resolution is provided, it
is converted to a positive value with a warning. The resolution value is then
used to create a vector of latitude points ranging from `0°` to `90°` (the North
Pole). Each latitude point is represented as a `LatLon` object with a
fixed longitude of `0°`.

## Arguments
- `gridRes::ValidAngle`: The resolution for the latitude grid spacing. This can \
be a real number (interpreted as degrees) or a `ValidAngle`.

## Returns
- A vector of `LatLon` objects representing latitude points from the \
equator (0°) to the North Pole (90°) with the specified resolution.
"""
function vecgrid(gridRes::ValidAngle)
    # Input Validation
    _gridRes = let
        x = gridRes isa Real ? gridRes * ° : gridRes |> u"°" # Convert to Uniful °
        abs(x) ≤ 90° || error("Resolution of grid is too large, it must be smaller than 90°...")
        if x < 0
            @warn "Input gridRes is negative, it will be converted to positive..."
            abs(x)
        else
            x
        end
    end
    # Create LAT vector
    vec = map(x -> LatLon(x, 0°), 0°:_gridRes:90°) # LAT vector from 0° to 90°

    return vec
end