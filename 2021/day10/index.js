import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

const match = {
    "(": ")",
    "[": "]",
    "{": "}",
    "<": ">",
};

const bracketCheck = data => {
    const stack = [];
    let char = "";
    const start = "([{<";
    const end = ")]}>";

    for (const letter of data) {
        if (start.includes(letter)) {
            stack.push(letter);
        } else if (end.includes(letter)) {
            const endingBracket = stack.pop();
            if (match[endingBracket] !== letter) {
                return letter;
            }
        }
    }
    return stack.map(char => match[char]);
};

const partOne = data => {
    const points = {
        ")": 3,
        "]": 57,
        "}": 1197,
        ">": 25137,
    };
    return data.reduce((acc, val) => {
        const bracket = bracketCheck(val);
        if (typeof bracket === "string") {
            acc += points[bracket];
        }
        return acc;
    }, 0);
};

const answer = partOne(sample);
assert.strictEqual(answer, 26397);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    const unfinished = data.reduce((acc, val) => {
        if (typeof bracketCheck(val) === "object") {
            acc.push(val);
        }
        return acc;
    }, []);
    const chars = unfinished.reduce((acc, val) => {
        const brackets = bracketCheck(val);
        acc.push(brackets);
        return acc;
    }, []);
    const pointList = chars
        .map(list => {
            return list.reverse().reduce((acc, val) => {
                const points = {
                    ")": 1,
                    "]": 2,
                    "}": 3,
                    ">": 4,
                };
                acc = acc * 5 + points[val];
                return acc;
            }, 0);
        })
        .sort((a, b) => a - b);
    return pointList[Math.ceil((pointList.length - 1) / 2)];
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 288957);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
