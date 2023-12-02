package main

import (
	_ "embed"
	"flag"
	"fmt"
	"regexp"
	"strconv"
	"strings"
)

//go:embed input.txt
var input string

func init() {
	input = strings.TrimRight(input, "\n")
	if len(input) == 0 {
		panic("empty input.txt file")
	}
}

func main() {
	var part int
	flag.IntVar(&part, "part", 1, "part 1 or 2")
	flag.Parse()
	fmt.Println("Running part", part)

	if part == 1 {
		ans := part1(input)
		// > 2688
		fmt.Println("Output:", ans)
	} else {
		ans := part2(input)
		fmt.Println("Output:", ans)
	}
}

var (
	bag = Set{
		red:   12,
		green: 13,
		blue:  14,
	}
)

type Set struct {
	red   int
	green int
	blue  int
}

func part1(input string) int {
	var total int = 0
	lines := strings.Split(input, "\n")

	for _, line := range lines {
		var isValid bool = true
		gameID, sets := unpackSets(line)
		games := convToSet(sets)

		for _, game := range games {
			if !game.valid() {
				// invalid game
				isValid = false
				break
			}
		}
		if isValid {
			total += gameID
		}
	}
	return total
}

func unpackSets(line string) (int, []string) {
	slice := strings.Split(line, ":")
	re := regexp.MustCompile(`Game (\d{1,3})`)
	gameID, _ := strconv.Atoi(re.FindStringSubmatch(slice[0])[1])
	return gameID, strings.Split(slice[1], ";")
}

func convToSet(sets []string) []Set {
	var setlist []Set
	re := regexp.MustCompile(`(\d{1,3})\s(red|green|blue)`)

	for _, group := range sets {
		var currentSet Set
		pairs := re.FindAllStringSubmatch(group, -1)
		for _, pair := range pairs {
			cubes, color := unpackPair(pair)
			switch color {
			case "red":
				currentSet.red = cubes
			case "green":
				currentSet.green = cubes
			case "blue":
				currentSet.blue = cubes
			}
		}
		setlist = append(setlist, currentSet)
	}
	return setlist
}

func unpackPair(pair []string) (int, string) {
	cubes, _ := strconv.Atoi(pair[1])
	return cubes, pair[2]
}

func (s Set) valid() bool {
	return s.red <= bag.red && s.green <= bag.green && s.blue <= bag.blue
}

func part2(input string) int {
	return 1
}
