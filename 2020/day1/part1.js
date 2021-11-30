const fs = require("fs").promises;

async function readFile() {
    const input = await fs.readFile("./input.txt", "utf-8");
    const nums = input.split("\n").map(line => parseInt(line.trim()));
    for (let i = 0; i < nums.length; i++) {
        for (let j = 0; j < nums.length; j++) {
            if (nums[i] + nums[j] === 2020) {
                console.log(nums[i], nums[j], nums[i] + nums[j]);
                console.log(nums[i] * nums[j]);
                fs.writeFile(
                    "./output1.txt",
                    `${nums[i]} + ${nums[j]} = 2020\n${nums[i]} * ${
                        nums[j]
                    } = ${nums[i] * nums[j]}`, "utf-8"
                );
                break;
            }
        }
    }
}

readFile();
