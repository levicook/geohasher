import sys
import geohash

for line in sys.stdin:
    rawInput = line.rstrip().split(', ')
    lat = float(rawInput[0])
    lon = float(rawInput[1])
    expected = rawInput[2]
    observed = geohash.encode(lat, lon)
    expectedNeighbors = rawInput[3:]
    observedNeighbors = geohash.neighbors(observed)

    expectedNeighbors.sort()
    observedNeighbors.sort()

    if observed != expected:
        print('expected: %s\nobserved: %s\nfor {%s,%s}' % (
            expected,
            observed,
            lat,
            lon,
        ))

    if observedNeighbors != expectedNeighbors:
        print('expected: %s\nobserved: %s\nfor {%s,%s}' % (
            expectedNeighbors,
            observedNeighbors,
            lat,
            lon,
        ))
