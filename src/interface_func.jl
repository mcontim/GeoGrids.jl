## Define Getters
get_lat(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}) = p.coords.lat
get_lat(p::Point{🌐,<:LatLon{WGS84Latest}}) = p.coords.y |> ustrip |> Deg # LAT is Y
get_lat(p::LatLon) = p.lat

get_lon(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}) = p.coords.lon
get_lon(p::Point{🌐,<:LatLon{WGS84Latest}}) = p.coords.x |> ustrip |> Deg # LON is X
get_lon(p::LatLon) = p.lon

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
# Fallback on Base.in for CountryBorder defined in CountriesBorders
Base.in(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}, gr::GeoRegion) = in(p, gr.domain)
Base.in(p::Point{🌐,<:LatLon{WGS84Latest}}, gr::GeoRegion) = in(p, gr.domain)
Base.in(p::LatLon, gr::GeoRegion) = in(p, gr.domain)

Base.in(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}, pb::PolyBorder) = in(p, borders(Cartesian, pb))
Base.in(p::Point{🌐,<:LatLon{WGS84Latest}}, pb::PolyBorder) = in(Meshes.flat(p), pb)
Base.in(p::LatLon, pb::PolyBorder) = in(Point(LatLon{WGS84Latest,Deg{Float32}}(p.lat, p.lon)), pb)

Base.in(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}, pr::PolyRegion) = in(p, pr.domain)
Base.in(p::Point{🌐,<:LatLon{WGS84Latest}}, pr::PolyRegion) = in(p, pr.domain)
Base.in(p::LatLon, pr::PolyRegion) = in(p, pr.domain)

# //TODO: add new tests for Base.in and getters
Base.in(p::Point{𝔼{2},<:Cartesian2D{WGS84Latest}}, lbr::LatBeltRegion) = lbr.latLim[1] < get_lat(p) < lbr.latLim[2]
Base.in(p::Point{🌐,<:LatLon{WGS84Latest}}, lbr::LatBeltRegion) = lbr.latLim[1] < get_lat(p) < lbr.latLim[2]
Base.in(p::LatLon, lbr::LatBeltRegion) = lbr.latLim[1] < p.lat < lbr.latLim[2]

## centroid()
# Define ad-hoc methods for GeoRegion - using centroid definition of CountriesBorders.jl
Meshes.centroid(crs::Type{<:Union{LatLon, Cartesian}}, d::GeoRegion) = centroid(crs, d.domain) # Fallback on all the definitions in CountriesBorders.jl for CountryBorder
Meshes.centroid(d::GeoRegion) = centroid(Cartesian, d)

# Define ad-hoc methods for PolyRegion - using centroid definition of Meshes.jl
Meshes.centroid(::Type{Cartesian}, d::PolyBorder) = centroid(d.cart)
function Meshes.centroid(::Type{LatLon}, d::PolyBorder)
    c = centroid(d.cart)
    LatLon{WGS84Latest}(get_lat(c), get_lon(c)) |> Point
end
Meshes.centroid(crs::Type{<:Union{LatLon, Cartesian}}, d::PolyRegion) = centroid(crs, d.domain)
Meshes.centroid(d::PolyRegion) = centroid(Cartesian, d.domain)