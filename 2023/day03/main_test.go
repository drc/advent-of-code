package main

import (
	"testing"
)

var example string = `467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..`

func Test_part1(t *testing.T) {
	expected := 4361
	t.Run("Test Part 1", func(t *testing.T) {
		if got := part1(example); got != expected {
			t.Errorf("part1() = %v, want %v", got, expected)
		}
	})
}

func Test_part2(t *testing.T) {
	t.Run("Test Part 2", func(t *testing.T) {
		if got := part2(example); got != 1 {
			t.Errorf("part2() = %v, want %v", got, 0)
		}
	})
}
