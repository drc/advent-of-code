const fs = require("fs").promises;

async function readFile() {
    const input = await fs.readFile("input.txt", "utf-8");
    const data = parse(input);
    console.log("part1", part1(input));
    console.log("part2", part2(input));
}

readFile();

const parse = input =>
    input.split("\n").map(line => {
        const {
            groups,
        } = /(?<i>\d+)-(?<j>\d+) (?<letter>\w): (?<password>\w+)/g.exec(line);
        return {
            ...groups,
            i: parseInt(groups.i),
            j: parseInt(groups.j),
        };
    });

const part1 = input =>
    parse(input).reduce((valid, { i, j, letter, password }) => {
        const actual = password.split(letter).length - 1;
        return actual >= i && actual <= j ? valid + 1 : valid;
    }, 0);

const part2 = input =>
    parse(input).reduce(
        (valid, { i, j, letter, password }) =>
            (password[i - 1] === letter) !== (password[j - 1] === letter)
                ? valid + 1
                : valid,
        0
    );
