package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/mmcloughlin/geohash"
)

var (
	checkHash bool
	checkInt  bool
)

func init() {
	flag.BoolVar(&checkHash, "checkHash", true, "validate string hash")
	flag.BoolVar(&checkInt, "checkInt", true, "validate integer hash")
	flag.Parse()
}

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

		if checkInt {
			observed.Int = geohash.EncodeInt(lat, lng)
			expected.Int, err = strconv.ParseUint(rawInput[0], 16, 64)
			if err != nil {
				log.Println(err)
			}
			if observed.Int != expected.Int {
				fmt.Printf("Int mismatch; expected: %q, observed: %q for {%v,%v}\n", expected.Int, observed.Int, lat, lng)
			}
		}

		if checkHash {
			observed.Hash = geohash.Encode(lat, lng)
			expected.Hash = rawInput[1]
			if observed.Hash != expected.Hash {
				fmt.Printf("Hash mismatch; expected: %q, observed: %q for {%v,%v}\n", expected.Hash, observed.Hash, lat, lng)
			}
		}
	}

	if err := stdin.Err(); err != nil {
		log.Println(err)
	}
}
