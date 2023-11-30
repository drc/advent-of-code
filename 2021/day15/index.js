import { readInput, readSampleInput } from "../../utils/readInput.js";
import Spot from "./Spot.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n").map((line, row) => {
    return line.split("").map((val, col) => {
        return new Spot(col, row, +val);
    });
});

const rawData = readInput();
const raw = rawData.split("\n").map((line, row) => {
    return line.split("").map((val, col) => {
        return new Spot(col, row, +val);
    });
});

const heruistic = (a, b) => {
    return Math.abs(a.val - b.val);
};

const partOne = data => {
    const start = data[0][0];
    const end = data[data.length - 1][data[0].length - 1];
    const openSet = [];
    openSet.push(start);
    const closedSet = [];

    while(openSet.length > 0) {
        let winner = 0;
        
    }
};

const answer = partOne(sample);
// assert.strictEqual(answer, 198);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {};

const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 230);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
