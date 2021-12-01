import { readInput, readSampleInput } from "../../utils/readInput.mjs";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n").map(val => parseInt(val));

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

const answer = partOne(sample);
assert.strictEqual(answer, 7);

const finalAnswer = partOne(raw);

console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    return data.reduce(
        (acc, val, index, arr) => {
            if (!arr[index + 2]) return acc;
            const roll = val + arr[index + 1] + arr[index + 2];
            if (acc.prev !== null && acc.prev < roll) {
                acc.count++;
            }
            acc.prev = roll;
            return acc;
        },
        { prev: null, count: 0 }
    ).count;
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 5);

const finalAnswer2 = partTwo(raw);


console.log(`Part 2 answer: ${finalAnswer2}`);
