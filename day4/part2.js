const fs = require("fs").promises;
const assert = require("assert");

const VALID_KEYS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];

let validPassports = 0;

const readFile = async (expecting) => {
    const input = await fs.readFile("input.txt", "utf-8");
    const passports = input.split(/\n{2}/).map((line) => line.replaceAll("\n", " "));

    passports.forEach((passport, idx) => {
        let validKeys = 0;
        const passportKeyValue = passport.split(" ").map(kv => kv.split(":"));
        const keyLength = passport.split(" ").length;

        const passportObj = passportKeyValue.map(ppkv => {
            const [key, value] = ppkv;
            return ({ [key]: value });
        }).reduce((obj, item) => ({ ...obj, ...item }));

        for (let key of VALID_KEYS) {
            if (key in passportObj) {
                validKeys++;
            }
        }
        if (validKeys === VALID_KEYS.length) {
            const fieldsValid = fieldValidation(passportObj);
            if (fieldsValid) {
                validPassports++;
            }
        }
    });
    if (expecting) {
        assert.strictEqual(validPassports, expecting);
    }
    console.log(`${validPassports} valid passports`);
};

// Rules
// byr      4 digit     at least 1920   at most 2002
// iyr      4 digit     at least 2010   at most 2020
// eyr      4 digit     at least 2020   at most 2030
// hgt      cm or in
//          cm          at least 150    at most 193
//          in          at least 59     at most 76
// hcl      # followed by 6 char 0-9 a-f
// ecl      exactly : amb blu brn gry grn hzl oth
// pid      9 digit     including leading 0
// cid      ignored


const fieldValidation = (passport) => {
    const { byr, iyr, eyr, hgt, hcl, ecl, pid } = passport;
    const hclRXP = new RegExp(/^#[a-f0-9]{6}$/);
    const eclRXP = new RegExp(/(amb|blu|brn|gry|grn|hzl|oth)/);
    const pidRXP = new RegExp(/\d{9}/);

    // validate byr
    if (!years(byr, 1920, 2002)) {
        return false;
    }

    if (!years(iyr, 2010, 2020)) {
        return false;
    }

    if (!years(eyr, 2020, 2030)) {
        return false;
    }

    if (!height(hgt)) {
        return false;
    }

    if (hcl.match(hclRXP) === null) {
        // log("[-]    hcl invalid", { hcl });
        return false;
    }

    if (ecl.match(eclRXP) === null) {
        // log("[-]    ecl invalid", { ecl, value: ecl.match(eclRXP) });
        return false;
    }

    if (pid.match(pidRXP) === null) {
        // log("[-]    pid invalid", { pid });
        return false;
    }

    return true;
}

const yearValidationRange = (year, start, end) => {
    return year >= start && year <= end;
}

const heightValidationRange = (unit, measure) => {
    if (measure === "cm") {
        return unit >= 150 && unit <= 193;
    }

    if (measure === "in") {
        return unit >= 59 && unit <= 76;
    }

    return false;
}

const years = (value, start, end) => {
    const yearRXP = new RegExp(/\d{4}/);

    if (value.match(yearRXP) === null) {
        // log("[-]    yearRXP invalid", { value });
        return false;
    }

    if (!yearValidationRange(parseInt(value), start, end)) {
        // log("[-]    range invalid", { value, start, end });
        return false;
    }
    return true;
}

const height = (value) => {
    const hgtRXP = new RegExp(/(\d{2,3})(cm|in)/);
    const validHeight = value.match(hgtRXP);

    if (validHeight === null) {
        log("[-]    hgt invalid, not cm / in", { value });
        return false;
    }

    const [height, unit, measure, ...rest] = validHeight;

    if (!heightValidationRange(unit, measure)) {
        log("[-]    hgt range invalid", { unit, measure });
        return false;
    }

    return true;
};

const log = (message, obj) => {
    console.log(message);
    console.table(obj);
}

readFile();
