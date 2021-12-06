class LanternFish {
    constructor(timer = 8) {
        this.timer = timer;
        this.createNew = false;
    }

    addDay() {
        if (this.timer === 0) {
            this.timer = 6;
            this.createNew = true;
        } else {
            this.timer--;
        }
    }

    hasNewFish() {
        return this.createNew;
    }

    createNewFish() {
        this.createNew = false;
        return new LanternFish();
    }
}

export default LanternFish;
