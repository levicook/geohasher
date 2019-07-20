import 'dart:math';

import 'package:args/args.dart';
import 'package:geohash/geohash.dart' as geohash;

final rand = Random.secure();

main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'trials',
      defaultsTo: '4096',
      help: 'number of test cases to generate',
    )
    ..addOption(
      'precision',
      defaultsTo: '9',
      help: 'lag/lng precision (number of floating point digits)',
    );

  final args = parser.parse(arguments);
  final trials = int.parse(args['trials']);
  final precision = int.parse(args['precision']);

  for (var i = 0; i < trials; i++) {
    final lat = round(uniform(-90, 90), precision);
    final lng = round(uniform(-180, 180), precision);
    final hash = geohash.encode(lat, lng);
    print(', $hash, $lat, $lng');
  }
}

double uniform(double min, double max) {
  return min + rand.nextDouble() * (max - min);
}

double round(double v, int precision) {
  double mod = pow(10.0, precision);
  return ((v * mod).round().toDouble() / mod);
}
