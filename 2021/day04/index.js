import { readInput, readSampleInput } from "../../utils/readInput.js";
import BingoCard from "./BingoCard.js";
import assert from "assert";

const rawSample = readSampleInput();
const sample = rawSample.split("\n");

const rawData = readInput();
const raw = rawData.split("\n");

const getCallingNumbers = data => {
    return data[0].split(",").map(num => +num);
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

const partOne = data => {
    const callingNumbers = getCallingNumbers(data);

    const cards = generateCards(data);

    let total = 0;
    let numIdx = 0;
    while (total === 0) {
        const num = callingNumbers[numIdx];
        for (let card of cards) {
            card.pickNumber(num);
            if (card.isComplete()) {
                total = card.getUnmarkedSum() * num;
                break;
            }
        }
        numIdx++;
    }

    return total;
};

const answer = partOne(sample);
assert.strictEqual(answer, 4512);

const finalAnswer = partOne(raw);
console.log(`Part 1 answer: ${finalAnswer}`);

const partTwo = data => {
    const callingNumbers = getCallingNumbers(data);

    let cards = generateCards(data);

    let total = 0;
    let numIdx = 0;
    while (cards.length > 1) {
        cards = cards.filter(card => !card.winner);

        const num = callingNumbers[numIdx];

        for (let card of cards) {
            card.pickNumber(num);
            card.isComplete();
        }
        numIdx++;
    }

    total = cards[0].getUnmarkedSum() * cards[0].lastCalled;

    return total;
};

const answer2 = partTwo(sample);
assert.strictEqual(answer2, 1924);

const finalAnswer2 = partTwo(raw);
console.log(`Part 2 answer: ${finalAnswer2}`);
