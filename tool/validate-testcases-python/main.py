import sys
import geohash

for line in sys.stdin:
    rawInput = line.rstrip().split(', ')

    expected = {
        'Int': int(rawInput[0], 16),
        'Hash': rawInput[1],
    }

    lat = float(rawInput[2])
    lng = float(rawInput[3])

    observed = {
        'Int': geohash.encode_uint64(lat, lng),
        'Hash': geohash.encode(lat, lng),
    }

    if observed['Hash'] != expected['Hash']:
        print('Hash mismatch; expected: %s, observed: %s for {%s,%s}' % (
            expected['Hash'],
            observed['Hash'],
            lat,
            lng,
        ))

    if observed['Int'] != expected['Int']:
        print('Int mismatch; expected: %s, observed: %s for {%s,%s}' % (
            expected['Int'],
            observed['Int'],
            lat,
            lng,
        ))
