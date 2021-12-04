import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";
import { accessSync } from "fs";

const rawSample = readSampleInput();
const sample = rawSample.split("\n").map(line => {
    const [dir, count] = line.split(/\s/);
    return { dir, count: parseInt(count) };
});

const rawData = readInput();
const raw = rawData.split("\n").map(line => {
    const [dir, count] = line.split(/\s/);
    return { dir, count: parseInt(count) };
});

const partOne = data => {
    var obj = { h: 0, d: 0 };
    return data.reduce((acc, val) => {
        switch (val.dir) {
            case "forward":
                obj.h += val.count;
                break;
            case "up":
                obj.d -= val.count;
                break;
            case "down":
                obj.d += val.count;
                break;
        }
        return obj.h * obj.d;
    }, 0);
};

const answer = partOne(sample);
assert.strictEqual(answer, 150);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    var obj = { h: 0, d: 0, a: 0 };
    return data.reduce((acc, val) => {
        switch (val.dir) {
            case "forward":
                obj.h += val.count;
                obj.d += obj.a === 0 ? 0 : obj.a * val.count;
                break;
            case "up":
                // obj.d -= val.count;
                obj.a -= val.count;
                break;
            case "down":
                // obj.d += val.count;
                obj.a += val.count;
                break;
        }
        return obj.h * obj.d;
    }, 0);
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 900);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
