import argparse
import geohash
from random import uniform

parser = argparse.ArgumentParser()

parser.add_argument(
    '--trials', help='number of test cases to generate',
    default=4096, nargs='?', type=int)

parser.add_argument(
    '--precision', help='lag/lon precision (number of floating point digits)',
    default=9, nargs='?', type=int)

args = parser.parse_args()

for i in range(args.trials):
    lat = round(uniform(-90, 90), args.precision)
    lon = round(uniform(-180, 180), args.precision)
    hash = geohash.encode(lat, lon)
    print('%s, %s, %s' % (lat, lon, hash))
