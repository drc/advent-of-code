const fs = require("fs").promises;

const part1 = async file => {
    const input = await fs.readFile(file, "utf-8");
    const groups = input.toString().trim().split("\n\n");

    let total = 0;
    groups.forEach(group => {
        const people = group.split("\n");
        const peopleCount = people.length;
        const answers = people.reduce((val, current, _, person) => {
            const letters = current.split("");
            letters.forEach(letter => {
                if (letter in val) {
                    val[letter]++;
                } else {
                    val[letter] = 1;
                }
            });
            return val;
        }, {});
        total += Object.keys(answers)
            .map(key => answers[key] >= peopleCount)
            .reduce((acc, curr) => (acc += curr ? curr : 0), 0);
    });
    console.log(total);
};

part1("input.txt");
