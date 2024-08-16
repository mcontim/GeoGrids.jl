## boders()
# Define borders for PolyRegion
borders(::Type{LatLon}, pb::PolyBorder) = pb.latlon
borders(::Type{Cartesian}, pb::PolyBorder) = pb.cart
borders(pb::PolyBorder) = borders(LatLon, pb)

function borders(::Type{T}, pr::PolyRegion) where {T}
    borders(T, pr.domain)
end
borders(pr::PolyRegion) = borders(LatLon, pr)

# Define borders for GeoRegion
function borders(::Type{T}, gr::GeoRegion) where {T}
    map(x -> CountriesBorders.borders(T, x), gr.domain)
end
borders(gr::GeoRegion) = map(x -> CountriesBorders.borders(LatLon, x), gr.domain)

## Base.in()
"""
    Base.in(point::LatLon, domain::GeoRegion) -> Bool
    Base.in(point::LatLon, domain::PolyRegion) -> Bool
    Base.in(point::LatLon, domain::LatBeltRegion) -> Bool

Check if a geographical point is within a specified region.

## Arguments
- `point::LatLon`: The geographical point to be checked.
- `domain::Union{GeoRegion, PolyRegion, LatBeltRegion}`: The region in which the \
point is to be checked. The region is represented by the `domain` attribute.

## Returns
- `Bool`: Returns `true` if the point is within the region, `false` otherwise.
"""
Base.in(point::LatLon, domain::GeoRegion) = in(point, domain.domain) # Fallback on Base.in for CountryBorder defined in CountriesBorders

Base.in(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}, pb::PolyBorder) = in(p, borders(Cartesian, pb))
Base.in(p::Point{🌐,<:LatLon{WGS84Latest}}, pb::PolyBorder) = in(Meshes.flat(p), pb)
Base.in(p::LatLon, pb::PolyBorder) = in(Point(LatLon{WGS84Latest,Deg{Float32}}(p.lat, p.lon)), pb)
Base.in(p::LatLon, pr::PolyRegion) = in(p, pr.domain)

Base.in(point::LatLon, domain::LatBeltRegion) = domain.latLim[1] < point.lat < domain.latLim[2]

## centroid()
# Define ad-hoc methods for GeoRegion - using centroid definition of CountriesBorders.jl
Meshes.centroid(crs::Type{<:Union{LatLon, Cartesian}}, d::GeoRegion) = centroid(crs, d.domain) # Fallback on all the definitions in CountriesBorders.jl for CountryBorder
Meshes.centroid(d::GeoRegion) = centroid(Cartesian, d)

# Define ad-hoc methods for PolyRegion - using centroid definition of Meshes.jl
Meshes.centroid(::Type{Cartesian}, d::PolyBorder) = centroid(d.cart)
function Meshes.centroid(::Type{LatLon}, d::PolyBorder)
    c = centroid(d.cart)
    lat = ustrip(c.coords.y) |> Deg # lat is Y
    lon = ustrip(c.coords.x) |> Deg # lon is X
    LatLon{WGS84Latest}(lat, lon) |> Point
end
Meshes.centroid(crs::Type{<:Union{LatLon, Cartesian}}, d::PolyRegion) = centroid(crs, d.domain)
Meshes.centroid(d::PolyRegion) = centroid(Cartesian, d.domain)