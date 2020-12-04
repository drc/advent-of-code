const fs = require("fs").promises;

async function readFile() {
    const input = await fs.readFile("./input.txt", "utf-8");
    const nums = input.split("\n").map(line => parseInt(line.trim()));
    for (let i = 0; i < nums.length; i++) {
        for (let j = 0; j < nums.length; j++) {
            for (let k = 0; k < nums.length; k++) {
                if (nums[i] + nums[j] + nums[k] === 2020) {
                    console.log(
                        nums[i],
                        nums[j],
                        nums[k],
                        nums[i] + nums[j] + nums[k]
                    );
                    console.log(nums[i] * nums[j] * nums[k]);
                    fs.writeFile(
                        "./output2.txt",
                        `${nums[i]} + ${nums[j]} + ${nums[k]} = 2020\n${nums[i]} * ${
                            nums[j]
                        } * ${nums[k]}= ${nums[i] * nums[j] * nums[k]}`,
                        "utf-8"
                    );
                    break;
                }
            }
        }
    }
}

readFile();
