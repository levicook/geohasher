library geohash;

String Encode(double lat, double lng, {int precision = 12}) {
  return LatLng(lat, lng).toGeoHash(precision: precision);
}

LatLng Decode(String hash) {
  return LatLng.fromGeoHash(hash);
}

class LatLng {
  final double latitude;
  final double longitude;

  static const _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

  const LatLng(this.latitude, this.longitude)
      : assert(latitude != null && latitude >= -90 && latitude <= 90),
        assert(longitude != null && latitude >= -180 && latitude <= 180);

  factory LatLng.fromGeoHash(String hash) {
    double lat = 0; // TODO
    double lng = 0; // TODO
    return LatLng(lat, lng);
  }

  String toGeoHash({int precision = 12}) {
    assert(precision != null && precision >= 0 && precision <= 12);

    int idx = 0; // index into base32 map
    int bit = 0; // each char holds 5 bits
    bool evenBit = true;
    String geohash = '';

    double latMin = -90;
    double latMax = 90;
    double lonMin = -180;
    double lonMax = 180;

    while (geohash.length < precision) {
      if (evenBit) {
        // bisect E-W longitude
        double lonMid = (lonMin + lonMax) / 2;
        if (longitude >= lonMid) {
          idx = idx * 2 + 1;
          lonMin = lonMid;
        } else {
          idx = idx * 2;
          lonMax = lonMid;
        }
      } else {
        // bisect N-S latitude
        double latMid = (latMin + latMax) / 2;
        if (latitude >= latMid) {
          idx = idx * 2 + 1;
          latMin = latMid;
        } else {
          idx = idx * 2;
          latMax = latMid;
        }
      }
      evenBit = !evenBit;

      if (++bit == 5) {
        // 5 bits gives us a character: append it and start over
        geohash += _base32[idx];
        bit = 0;
        idx = 0;
      }
    }

    return geohash;
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
