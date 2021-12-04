import { readInput, readSampleInput } from "../../utils/readInput.js";
import BingoCard from "./BingoCard.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

console.log(sample);

const getCallingNumbers = data => {
    return data[0].split(",").map(num => parseInt(num));
};

const generateCards = data => {
    const [_, ...rest] = data;
    const cardList = [];
    let currentCard = 0;
    for (let row of rest) {
        if (row === "") {
            const bingoCard = new BingoCard();
            cardList.push(bingoCard);
            currentCard++;
        } else {
            cardList[currentCard - 1].addRow(row);
        }
    }
    return cardList;
};

const callingNumbers = getCallingNumbers(sample);
console.log(callingNumbers);

const cards = generateCards(sample);

const partOne = data => {};

const answer = partOne(sample);
// assert.strictEqual(answer, 198);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {};

const answer2 = partTwo(sample);
// assert.strictEqual(answer2, 230);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
