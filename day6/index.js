const { getFile } = require("../utils");

const part1 = async file => {
    const input = await getFile(file);

    const total = input
        .toString()
        .trim()
        .split("\n\n")
        .reduce((answer, group) => {
            answer += Object.values(
                group.split("\n").reduce((val, current) => {
                    current
                        .split("")
                        .forEach(letter =>
                            val[letter] ? val[letter]++ : (val[letter] = 1)
                        );
                    return val;
                }, {})
            )
                .map(val => val >= group.split("\n").length)
                .reduce((acc, curr) => (acc += curr ? curr : 0), 0);
            return answer;
        }, 0);
    console.log(total);
};

part1("input.txt");
