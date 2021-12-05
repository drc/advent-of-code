class BingoCard {
    constructor() {
        this.numbers = [];
        this.lastCalled = 0;
        this.winner = false;
    }

    /**
     * Parse and add the line to the numbers array and create a number object.
     * @param {String} row Row from the input data
     */
    addRow(row) {
        this.numbers.push(
            row
                .split(/\s/)
                .filter(num => num !== "")
                .map(num => ({ number: +num, picked: false }))
        );
    }

    /**
     * Search and mark true the number in the card that was picked.
     * @param {Number} number Number that was picked
     */
    pickNumber(number) {
        this.lastCalled = number;
        this.numbers.forEach(row =>
            row.forEach(col => {
                if (col.number === number) {
                    col.picked = true;
                }
            })
        );
    }

    /**
     * Gets the sum of numbers that weren't picked.
     *
     * @returns {Number} Sum of unpicked numbers
     */
    getUnmarkedSum() {
        return this.numbers.reduce((total, row) => {
            for (let col of row) {
                total += !col.picked ? col.number : 0;
            }
            return total;
        }, 0);
    }

    /**
     * Read all columns and rows for a winning combo
     * @returns {Boolean} Completed
     */
    isComplete() {
        const completedRows = this._isRowWinner(this.numbers);
        const completedColumns = this._isColWinner(this.numbers);
        this.winner = completedRows || completedColumns;
        return this.winner;
    }

    /**
     * Takes in a 2D Array and changes the orientation from Rows to Columns
     * @param {Array} arr 2D Array
     * @returns {Array} 2D Array
     */
    _transpose(arr) {
        const rowCount = arr.length;
        const colCount = arr[0].length;

        const transposed = [];

        for (let col = 0; col < colCount; col++) {
            const rowArr = [];
            for (let row = 0; row < rowCount; row++) {
                rowArr.push(arr[row][col]);
            }
            transposed.push(rowArr);
        }
        return transposed;
    }

    /**
     * Utility to read rows and see if every value has been picked
     * @param {Array} arr 2D Array
     * @returns {Boolean} Row is winner
     */
    _isRowWinner(arr) {
        return arr.some(rows => rows.every(row => row.picked));
    }

    /**
     * Utility to read columns and see if every value has been picked
     * @param {Array} arr 2D Array
     * @returns {Boolean} Column is winner
     */
    _isColWinner(arr) {
        return this._transpose(arr).some(cols => cols.every(col => col.picked));
    }
}

export default BingoCard;
