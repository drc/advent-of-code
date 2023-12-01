package main

import (
	"testing"
)

var example string = `hot
damn`

func Test_part1(t *testing.T) {
	t.Run("Test Part 1", func(t *testing.T) {
		if got := part1(example); got != 0 {
			t.Errorf("part1() = %v, want %v", got, 0)
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
