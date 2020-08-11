class Case {
    constructor(x, y) {
        this.x = x
        this.y = y
    }

    getX() {
        return this.x
    }

    getY() {
        return this.y
    }

    compareCase(b) {
        if (this.x == b.x && this.y == b.y) return true
        else false
    }
}