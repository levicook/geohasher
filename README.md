
geohash
=======

Dart port of geohash; provides encoding and decoding of string geohashes.

Original work and additional ports at:
https://www.movable-type.co.uk/scripts/geohash.html


testing
-------

The primary validation strategy for this port was checking it against other implementations.

These tools confirm it plays nice with Go:
dart tool/generate-testcases-dart/main.dart | go run tool/validate-testcases-go/main.go
go run tool/generate-testcases-go/main.go | dart tool/validate-testcases-dart/main.dart

These tools confirm it plays nice with Python:
dart tool/generate-testcases-dart/main.dart | python tool/validate-testcases-python/main.py
python tool/generate-testcases-python/main.py | dart tool/validate-testcases-dart/main.dart

These tools confirm it's self consistent:
dart tool/generate-testcases-dart/main.dart | dart tool/validate-testcases-dart/main.dart
