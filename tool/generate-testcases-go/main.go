package main

import (
	"flag"
	"fmt"
	"math"
	"math/rand"
	"strings"
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
	flag.IntVar(&precision, "precision", 9, "lag/lon precision (number of floating point digits)")
	flag.Parse()
}

func main() {
	for i := 0; i < trials; i++ {
		lat := round(uniform(-90, 90))
		lon := round(uniform(-180, 180))
		hash := geohash.Encode(lat, lon)
		neighbors := geohash.Neighbors(hash)
		fmt.Printf(
			"%v, %v, %v, %v\n",
			lat,
			lon,
			hash,
			strings.Join(neighbors, ", "),
		)
	}
}

func uniform(min, max float64) float64 {
	return min + rand.Float64()*(max-min)
}

func round(v float64) float64 {
	p := math.Pow10(precision)
	return math.Round(v*p) / p
}
