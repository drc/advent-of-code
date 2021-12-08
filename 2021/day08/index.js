import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

// 0 - 9
const config = [
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
            .map(pair =>
                pair
                    .split(" ")
                    .map(letters => letters.split("").sort().join(""))
            );
        return { input, output };
    });
};

const easy = config.reduce((acc, val, idx, arr) => {
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

const findByNumber = (num, data) => {
    const idx = data.findIndex(el => el.length === num);
    return data.splice(idx, 1)[0];
};

const findByFunction = (func, data) => {
    const idx = data.findIndex(func);
    return data.splice(idx, 1)[0];
};

const off = (signal, element) => {
    return signal
        .split("")
        .filter(el => !element.includes(el))
        .join("");
};

const union = (element, signal) => {
    return off(signal, element).length === 0;
};

const sigToDigit = sigs => {
    const dig = {};
    for (const d in sigs) {
        dig[sigs[d]] = d;
    }
    return dig;
};

const stringToDigit = data => {
    let output = [];
    let result = 0;
    data.forEach(line => {
        const signal = {
            1: findByNumber(2, line.input),
            4: findByNumber(4, line.input),
            7: findByNumber(3, line.input),
            8: findByNumber(7, line.input),
        };

        signal[9] = findByFunction(el => union(el, signal[4]), line.input);
        signal[0] = findByFunction(
            el => el.length === 6 && union(el, signal[1]),
            line.input
        );
        signal[6] = findByNumber(6, line.input);
        signal[3] = findByFunction(el => union(el, signal[7]), line.input);
        signal[2] = findByFunction(
            el => off(signal[4], el).length === 2,
            line.input
        );
        signal[5] = findByNumber(5, line.input);

        const digits = sigToDigit(signal);

        const code = +line.output.map(signal => digits[signal]).join("");
        output.push(code);
    });
    return output;
};

const sumItUp = digits => {
    return digits.reduce((acc, val) => {
        acc += +val;
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

const partTwo = data => {
    const parsedData = parseInput(data);
    const digits = stringToDigit(parsedData);
    return sumItUp(digits);
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 61229);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
