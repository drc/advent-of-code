const assert = require("assert");
const { getFile } = require("../utils");

const preamble = 25;

const part1 = async (file, preamble) => {
    const input = await getFile(file);
    const lines = input.split("\n").map(Number);

    const answer = lines.slice(preamble).find((val, idx) => {
        const searchVals = lines.slice(idx, idx + preamble);
        return !searchVals.some((a, i) => {
            return searchVals.slice(i + 1).some(b => {
                return a + b === val && a !== b;
            });
        });
    });

    return { answer };
};

const part2 = async (file, preamble) => {
    const input = await getFile(file);
    const lines = input.split("\n").map(Number);
    const { answer: search } = await part1(file, preamble);

    let max = 0;
    let min = 0;

    for (let i = 0; i < lines.length; i++) {
        let sum = lines[i];
        for (let j = i + 1; j < lines.length; j++) {
            sum += lines[j];
            if (sum === search) {
                const end = { start: i, end: j, list: lines.slice(i, j + 1) };
                max = Math.max(...end.list);
                min = Math.min(...end.list);
            }
        }
    }

    return { min, max, sum: max + min };
};

Promise.all([part1("input.txt", 25), part2("input.txt", 25)]).then(answers =>
    console.log(answers)
);
