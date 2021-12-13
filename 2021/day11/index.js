import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";
import Octopus from "./Octo.js";

const rawSample = readSampleInput();
const sample = rawSample.split("\n").map((l, y) =>
    l.split("").map((val, x) => {
        return new Octopus(val, y, x);
    })
);

const rawData = readInput();
const raw = rawData.split("\n").map((l, y) =>
    l.split("").map((val, x) => {
        return new Octopus(val, y, x);
    })
);

const inc = data => {
    const flashed = [];
    for (const row of data) {
        for (const octo of row) {
            octo.flash = false;
            octo.increment();
            if (octo.flash) {
                flashed.push(octo);
            }
        }
    }
    return flashed;
};

const getAdjacent = (data, octo) => {
    const adjacent = [];
    const direction = [
        { row: -1, col: -1 },
        { row: -1, col: 0 },
        { row: -1, col: 1 },
        { row: 0, col: -1 },
        { row: 0, col: 1 },
        { row: 1, col: -1 },
        { row: 1, col: 0 },
        { row: 1, col: 1 },
    ];
    for (const dir of direction) {
        const row = octo.row + dir.row;
        const col = octo.col + dir.col;
        if (data[row] === undefined) continue;
        if (data[row][col] === undefined) continue;
        adjacent.push(data[row][col]);
    }
    return adjacent;
};

const handleFlash = (data, flashed) => {
    let count = 0;
    while (flashed.length > 0) {
        const first = flashed.shift();
        for (const adjacent of getAdjacent(data, first)) {
            if (adjacent.flash) continue;
            adjacent.increment();
            if (adjacent.flash) {
                flashed.push(adjacent);
            }
        }
        count++;
    }
    return count;
};

const partOne = data => {
    let count = 0;
    for (let i = 0; i < 100; i++) {
        const flash = inc(data);
        count += handleFlash(data, flash);
    }
    return count;
};

// const answer = partOne(sample);
// assert.strictEqual(answer, 1656);

// const finalAnswer = partOne(raw);
// console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    let count = 0;
    // for (let i = 0; i < 100000; i++) {
    while(true) {
        const flash = inc(data);
        handleFlash(data, flash);
        count++;
        console.log(data.flatMap(r => r));
        if (data.flatMap(r => r).every(o => o.val === 0)) {
            return count;
        }
    }
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 195);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
