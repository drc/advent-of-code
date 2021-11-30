const fs = require("fs").promises;
const assert = require("assert");

const VALID_KEYS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];

let validPassports = 0;

const readFile = async (expecting) => {
    const input = await fs.readFile("sample1.txt", "utf-8");
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
            validPassports++;
        }
    });
    if (expecting) {
        assert.strictEqual(validPassports, expecting);
    }
    console.log(`${validPassports} valid passports`);
};

const printans = async () => {
    const ans = await Promise.all([]);
};

readFile();
