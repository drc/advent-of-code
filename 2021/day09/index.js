import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n").map(l => l.split("").map(Number));

const rawData = readInput();
const raw = rawData.split("\n").map(l => l.split("").map(Number));

const mod = (n, m) => {
    return ((n % m) + m) % m;
};

const checkUp = (data, row, col) => {
    if (row - 1 > -1) {
        return data[mod(row - 1, data.length)][col];
    }
    return Infinity;
};

const checkDown = (data, row, col) => {
    if (row + 1 <= data.length - 1) {
        return data[mod(row + 1, data.length)][col];
    }
    return Infinity;
};

const checkLeft = (data, row, col) => {
    if (col - 1 > -1) {
        return data[row][mod(col - 1, data[row].length)];
    }
    return Infinity;
};

const checkRight = (data, row, col) => {
    if (col + 1 <= data[row].length - 1) {
        return data[row][mod(col + 1, data[row].length)];
    }
    return Infinity;
};

const getAdjacent = (data, row, col) => {
    const up = checkUp(data, row, col);
    const down = checkDown(data, row, col);
    const left = checkLeft(data, row, col);
    const right = checkRight(data, row, col);
    return { up, down, left, right };
};

const partOne = data => {
    const lowers = [];
    for (let row = 0; row < data.length; row++) {
        for (let col = 0; col < data[row].length; col++) {
            const { up, down, left, right } = getAdjacent(data, row, col);
            const el = data[row][col];

            if (el < up && el < down && el < left && el < right) {
                lowers.push(el);
            }
        }
    }
    return lowers.reduce((acc, val) => acc + (1 + val), 0);
};

const answer = partOne(sample);
assert.strictEqual(answer, 15);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const generateMap = data => {
    return data.map((line, x) => {
        return line.map((height, y) => {
            if (height === 9) return undefined;
            return { height, x, y, basin: false };
        });
    });
};

const getMapLocation = (map, row, col) => {
    return map[row]?.[col];
};

const getBasin = loc => {
    const basin = [];

    const basinAt = l => {
        if (!l || l.basin) return;

        l.basin = true;
        basin.push(l);

        basinAt(l.up);
        basinAt(l.down);
        basinAt(l.left);
        basinAt(l.right);
    };

    basinAt(loc);

    return basin;
};

const getAll = map => {
    const basins = [];

    for (const row of map) {
        for (const loc of row) {
            if (!loc || loc.basin) continue;

            basins.push(getBasin(loc));
        }
    }
    return basins;
};

const partTwo = data => {
    const map = generateMap(data);
    for (const row of map) {
        for (const loc of row) {
            if (!loc) continue;

            loc.up = getMapLocation(map, loc.x, loc.y - 1);
            loc.down = getMapLocation(map, loc.x, loc.y + 1);
            loc.right = getMapLocation(map, loc.x + 1, loc.y);
            loc.left = getMapLocation(map, loc.x - 1, loc.y);
        }
    }
    const basins = getAll(map);
    basins.sort((a, b) => b.length - a.length);
    const [top1, top2, top3] = [
        basins[0].length,
        basins[1].length,
        basins[2].length,
    ];
    return top1 * top2 * top3;
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 1134);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
