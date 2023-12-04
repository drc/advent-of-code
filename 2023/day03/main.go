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
	var total int = 0
	lines := strings.Split(input, "\n")

	reNumber := regexp.MustCompile(`\d+`)
	reSymbol := regexp.MustCompile(`[^\d\.]`)

	for lineIndex, line := range lines {
		numberMatches := reNumber.FindAllStringSubmatch(line, -1)
		numMatchIndex := reNumber.FindAllStringIndex(line, -1)
		// fmt.Printf("line --> %#v\n\n", line)
		for _, numMatch := range numberMatches {
			fmt.Printf("%+v\n\n", numMatch)
			// check left
			if len(numMatchIndex) > 0 && numMatchIndex[0][0] != 0 {
				symbolMatch := reSymbol.FindAllStringSubmatch(string(line[numMatchIndex[0][0]-1]), -1)
				if len(symbolMatch) > 0 {
					validNumber, _ := strconv.Atoi(numMatch[0])
					total += validNumber
				}
			}
			// check right
			if numMatchIndex[0][1] < len(line) {
				fmt.Printf("substring --> %#v\n\n", string(line[numMatchIndex[0][1]]))
				symbolMatch := reSymbol.FindAllStringSubmatch(string(line[numMatchIndex[0][1]]), -1)
				fmt.Printf("symbolMatch --> %#v\n\n", symbolMatch)
				if len(symbolMatch) > 0 {
					validNumber, _ := strconv.Atoi(numMatch[0])
					total += validNumber
				}
			}
			// check top + diagonal
			// first row doesnt have a line above
			if lineIndex != 0 {
				lineAbove := lines[lineIndex-1]
				fmt.Printf("line above --> %#v\n", lineAbove)
			}
			// check bottom + diagonal
		}

	}

	return total
}

func part2(input string) int {
	return 1
}
