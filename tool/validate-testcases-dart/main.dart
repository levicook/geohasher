import 'dart:convert';
import 'dart:io';
import 'package:geohash/geohash.dart' as geohash;

main() {
  stdin.transform(utf8.decoder).transform(LineSplitter()).listen((String line) {
    final rawInput = line.split(', ');
    final lat = double.parse(rawInput[2]);
    final lon = double.parse(rawInput[3]);

    final expected = rawInput[1];
    final observed = geohash.encode(lat, lon);

    if (observed != expected) {
      print(
        "mismatch; expected: $expected, observed: $observed for {$lat,$lon}",
      );
    }
  });
}
