import 'dart:convert';
import 'dart:io';
import 'package:geohasher/geohasher.dart' as geohasher;

main() {
  stdin.transform(utf8.decoder).transform(LineSplitter()).listen((String line) {
    final rawInput = line.split(', ');
    final lat = double.parse(rawInput[0]);
    final lon = double.parse(rawInput[1]);
    final expected = rawInput[2];
    final observed = geohasher.encode(lat, lon);
    final expectedNeighbors = rawInput.sublist(3);
    final observedNeighbors = geohasher.neighbors(observed).values.toList();

    expectedNeighbors.sort();
    observedNeighbors.sort();

    if (observed != expected) {
      print(
        "expected: $expected\nobserved: $observed\nfor {$lat,$lon}",
      );
    }

    if (observedNeighbors.join(',') != expectedNeighbors.join(',')) {
      print(
        "expected: $expectedNeighbors\nobserved: $observedNeighbors\nfor {$lat,$lon}",
      );
    }
  });
}
