package main

import (
	"testing"
)

var example string = `1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet`

var example2 string = `two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen`

func Test_part1(t *testing.T) {
	expected := 142
	t.Run("Test Part 1", func(t *testing.T) {
		if got := part1(example); got != expected {
			t.Errorf("part1() = %v, want %v", got, expected)
		}
	})
}

func Test_part2(t *testing.T) {
	expected := 281
	t.Run("Test Part 2", func(t *testing.T) {
		if got := part2(example2); got != expected {
			t.Errorf("part2() = %v, want %v", got, expected)
		}
	})
}
