import { assert } from "console";
import { readFile } from "fs/promises";

(async () => {
    const dev = false;
    const sample = dev
        ? await (await readFile("sample.txt")).toString()
        : await (await readFile("input.txt")).toString();
    const final1 = dev ? 15 : 11063;
    const final2 = dev ? 12 : 0;

    const key = {
        X: {
            name: "rock",
            win: "C",
            loss: "B",
            tie: "A",
            val: 1,
        },
        Y: {
            name: "paper",
            win: "A",
            loss: "C",
            tie: "B",
            val: 2,
        },
        Z: {
            name: "scissors",
            win: "B",
            loss: "A",
            tie: "C",
            val: 3,
        },
    };

    const pair = sample.split("\n").map(pair => pair.split(/\s/));

    const answer1 = pair.reduce((acc, val) => {
        const [theirMove, yourMove] = val;
        let round = 0;

        if (key[yourMove].win === theirMove) {
            round += 6 + key[yourMove].val;
        } else if (key[yourMove].loss === theirMove) {
            round += 0 + key[yourMove].val;
        } else {
            round += 3 + key[yourMove].val;
        }

        return (acc += round);
    }, 0);

    assert(answer1 === final1);

    const answer2 = pair.reduce((acc, val) => {
        const [theirMove, yourMove] = val;

        switch (theirMove) {
            case "A":
                switch (yourMove) {
                    case "X":
                        acc += 0 + 3;
                        break;
                    case "Y":
                        acc += 3 + 1;
                        break;
                    case "Z":
                        acc += 6 + 1;
                        break;
                }
                break;
            case "B":
                switch (yourMove) {
                    case "X":
                        acc += 0 + 1;
                        break;
                    case "Y":
                        acc += 3 + 2;
                        break;
                    case "Z":
                        acc += 6 + 3;
                        break;
                }
                break;
            case "C":
                switch (yourMove) {
                    case "X":
                        acc += 0 + 2;
                        break;
                    case "Y":
                        acc += 3 + 3;
                        break;
                    case "Z":
                        acc += 6 + 1;
                        break;
                }
                break;
        }

        return acc;
    }, 0);
    assert(answer2 === final2)
    console.log(answer2);
})();
