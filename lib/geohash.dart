library geohash;

// List<String> neighborsFor(String geoHash) {
//   return [];
// }

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude)
      : assert(latitude != null),
        assert(longitude != null);

  factory LatLng.fromGeoHash(String hash) {
    double lat = 0;
    double lng = 0;
    return LatLng(lat, lng);
  }

  String toGeoHash({
    int precision = 12,
  }) {
    return 'x';
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LatLng &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^ longitude.hashCode;
  }
}
