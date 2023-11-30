class Spot {
    f = 0;
    g = 0;
    h = 0;

    neighbors = null;
    previous = null;

    LURDMoves = [
        [-1, 0],
        [0, -1],
        [1, 0],
        [0, 1],
    ];

    constructor(x, y, val) {
        this.col = x;
        this.row = y;
        this.val = val;
    }

    getNeighbors() {
        if (!this.neighbors) {
            this.addNeighbors();
        }
        return this.neighbors;
    }

    addNeighbors(grid) {
        this.neighbors = [];

        for (const [x, y] of this.LURDMoves) {
            var node = grid[this.y + y]?.[this.x + x];
            if (node) {
                this.neighbors.push(node);
            }
        }
    }
}

export default Spot;
