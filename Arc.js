class Arc {
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

    compareArc(b) {
        if (this.x.compareCase(b.x)) {
            if (this.y.compareCase(b.y))
                return true
            else
                return false
        } else {
            return false
        }
    }

    setX(arc) {
        this.x = arc
    }

    setY(arc) {
        this.y = arc
    }


}