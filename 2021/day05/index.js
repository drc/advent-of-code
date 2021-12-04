import { readInput, readSampleInput } from "../../utils/readInput.mjs";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

const partOne = data => {};

const answer = partOne(sample);
// assert.strictEqual(answer, 198);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {};

const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 230);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
