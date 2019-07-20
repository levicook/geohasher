library geohash;

import 'dart:math';

const _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

String encode(final double lat, final double lon, {final int precision = 12}) {
  return LatLon(lat, lon).toGeoHash(precision: precision);
}

LatLon decode(final String hash) {
  return LatLon.fromGeoHash(hash);
}

class LatLon {
  final double latitude;
  final double longitude;

  const LatLon(final this.latitude, final this.longitude)
      : assert(latitude != null && latitude >= -90 && latitude <= 90),
        assert(longitude != null && latitude >= -180 && latitude <= 180);

  factory LatLon.fromGeoHash(final String hash) {
    return _bounds(hash).center;
  }

  String toGeoHash({final int precision = 12}) {
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
  bool operator ==(final Object other) {
    if (identical(other, this)) return true;
    return other is LatLon &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    return latitude.hashCode ^ longitude.hashCode;
  }
}

_Bounds _bounds(String geohash) {
  bool evenBit = true;
  double latMin = -90;
  double latMax = 90;
  double lonMin = -180;
  double lonMax = 180;

  for (var i = 0; i < geohash.length; i++) {
    final chr = geohash[i];
    final idx = _base32.indexOf(chr);
    if (idx == -1) throw FormatException('Invalid geohash');

    for (var n = 4; n >= 0; n--) {
      final bitN = idx >> n & 1;
      if (evenBit) {
        // longitude
        final lonMid = (lonMin + lonMax) / 2;
        if (bitN == 1) {
          lonMin = lonMid;
        } else {
          lonMax = lonMid;
        }
      } else {
        // latitude
        final latMid = (latMin + latMax) / 2;
        if (bitN == 1) {
          latMin = latMid;
        } else {
          latMax = latMid;
        }
      }
      evenBit = !evenBit;
    }
  }
  final northEast = LatLon(latMax, lonMax);
  final southWest = LatLon(latMin, lonMin);
  return _Bounds(northEast, southWest);
}

class _Bounds {
  final LatLon northEast;
  final LatLon southWest;

  _Bounds(this.northEast, this.southWest);

  LatLon get center {
    // now just determine the centre of the cell...
    double latMin = southWest.latitude, lonMin = southWest.longitude;
    double latMax = northEast.latitude, lonMax = northEast.longitude;

    // cell centre
    double lat = (latMin + latMax) / 2;
    double lon = (lonMin + lonMax) / 2;

    lat = _round(lat, (2 - log(latMax - latMin) / ln10).floor());
    lon = _round(lon, (2 - log(lonMax - lonMin) / ln10).floor());

    return LatLon(lat, lon);
  }
}

double _round(double v, int precision) {
  double mod = pow(10.0, precision);
  return ((v * mod).round().toDouble() / mod);
}
