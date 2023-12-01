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
		calibrationString := fmt.Sprintf("%s%s", digits[0], digits[len(digits)-1])
		calibration, _ := strconv.Atoi(calibrationString)
		total += calibration
	}

	return total
}

var (
	numberMap = map[string]int{
		"one":   1,
		"two":   2,
		"three": 3,
		"four":  4,
		"five":  5,
		"six":   6,
		"seven": 7,
		"eight": 8,
		"nine":  9,
	}
)

func part2(input string) int {
	var total int = 0
	var calibration int = 0
	var firstDigitNormalized int
	var lastDigitNormalized int
	lines := strings.Split(input, "\n")
	reForward := regexp.MustCompile(`\d|one|two|three|four|five|six|seven|eight|nine`)
	reBackward := regexp.MustCompile(`\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin`)

	for _, line := range lines {
		backwardsLine := reverse(line)
		calibrationMapForward := reForward.FindAllString(line, -1)
		calibrationMapBackward := reBackward.FindAllString(backwardsLine, -1)

		firstDigit := numberMap[calibrationMapForward[0]]
		lastDigit := numberMap[reverse(calibrationMapBackward[0])]

		if firstDigit == 0 {
			firstDigitNormalized, _ = strconv.Atoi(calibrationMapForward[0])
		} else {
			firstDigitNormalized = firstDigit
		}
		if lastDigit == 0 {
			lastDigitNormalized, _ = strconv.Atoi(reverse(calibrationMapBackward[0]))
		} else {
			lastDigitNormalized = lastDigit
		}

		calibration, _ = strconv.Atoi(fmt.Sprintf("%d%d", firstDigitNormalized, lastDigitNormalized))

		total += calibration
	}
	return total
	// 54970
}

func reverse(s string) string {
	rune_arr := []rune(s)
	var rev []rune
	for i := len(rune_arr) - 1; i >= 0; i-- {
		rev = append(rev, rune_arr[i])
	}
	return string(rev)
}
