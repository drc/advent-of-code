import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n").map(l => l.split("").map(Number));

const rawData = readInput();
const raw = rawData.split("\n").map(l => l.split("").map(Number));

const mod = (n, m) => {
    return ((n % m) + m) % m;
};

const checkUp = (data, row, col, wrap) => {
    if (wrap || row - 1 > -1) {
        return data[mod(row - 1, data.length)][col];
    }
    return 99;
};

const checkDown = (data, row, col, wrap) => {
    if (wrap || row + 1 <= data.length - 1) {
        return data[mod(row + 1, data.length)][col];
    }
    return 99;
};

const checkLeft = (data, row, col, wrap) => {
    if (wrap || col - 1 > -1) {
        return data[row][mod(col - 1, data[row].length)];
    }
    return 99;
};

const checkRight = (data, row, col, wrap) => {
    if (wrap || col + 1 <= data[row].length - 1) {
        return data[row][mod(col + 1, data[row].length)];
    }
    return 99;
};

console.table(sample);

const partOne = data => {
    const lowers = [];
    for (let row = 0; row < data.length; row++) {
        for (let col = 0; col < data[row].length; col++) {
            const up = checkUp(data, row, col, false);
            const down = checkDown(data, row, col, false);
            const left = checkLeft(data, row, col, false);
            const right = checkRight(data, row, col, false);
            const el = data[row][col];

            if (el < up && el < down && el < left && el < right) {
                lowers.push(el);
            }
        }
    }
    return lowers.reduce((acc, val) => acc + (1 + val), 0);
};

const answer = partOne(sample);
assert.strictEqual(answer, 15);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {};

const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 1134);

// const finalAnswer2 = partTwo(raw);
// console.log(`Part 2 answer: ${finalAnswer2}`);
