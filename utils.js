const { readFile } = require("fs").promises;

const getFile = async file => {
    return await readFile(file, "utf-8");
};

module.exports = { getFile };
