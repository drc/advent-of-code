const { getFile } = require("../utils");
const fs = require("fs");

const parentRXP = new RegExp(/^(.*) bags contain (.*)/);
const childRXP = new RegExp(/(\d+) (.*) bag/);

class Bag {
    constructor(name) {
        this.name = name;
        this.children = [];
    }

    hasChild(name, depth = 0) {
        // console.log(name, depth)
        return depth > 0 && this.name === name
            ? true
            : [...new Set(this.children)].some(child =>
                  child.hasChild(name, depth + 1)
              );
    }

    childCount(depth = 0) {
        const count = depth > 0 ? 1 : 0;
        return (
            this.children.reduce(
                (total, current) => total + current.childCount(depth + 1),
                0
            ) + count
        );
    }
}

const loadRules = (nodes, line) => {
    const match = parentRXP.exec(line);
    if (match) {
        const [_, root, children] = match;
        const rootNode = getNode(nodes, root);
        children.split(",").forEach(child => {
            const childMatch = getChildMatch(child);
            if (childMatch) {
                const childNode = getNode(nodes, childMatch.bag);
                for (let i = 0; i < childMatch.number; i++) {
                    rootNode.children.push(childNode);
                }
            }
        });
        return rootNode;
    }
    return null;
};

const getChildMatch = child => {
    const match = childRXP.exec(child);
    if (match) {
        const [_, number, bag] = match;
        return {
            number: parseInt(number),
            bag,
        };
    }
    return null;
};

const getNode = (nodes, bag) => {
    if (bag in nodes) {
        return nodes[bag];
    } else {
        const node = new Bag(bag);
        nodes[bag] = node;
        return node;
    }
};

const findMe = "shiny gold";

const part1 = async file => {
    const input = await getFile(file);
    const lines = input.split("\n");
    const rules = {};
    lines.forEach(line => loadRules(rules, line));

    return Object.values(rules).reduce(
        (total, node) => total + (node.hasChild(findMe) ? 1 : 0),
        0
    );
};

const part2 = async file => {
    const input = await getFile(file);
    const lines = input.split("\n");
    const rules = {};
    lines.forEach(line => loadRules(rules, line));
    fs.writeFileSync("tree.json", JSON.stringify(rules, null, 4));
    return rules[findMe].childCount();
};

Promise.all([part1("input.txt"), part2("sample.txt")]).then(values => {
    const [ans1, ans2] = values;
    console.log({ ans1 });
    console.log({ ans2 });
});
