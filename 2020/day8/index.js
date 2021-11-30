const { getFile } = require("../utils");

const part1 = async file => {
    const input = await getFile(file);
    const lines = input.toString().split("\n");
    const commands = lines.map(parseCommand);

    const { acc } = run(commands);
    return acc;
};

const part2 = async file => {
    const input = await getFile(file);
    const lines = input.toString().split("\n");
    const commands = lines.map(parseCommand);
    let acc = 0;

    for (let j = 0; j < lines.length; j++) {
        const copy = JSON.parse(JSON.stringify(commands));

        if (copy[j].command === "nop") {
            copy[j].command = "jmp";
        } else if (copy[j].command === "jmp") {
            copy[j].command = "nop";
        }
        const { acc, exit } = run(copy);
        if (!exit) {
            return acc;
        }
    }
};

const run = commands => {
    let acc = 0;
    let exit = false;
    for (let i = 0; i < commands.length; ) {
        commands[i].duplicate += 1;
        if (commands[i].duplicate > 1) {
            exit = true;
            return { acc, exit };
        }
        const { command, input } = commands[i];
        if (command === "nop") {
            // do nothing
            i++;
        } else if (command === "acc") {
            // add however many to the accumulator
            acc += input;
            i++;
        } else if (command === "jmp") {
            // jump to x in the iterator
            i += input;
        }
    }
    return { acc, exit };
};

const parseCommand = line => {
    const [command, input] = line.split(" ");
    return { command, input: parseInt(input, 10), duplicate: 0 };
};

Promise.all([part1("input.txt"), part2("input.txt")]).then(answers =>
    console.log(answers)
);
