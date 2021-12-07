import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";
import { tmpdir } from "os";

const rawSample = readSampleInput();
const sample = rawSample.split(",").map(Number);

const rawData = readInput();
const raw = rawData.split(",").map(Number);

const walk = (data, depth) => {
    return data.reduce((acc, val) => {
        return acc + Math.abs(val - depth);
    }, 0);
};

const biggest = data => {
    return data.reduce((acc, val) => {
        return acc > val ? acc : val;
    }, 0);
};

const walkWithFuel = (data, depth) => {
    const dist = data.map(num => Math.abs(num - depth));
    return dist.reduce((acc, val) => {
        return acc + (val * (val + 1)) / 2;
    }, 0);
};

const partOne = data => {
    let smallest = Infinity;
    for (let i = 1; i <= biggest(data); i++) {
        let temp = walk(data, i);
        smallest = smallest < temp ? smallest : temp;
    }
    return smallest;
};

const answer = partOne(sample);
assert.strictEqual(answer, 37);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    let smallest = Infinity;
    for(let i = 1; i <= biggest(data); i++) {
        let temp = walkWithFuel(data, i);
        smallest = smallest < temp ? smallest : temp;
    }
    return smallest;
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 168);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
