package main

import (
	"flag"
	"fmt"
	"math"
	"math/rand"
	"time"

	"github.com/mmcloughlin/geohash"
)

var (
	trials    int
	precision int
)

func init() {
	rand.Seed(time.Now().UnixNano())
	flag.IntVar(&trials, "trials", 4096, "number of test cases to generate")
	flag.IntVar(&precision, "precision", 9, "lag/lng precision (number of floating point digits)")
	flag.Parse()
}

func main() {
	for i := 1; i < trials; i++ {
		lat := round(uniform(-90, 90))
		lng := round(uniform(-180, 180))
		fmt.Printf(
			"%016x, %v, %v, %v\n",
			geohash.EncodeInt(lat, lng),
			geohash.Encode(lat, lng),
			lat,
			lng,
		)
	}
}

func uniform(max, min float64) float64 {
	return min + rand.Float64()*(max-min)
}

func round(v float64) float64 {
	p := math.Pow10(precision)
	return math.Round(v*p) / p
}
