
# Define borders for PolyRegion
borders(::Type{LatLon}, pb::PolyBorder) = pb.latlon
borders(::Type{Cartesian}, pb::PolyBorder) = pb.cart
borders(pb::PolyBorder) = borders(LatLon, pb)

function borders(::Type{T}, pr::PolyRegion) where {T}
    borders(T, pr.domain)
end
borders(pr::PolyRegion) = borders(LatLon, pr)

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
Base.in(point::LatLon, domain::GeoRegion) = in(point, domain) # Fallback on Base.in for CountryBorder defined in CountriesBorders

Base.in(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}, pb::PolyBorder) = in(p, borders(Cartesian, pb))
Base.in(p::Point{🌐,<:LatLon{WGS84Latest}}, pb::PolyBorder) = in(Meshes.flat(p), pb)
Base.in(p::LatLon, pb::PolyBorder) = in(Point(LatLon{WGS84Latest,Deg{Float32}}(p.lat, p.lon)), pb)
Base.in(p::LatLon, pr::PolyRegion) = in(p, pr.domain)

Base.in(point::LatLon, domain::LatBeltRegion) = domain.latLim[1] < point.lat < domain.latLim[2]