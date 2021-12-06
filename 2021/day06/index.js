import { readInput, readSampleInput } from "../../utils/readInput.js";
import assert from "assert";
import LanternFish from "./LanternFish.js";

const rawSample = readSampleInput();
const sample = rawSample.split(",");

const rawData = readInput();
const raw = rawData.split(",");

const getStartingFish = data => {
    const pool = [];
    for(let timer of data) {
        pool.push(new LanternFish(+timer));
    }
    return pool;
}

const newDay = fishList => {
    const newFish = [];
    for(let fish of fishList) {
        fish.addDay();
        if(fish.hasNewFish()) {
            newFish.push(fish.createNewFish());
        }
    }
    return fishList.concat(newFish);
}

const partOne = (data, days) => {
    let fishList = getStartingFish(data);
    var i = 0;
    while(i < days) {
        fishList = newDay(fishList);
        i++;
    }
    return fishList.length;
};

const answer = partOne(sample, 80);
assert.strictEqual(answer, 5934);

const finalAnswer = partOne(raw, 80);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = (data, days) => {
    return partOne(data, days);
};

const answer2 = partTwo(sample, 256);
assert.strictEqual(answer2, 26984457539);

// const finalAnswer2 = partTwo(raw);
// console.log(`Part 2 answer: ${finalAnswer2}`);
