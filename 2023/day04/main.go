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

	for _, line := range lines {
		lineTotal := 0
		winners, myNumbers, _ := unpackLotteryTicket(line)
		for _, win := range winners {
			for _, my := range myNumbers {
				if win == my {
					if lineTotal == 0 {
						lineTotal++
					} else {
						lineTotal *= 2
					}
				}
			}
		}
		total += lineTotal
	}

	return total
}

func unpackLotteryTicket(line string) ([]int, []int, string) {
	reCard := regexp.MustCompile(`(Card\s{1,3}\d{1,3})(.+)`)
	reDigits := regexp.MustCompile(`\d{1,3}`)
	card := reCard.FindStringSubmatch(line)
	cardMap := strings.Split(card[2][2:len(card[2])], " | ")
	winnerDigits := reDigits.FindAllString(cardMap[0], -1)
	var winners = make([]int, len(winnerDigits))
	for i, num := range winnerDigits {
		winners[i], _ = strconv.Atoi(num)
	}
	pickedDigits := reDigits.FindAllString(cardMap[1], -1)
	var picked = make([]int, len(pickedDigits))
	for i, num := range pickedDigits {
		picked[i], _ = strconv.Atoi(num)
	}
	return winners, picked, card[1]
}

func part2(input string) int {
	var total int = 0

	reCardNumber := regexp.MustCompile(`\d{1,3}`)

	lines := strings.Split(input, "\n")
	winnerMap := make(map[int]int, len(lines))

	for _, line := range lines {
		winsOnLine := 0
		winners, myNumbers, card := unpackLotteryTicket(line)
		for _, win := range winners {
			for _, my := range myNumbers {
				if win == my {
					winsOnLine++
				}
			}
		}
		cardNumberString := reCardNumber.FindString(card)
		currentCard, _ := strconv.Atoi(cardNumberString)
		numCopies := 1
		if winnerMap[currentCard] > 1 {
			numCopies = winnerMap[currentCard]
		}
		for i := 0; i <= winsOnLine; i++ {
			for c := 0; c < numCopies; c++ {
				winnerMap[currentCard+i]++
			}
		}
	}
	for _, copies := range winnerMap {
		total += copies
	}

	return total
}
