const fs = require("fs").promises;
const assert = require("assert");

const readFile = async (right, down, expected) => {
    const input = await fs.readFile("sample.txt", "utf-8");
    const lines = input.toString().split("\n");
    let trees = 0;
    let pos = 0;
    for (let i = 0; i < lines.length; i += down) {
        // console.log(i);
        const idx = parseInt(i);
        pos += right;
        const cap = lines[idx].length;

        if (lines.length - down > idx)
            if (lines[idx + down].charAt(pos % cap) == "#") trees++;
    }
    if (expected) {
        assert.strictEqual(trees, expected);
    }
    console.log({ right, down }, trees);
    return trees;
};

const printans = async () => {
    const ans = await Promise.all([
        readFile(1, 1),
        readFile(3, 1),
        readFile(5, 1),
        readFile(7, 1),
        readFile(1, 2),
    ]);
    console.log(ans.reduce((total, current) => (total *= current)));
};

// printans();

readFile(1, 1, 1);
readFile(3, 1, 7);
readFile(5, 1, 3);
readFile(7, 1, 4);
readFile(1, 2, 2);
