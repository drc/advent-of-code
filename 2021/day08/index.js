import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

// 0 - 9
const map = [
    ["a", "b", "c", "e", "f", "g"],
    ["c", "f"],
    ["a", "c", "d", "e", "g"],
    ["a", "c", "d", "f", "g"],
    ["b", "c", "d", "f"],
    ["a", "b", "d", "f", "g"],
    ["a", "b", "d", "e", "f", "g"],
    ["a", "c", "f"],
    ["a", "b", "c", "d", "e,", "f", "g"],
    ["a", "b", "c", "d", "f", "g"],
];

const parseInput = data => {
    return data.map(line => {
        const [input, output] = line
            .split("|")
            .map(pair => pair.trim())
            .map(pair => pair.split(" ").sort());
        return { input, output };
    });
};

const easy = map.reduce((acc, val, idx, arr) => {
    const count = arr.map(num => num.length);
    const el = count.splice(idx, 1)[0];
    if (!count.includes(el)) {
        acc.push(val);
    }
    return acc;
}, []);

const getDigitCount = (data, matchingArray) => {
    return data.reduce((acc, val) => {
        const output = val.output;
        for (let conf of output) {
            const match = matchingArray.filter(el => {
                return el.length === conf.length;
            });
            if (match.length > 0) {
                acc += match.length;
            }
        }
        return acc;
    }, 0);
};

const partOne = data => {
    const parsedData = parseInput(data);
    const count = getDigitCount(parsedData, easy);
    return count;
};

const answer = partOne(sample);
assert.strictEqual(answer, 26);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {};

const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 230);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
