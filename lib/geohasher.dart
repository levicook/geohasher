library geohash;

import 'dart:math';

const _base32 = '0123456789bcdefghjkmnpqrstuvwxyz';

/// Encode a pair of latitude and longitude values into a geohash.
String encode(final double lat, final double lon, {final int precision = 12}) {
  return LatLon(lat, lon).toGeoHash(precision: precision);
}

/// Decode a hash string into a LatLon (pair of latitude and longitude values).
LatLon decode(final String hash, {final int precision = 12}) {
  return LatLon.fromGeoHash(hash, precision: precision);
}

/// Find the neighbor of a geohash string in certain direction.
String neighbor(final String hash, final Direction direction) {
  switch (direction) {
    case Direction.northEast:
      return _adjacent(_adjacent(hash, Direction.north), Direction.east);
    case Direction.southEast:
      return _adjacent(_adjacent(hash, Direction.south), Direction.east);
    case Direction.southWest:
      return _adjacent(_adjacent(hash, Direction.south), Direction.west);
    case Direction.northWest:
      return _adjacent(_adjacent(hash, Direction.north), Direction.west);
    default:
      return _adjacent(hash, direction);
  }
}

/// Find all 8 geohash neighbors (each direction) of a geohash string.
Map<Direction, String> neighbors(final String hash) {
  return {
    Direction.north: neighbor(hash, Direction.north),
    Direction.northEast: neighbor(hash, Direction.northEast),
    Direction.east: neighbor(hash, Direction.east),
    Direction.southEast: neighbor(hash, Direction.southEast),
    Direction.south: neighbor(hash, Direction.south),
    Direction.southWest: neighbor(hash, Direction.southWest),
    Direction.west: neighbor(hash, Direction.west),
    Direction.northWest: neighbor(hash, Direction.northWest),
  };
}

/// Cardinal and intercardinal directions
enum Direction {
  north,
  northEast,
  east,
  southEast,
  south,
  southWest,
  west,
  northWest
}

/// Latitude/Longitude coordinate pair
class LatLon {
  final double latitude;
  final double longitude;

  const LatLon(final this.latitude, final this.longitude)
      : assert(latitude != null && latitude >= -90 && latitude <= 90),
        assert(longitude != null && latitude >= -180 && latitude <= 180);

  factory LatLon.fromGeoHash(final String hash, {final int precision = 12}) {
    return _bounds(hash).center.round(precision);
  }

  LatLon round(int precision) {
    return LatLon(
      _round(latitude, precision),
      _round(longitude, precision),
    );
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

  @override
  String toString() {
    return '$latitude, $longitude';
  }
}

_Bounds _bounds(String geohash) {
  geohash = geohash.toLowerCase();

  bool evenBit = true;
  double latMin = -90;
  double latMax = 90;
  double lonMin = -180;
  double lonMax = 180;

  for (var i = 0; i < geohash.length; i++) {
    final chr = geohash[i];
    final idx = _base32.indexOf(chr);
    if (idx == -1) throw FormatException('Invalid geohash $geohash');

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
    final latMin = southWest.latitude;
    final lonMin = southWest.longitude;
    final latMax = northEast.latitude;
    final lonMax = northEast.longitude;

    // cell centre
    double lat = (latMin + latMax) / 2;
    double lon = (lonMin + lonMax) / 2;

    // round to close to centre without excessive precision: ⌊2-log10(Δ°)⌋ decimal places
    lat = _round(lat, (2 - log(latMax - latMin) / ln10).floor());
    lon = _round(lon, (2 - log(lonMax - lonMin) / ln10).floor());

    return LatLon(lat, lon);
  }
}

String _adjacent(
  final String hash,
  final Direction direction,
) {
  assert(direction == Direction.north ||
      direction == Direction.east ||
      direction == Direction.south ||
      direction == Direction.west);

  const neighbors = {
    Direction.north: [
      'p0r21436x8zb9dcf5h7kjnmqesgutwvy',
      'bc01fg45238967deuvhjyznpkmstqrwx'
    ],
    Direction.south: [
      '14365h7k9dcfesgujnmqp0r2twvyx8zb',
      '238967debc01fg45kmstqrwxuvhjyznp'
    ],
    Direction.east: [
      'bc01fg45238967deuvhjyznpkmstqrwx',
      'p0r21436x8zb9dcf5h7kjnmqesgutwvy'
    ],
    Direction.west: [
      '238967debc01fg45kmstqrwxuvhjyznp',
      '14365h7k9dcfesgujnmqp0r2twvyx8zb'
    ],
  };

  const border = {
    Direction.north: ['prxz', 'bcfguvyz'],
    Direction.south: ['028b', '0145hjnp'],
    Direction.east: ['bcfguvyz', 'prxz'],
    Direction.west: ['0145hjnp', '028b'],
  };

  final lastCh = hash[hash.length - 1]; // last character of hash

  // hash without last character
  String parent = hash.substring(0, hash.length - 1);
  final type = hash.length % 2;

  // check for edge-cases which don't share common prefix
  if (border[direction][type].indexOf(lastCh) != -1 && parent != '') {
    parent = _adjacent(parent, direction);
  }

  // append letter for direction to parent
  return parent + _base32[neighbors[direction][type].indexOf(lastCh)];
}

double _round(double v, int precision) {
  double mod = pow(10.0, precision);
  return ((v * mod).round().toDouble() / mod);
}
