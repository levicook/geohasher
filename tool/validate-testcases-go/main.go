package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"reflect"
	"sort"
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
		expectedNeighbors := rawInput[3:]
		observedNeighbors := geohash.Neighbors(observed)

		sort.Strings(expectedNeighbors)
		sort.Strings(observedNeighbors)

		if observed != expected {
			fmt.Printf("expected: %q\nobserved: %q\nfor {%v,%v}\n", expected, observed, lat, lon)
		}

		if !reflect.DeepEqual(expectedNeighbors, observedNeighbors) {
			fmt.Printf("expected: %q\nobserved: %q\nfor {%v,%v}\n", expectedNeighbors, observedNeighbors, lat, lon)
		}
	}

	if err := stdin.Err(); err != nil {
		log.Println(err)
	}
}
