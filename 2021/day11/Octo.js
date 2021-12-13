class Octopus {
    flash = false;

    constructor(val, row, col) {
        this.val = +val;
        this.row = +row;
        this.col = +col;
    }

    increment() {
        if (this.val < 9) {
            this.val++;
        } else {
            this.val = 0;
            this.flash = true;
        }
    }
}

export default Octopus;
