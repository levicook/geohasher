package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/mmcloughlin/geohash"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	for stdin.Scan() {
		var rawInput = strings.Split(stdin.Text(), ", ")
		var err error
		var lat float64
		var lng float64

		var expected struct {
			Int  uint64
			Hash string
		}

		var observed struct {
			Int  uint64
			Hash string
		}

		expected.Int, err = strconv.ParseUint(rawInput[0], 16, 64)
		if err != nil {
			log.Println(err)
			continue
		}

		expected.Hash = rawInput[1]

		lat, err = strconv.ParseFloat(rawInput[2], 64)
		if err != nil {
			log.Println(err)
			continue
		}

		lng, err = strconv.ParseFloat(rawInput[3], 64)
		if err != nil {
			log.Println(err)
			continue
		}

		observed.Hash = geohash.Encode(lat, lng)
		observed.Int = geohash.EncodeInt(lat, lng)

		if observed.Hash != expected.Hash {
			log.Printf("Hash mismatch; expected: %q, observed: %q for {%v,%v}", expected.Hash, observed.Hash, lat, lng)
		}

		if observed.Int != expected.Int {
			log.Printf("Int mismatch; expected: %q, observed: %q for {%v,%v}", expected.Int, observed.Int, lat, lng)
		}
	}

	if err := stdin.Err(); err != nil {
		log.Println(err)
	}
}
