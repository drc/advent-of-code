import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();

const sample = rawSample.split("\n").reduce((acc, line) => {
    const [a, b] = line.split("-");
    acc[a] = acc[a] ? acc[a] : [];
    acc[b] = acc[b] ? acc[b] : [];
    acc[a].push(b);
    acc[b].push(a);
    return acc;
}, {});

const rawData = readInput();
const raw = rawData.split("\n").reduce((acc, line) => {
    const [a, b] = line.split("-");
    acc[a] = acc[a] ? acc[a] : [];
    acc[b] = acc[b] ? acc[b] : [];
    acc[a].push(b);
    acc[b].push(a);
    return acc;
}, {});

const count = (edges, revisit, curr = "start", path = []) => {
    if (curr === "end") return 1;

    const isSmall = curr === curr.toLowerCase();
    if (isSmall && path.includes(curr)) {
        if (revisit && curr !== "start") {
            revisit = false;
        } else {
            return 0;
        }
    }

    return edges[curr].reduce(
        (acc, neighbor) =>
            acc +
            count(edges, revisit, neighbor, [
                ...path,
                curr,
            ]),
        0
    );
};

const partOne = data => {
    return count(data);
};

const answer = partOne(sample);
// assert.strictEqual(answer, 198);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    return count(data, true);
};

const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 230);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
