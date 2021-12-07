import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

const parseInput = data => {
    return data.map(dir => {
        const [start, end] = dir
            .split(/\s->\s/)
            .map(pair => pair.split(",").map(p => +p));
        return { start, end };
    });
};

const filterLines = data => {
    return data.filter(d => d.start[0] === d.end[0] || d.start[1] === d.end[1]);
};

const generateArray = data => {
    const bigX = data
        .reduce((arr, el) => {
            arr.push(el.start[0]);
            arr.push(el.end[0]);
            return arr;
        }, [])
        .reduce((acc, val, _, arr) => {
            acc = acc < val ? val : acc;
            return acc;
        }, 0);

    const bigY = data
        .reduce((arr, el) => {
            arr.push(el.start[1]);
            arr.push(el.end[1]);
            return arr;
        }, [])
        .reduce((acc, val, _, arr) => {
            acc = acc < val ? val : acc;
            return acc;
        }, 0);

    return Array(bigY + 1)
        .fill()
        .map(() => Array(bigX + 1).fill(0));
};

const simpleLines = (data, diagram) => {
    const board = JSON.parse(JSON.stringify(diagram));
    for (let pair of data) {
        let [startX, startY] = pair.start;
        let [endX, endY] = pair.end;
        if (startX === endX) {
            // set the val on the board, update y
            board[startY][startX] += 1;
            while (startY !== endY) {
                if (startY < endY) {
                    startY++;
                } else if (startY > endY) {
                    startY--;
                }
                board[startY][startX] += 1;
            }
        } else if (startY === endY) {
            // set the val on the board, update x
            board[startY][startX] += 1;
            while (startX !== endX) {
                if (startX < endX) {
                    startX++;
                } else if (startX > endX) {
                    startX--;
                }
                board[startY][startX] += 1;
            }
        }
    }
    return board;
};

const complexLines = (data, diagram) => {
    const board = JSON.parse(JSON.stringify(diagram));
    for(let pair of data) {
        let [startX, startY] = pair.start;
        let [endX, endY] = pair.end;
        board[startY][startX] += 1;
        while(startX !== endX || startY !== endY) {
            startX += startX < endX ? 1 : startX === endX ? 0 : -1;
            startY += startY < endY ? 1 : startY === endY ? 0 : -1;
            board[startY][startX] += 1;
        }
    }
    return board;
}

const getTotalOverlap = diagram => {
    return diagram.reduce((acc, val) => {
        acc += val.filter(el => el >= 2).length;
        return acc;
    }, 0);
};

const partOne = data => {
    const pairs = parseInput(data);
    const filteredPairs = filterLines(pairs);
    const diagram = generateArray(filteredPairs);
    const completedDiagram = simpleLines(filteredPairs, diagram);
    const total = getTotalOverlap(completedDiagram);
    return total;
};

const answer = partOne(sample);
assert.strictEqual(answer, 5);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    const pairs = parseInput(data);
    const diagram = generateArray(pairs);
    const completedDiagram = complexLines(pairs, diagram);
    const total = getTotalOverlap(completedDiagram);
    return total;
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 12);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
