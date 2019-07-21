import 'package:test/test.dart';
import 'package:geohasher/geohasher.dart';

main() {
  test('encode', () {
    expect(
      'dqcw4bnrs6s7',
      encode(39.0247389581054, -76.5110040642321, precision: 12),
    );
    expect(
      'dqcw4bnrs6',
      encode(39.0247389581054, -76.5110040642321, precision: 10),
    );
    expect(
      '6gkzmg1u',
      encode(-25.427, -49.315, precision: 8),
    );
    expect(
      'ezs42',
      encode(42.60498046875, -5.60302734375, precision: 5),
    );
  });

  test('decode', () {
    expect(
      decode('dqcw4bnrs6s7'),
      LatLon(39.02473896, -76.51100406),
    );

    expect(
      decode('9q8yyz8pg3bb'),
      LatLon(37.79156202, -122.39854099),
    );
    expect(
      decode('9Q8YYZ8PG3BB'),
      LatLon(37.79156202, -122.39854099),
    );

    expect(
      decode('ezs42'),
      LatLon(42.605, -5.603),
    );

    expect(
      decode('6gkzwgjzn820'),
      LatLon(-25.38270808, -49.2655061),
    );
    expect(
      decode('6gkzwgjz'),
      LatLon(-25.38262, -49.26561),
    );

    expect(
      decode('9q9p658642g7', precision: 4),
      LatLon(37.8565, -122.2554),
    );
    expect(
      decode('9q9p658642g7', precision: 5),
      LatLon(37.85649, -122.25541),
    );
    expect(
      decode('9q9p658642g7', precision: 6),
      LatLon(37.856488, -122.255415),
    );
  });

  test('neighbors', () {
    expect(neighbor('dqcjqc', Direction.north), 'dqcjqf');
    expect(neighbor('dqcjqc', Direction.northEast), 'dqcjr4');
    expect(neighbor('dqcjqc', Direction.east), 'dqcjr1');
    expect(neighbor('dqcjqc', Direction.southEast), 'dqcjr0');
    expect(neighbor('dqcjqc', Direction.south), 'dqcjqb');
    expect(neighbor('dqcjqc', Direction.southWest), 'dqcjq8');
    expect(neighbor('dqcjqc', Direction.west), 'dqcjq9');
    expect(neighbor('dqcjqc', Direction.northWest), 'dqcjqd');
  });
}
