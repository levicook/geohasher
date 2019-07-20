import sys
import geohash

for line in sys.stdin:
    rawInput = line.rstrip().split(', ')
    lat = float(rawInput[0])
    lon = float(rawInput[1])
    expected = rawInput[2]
    observed = geohash.encode(lat, lon)

    if observed != expected:
        print('mismatch; expected: %s, observed: %s for {%s,%s}' % (
            expected,
            observed,
            lat,
            lon,
        ))
