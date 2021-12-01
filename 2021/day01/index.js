import { readInput, readSampleInput } from "../../utils/readInput.mjs";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n").map(val => parseInt(val));

const partOne = data => {
    return data.reduce(
        (acc, val) => {
            if (acc.prev !== null && acc.prev < val) {
                acc.count++;
            }
            acc.prev = val;
            return acc;
        },
        { prev: null, count: 0 }
    ).count;
};

const answer = partOne(raw);

// assert.strictEqual(answer, 7);

console.log(`Part 1 answer: ${answer}`);
