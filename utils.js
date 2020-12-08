const { readFile } = require("fs").promises;

const getFile = async file => {
    return await readFile(file, "utf-8");
};

const fileToLines = file => {
    return getFile(file).then(data => data.split("\n"));
};

module.exports = { getFile, fileToLines };
