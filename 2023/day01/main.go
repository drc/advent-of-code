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
		fmt.Println("Output:", ans)
	} else {
		ans := part2(input)
		fmt.Println("Output:", ans)
	}
}

func part1(input string) int {
	var total int
	lines := strings.Split(input, "\n")
	re, err := regexp.Compile(`\d`)
	if err != nil {
		panic(err)
	}

	for _, line := range lines {
		digits := re.FindAllString(line, -1)
		calibration_string := fmt.Sprintf("%s%s", digits[0], digits[len(digits)-1])
		calibration, _ := strconv.Atoi(calibration_string)
		total += calibration
	}

	return total
}

func part2(input string) int {
	return 1
}
