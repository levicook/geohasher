package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/mmcloughlin/geohash"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	for stdin.Scan() {
		rawInput := strings.Split(stdin.Text(), ", ")
		lat, _ := strconv.ParseFloat(rawInput[0], 64)
		lon, _ := strconv.ParseFloat(rawInput[1], 64)
		expected := rawInput[2]
		observed := geohash.Encode(lat, lon)
		if observed != expected {
			fmt.Printf("mismatch; expected: %q, observed: %q for {%v,%v}\n", expected, observed, lat, lon)
		}
	}

	if err := stdin.Err(); err != nil {
		log.Println(err)
	}
}
