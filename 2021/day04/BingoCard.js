class BingoCard {
    constructor() {
        this.numbers = [];
    }

    addRow(row) {
        this.numbers.push(
            row
                .split(/\s/)
                .filter(num => num !== "")
                .map(num => ({ number: parseInt(num), picked: false }))
        );
    }

    markNumber(number) {
        // search the number array for the number and mark checked true
    }

    getUnmarkedSum() {
        // return sum of unchecked numbers
    }

    isComplete() {
        // check the cols and rows for winners
    }

    _isRowWinner() {
        // check rows for all checked return true if winner
    }

    _isColWinner() {
        // check cols for all checked return true if winner
    }
}

export default BingoCard;
