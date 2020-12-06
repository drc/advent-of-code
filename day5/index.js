const fs = require("fs").promises;

const getSeats = async file => {
    const input = await fs.readFile(file, "utf-8");
    const passes = input.toString().trim().split("\n");
    const passRXP = /([FB]{7})([RL]{3})/;
    const answer = passes.reduce((result, boardingPass) => {
        const [pass, row, column, ...rest] = passRXP.exec(boardingPass);
        const rowBinary = row.replace(/F/g, "0").replace(/B/g, "1");
        const columnBinary = column.replace(/L/g, "0").replace(/R/g, "1");
        const passId = parseInt(rowBinary, 2) * 8 + parseInt(columnBinary, 2);
        console.log({ passId });
        if (result < passId) {
            result = passId;
        }
        return result;
    }, 0);
    console.log("Highest ID:", answer);
};

const findSeat = async file => {
    const input = await fs.readFile(file, "utf-8");
    const passes = input.toString().trim().split("\n");
    let seatNumbers = passes.map(pass => {
        const passRXP = /([FB]{7})([RL]{3})/;
        const [boardingPass, row, column, ...rest] = passRXP.exec(pass);
        const rowBinary = row.replace(/F/g, "0").replace(/B/g, "1");
        const columnBinary = column.replace(/L/g, "0").replace(/R/g, "1");
        const passId = parseInt(rowBinary, 2) * 8 + parseInt(columnBinary, 2);
        return passId;
    });
    fs.writeFile("./seats.txt", seatNumbers.toString(), "utf-8");
    seatNumbers.sort((a, b) => a - b);
    console.log(seatNumbers[220]);
    for (let i = 1; i < seatNumbers.length; i++) {
        console.log(i, seatNumbers[i], seatNumbers[i - 1]);
        if (seatNumbers[i] !== seatNumbers[i - 1] + 1)
            return seatNumbers[i - 1] + 1;
    }
};

const printAns = async () => {
    const ans = await Promise.all([findSeat("input.txt")]);
    console.log(ans);
};

printAns();
