import { readInput, readSampleInput } from "../../utils/readInput.mjs";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

const getGammaRate = data => {
    const dataLength = data.length;
    const charLength = data[0].length;
    const ones = new Array(charLength).fill(0);
    for (let i = 0; i < dataLength; i++) {
        for (let j = 0; j < charLength; j++) {
            ones[j] += data[i][j] === "1" ? 1 : 0;
        }
    }

    return ones.map(one => (one > dataLength / 2 ? "1" : "0")).join("");
};

const sampleGammaBinary = getGammaRate(sample);
const sampleGamma = parseInt(sampleGammaBinary, 2);
assert.strictEqual(sampleGamma, 22);

const getEpsilonRate = data => {
    return getGammaRate(data)
        .split("")
        .map(b => 1 - b)
        .join("");
};

const sampleEpsilonBinary = getEpsilonRate(sample);
const sampleEpsilon = parseInt(sampleEpsilonBinary, 2);
assert.strictEqual(sampleEpsilon, 9);

const partOne = data => {
    const gamma = getGammaRate(data);
    const epsilon = getEpsilonRate(data);
    return parseInt(gamma, 2) * parseInt(epsilon, 2);
};

const answer = partOne(sample);
assert.strictEqual(answer, 198);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

// const partTwo = data => {};

// const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 900);

// const finalAnswer2 = partTwo(raw);
// console.log(`Part 2 answer: ${finalAnswer2}`);
