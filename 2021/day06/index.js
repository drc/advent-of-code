import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";
import LanternFish from "./LanternFish.js";

const rawSample = readSampleInput();
const sample = rawSample.split(",").map(n => +n);

const rawData = readInput();
const raw = rawData.split(",").map(n => +n);

const getStartingFish = data => {
    const pool = [];
    for (let timer of data) {
        pool.push(new LanternFish(timer));
    }
    return pool;
};

const newDay = fishList => {
    const newFish = [];
    for (let fish of fishList) {
        fish.addDay();
        if (fish.hasNewFish()) {
            newFish.push(fish.createNewFish());
        }
    }
    return fishList.concat(newFish);
};

// leaving part 1 for showing thought process
const partOne = (data, days) => {
    let fishList = getStartingFish(data);
    var i = 0;
    while (i < days) {
        fishList = newDay(fishList);
        i++;
    }
    return fishList.length;
};

const answer = partOne(sample, 80);
assert.strictEqual(answer, 5934);

const finalAnswer = partOne(raw, 80);
console.log(`Part 1 answer: ${finalAnswer}`);

// didnt realize part two would have been this ;)
const partTwo = (data, days) => {
    const fish = Array(9).fill(0); // 0-8
    // count number of fish timers
    data.forEach(n => fish[n]++); 
    for (let day = 0; day < days; day++) {
        // add to 7 because we're removing first element which then makes it 6
        fish[7] += fish[0]; 
        // remove the count at timer 0 and add to the end (reset)
        fish.push(fish.shift()); 
    }
    return fish.reduce((acc, val) => acc + val, 0);
};

const answer2 = partTwo(sample, 256);
assert.strictEqual(answer2, 26984457539);

const finalAnswer2 = partTwo(raw, 256);
console.log(`Part 2 answer: ${finalAnswer2}`);
