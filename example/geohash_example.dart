import 'package:geohash/geohash.dart';

void main() {
  // Run this with assertions enabled:
  // $ dart --enable-asserts example/geohash_example.dart
  //        ^^^^^^^^^^^^^^^^

  final lat = 33.85679995, lon = 151.21530013;

  final hash = encode(lat, lon);
  assert(hash == 'xq588grw5uun');

  assert(encode(lat, lon, precision: 2) == 'xq');
  assert(encode(lat, lon, precision: 4) == 'xq58');

  final latLon = decode(hash);
  assert(lat == latLon.latitude, '$lat, $latLon');
  assert(lon == latLon.longitude, '$lon, $latLon');
  assert(latLon == latLon, 'LatLon implements ==');
  assert(latLon.hashCode == latLon.hashCode, 'LatLon implements hashCode');

  assert(neighbor(hash, Direction.north) == 'xq588grw5uup');
  assert(neighbor(hash, Direction.northEast) == 'xq588grw5uur');
  assert(neighbor(hash, Direction.southEast) == 'xq588grw5uum');
  assert(neighbor(hash, Direction.south) == 'xq588grw5uuj');
  assert(neighbor(hash, Direction.southWest) == 'xq588grw5ugv');
  assert(neighbor(hash, Direction.west) == 'xq588grw5ugy');
  assert(neighbor(hash, Direction.northWest) == 'xq588grw5ugz');
}
