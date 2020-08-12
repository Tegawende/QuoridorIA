class Board {

    listArc = []
    positionJoueur = {}

    constructor() {
        this.listArc = [
            new Arc(new Case("A", "1"), new Case("A", "2")),
            new Arc(new Case("A", "2"), new Case("A", "3")),
            new Arc(new Case("A", "3"), new Case("A", "4")),
            new Arc(new Case("A", "4"), new Case("A", "5")),
            new Arc(new Case("A", "5"), new Case("A", "6")),
            new Arc(new Case("A", "6"), new Case("A", "7")),
            new Arc(new Case("A", "7"), new Case("A", "8")),
            new Arc(new Case("A", "8"), new Case("A", "9")),
            new Arc(new Case("B", "1"), new Case("B", "2")),
            new Arc(new Case("B", "2"), new Case("B", "3")),
            new Arc(new Case("B", "3"), new Case("B", "4")),
            new Arc(new Case("B", "4"), new Case("B", "5")),
            new Arc(new Case("B", "5"), new Case("B", "6")),
            new Arc(new Case("B", "6"), new Case("B", "7")),
            new Arc(new Case("B", "7"), new Case("B", "8")),
            new Arc(new Case("B", "8"), new Case("B", "9")),
            new Arc(new Case("C", "1"), new Case("C", "2")),
            new Arc(new Case("C", "2"), new Case("C", "3")),
            new Arc(new Case("C", "3"), new Case("C", "4")),
            new Arc(new Case("C", "4"), new Case("C", "5")),
            new Arc(new Case("C", "5"), new Case("C", "6")),
            new Arc(new Case("C", "6"), new Case("C", "7")),
            new Arc(new Case("C", "7"), new Case("C", "8")),
            new Arc(new Case("C", "8"), new Case("C", "9")),
            new Arc(new Case("D", "1"), new Case("D", "2")),
            new Arc(new Case("D", "2"), new Case("D", "3")),
            new Arc(new Case("D", "3"), new Case("D", "4")),
            new Arc(new Case("D", "4"), new Case("D", "5")),
            new Arc(new Case("D", "5"), new Case("D", "6")),
            new Arc(new Case("D", "6"), new Case("D", "7")),
            new Arc(new Case("D", "7"), new Case("D", "8")),
            new Arc(new Case("D", "8"), new Case("D", "9")),
            new Arc(new Case("E", "1"), new Case("E", "2")),
            new Arc(new Case("E", "2"), new Case("E", "3")),
            new Arc(new Case("E", "3"), new Case("E", "4")),
            new Arc(new Case("E", "4"), new Case("E", "5")),
            new Arc(new Case("E", "5"), new Case("E", "6")),
            new Arc(new Case("E", "6"), new Case("E", "7")),
            new Arc(new Case("E", "7"), new Case("E", "8")),
            new Arc(new Case("E", "8"), new Case("E", "9")),
            new Arc(new Case("F", "1"), new Case("F", "2")),
            new Arc(new Case("F", "2"), new Case("F", "3")),
            new Arc(new Case("F", "3"), new Case("F", "4")),
            new Arc(new Case("F", "4"), new Case("F", "5")),
            new Arc(new Case("F", "5"), new Case("F", "6")),
            new Arc(new Case("F", "6"), new Case("F", "7")),
            new Arc(new Case("F", "7"), new Case("F", "8")),
            new Arc(new Case("F", "8"), new Case("F", "9")),
            new Arc(new Case("G", "1"), new Case("G", "2")),
            new Arc(new Case("G", "2"), new Case("G", "3")),
            new Arc(new Case("G", "3"), new Case("G", "4")),
            new Arc(new Case("G", "4"), new Case("G", "5")),
            new Arc(new Case("G", "5"), new Case("G", "6")),
            new Arc(new Case("G", "6"), new Case("G", "7")),
            new Arc(new Case("G", "7"), new Case("G", "8")),
            new Arc(new Case("G", "8"), new Case("G", "9")),
            new Arc(new Case("H", "1"), new Case("H", "2")),
            new Arc(new Case("H", "2"), new Case("H", "3")),
            new Arc(new Case("H", "3"), new Case("H", "4")),
            new Arc(new Case("H", "4"), new Case("H", "5")),
            new Arc(new Case("H", "5"), new Case("H", "6")),
            new Arc(new Case("H", "6"), new Case("H", "7")),
            new Arc(new Case("H", "7"), new Case("H", "8")),
            new Arc(new Case("H", "8"), new Case("H", "9")),
            new Arc(new Case("I", "1"), new Case("I", "2")),
            new Arc(new Case("I", "2"), new Case("I", "3")),
            new Arc(new Case("I", "3"), new Case("I", "4")),
            new Arc(new Case("I", "4"), new Case("I", "5")),
            new Arc(new Case("I", "5"), new Case("I", "6")),
            new Arc(new Case("I", "6"), new Case("I", "7")),
            new Arc(new Case("I", "7"), new Case("I", "8")),
            new Arc(new Case("I", "8"), new Case("I", "9")),
            new Arc(new Case("A", "1"), new Case("B", "1")),
            new Arc(new Case("A", "2"), new Case("B", "2")),
            new Arc(new Case("A", "3"), new Case("B", "3")),
            new Arc(new Case("A", "4"), new Case("B", "4")),
            new Arc(new Case("A", "5"), new Case("B", "5")),
            new Arc(new Case("A", "6"), new Case("B", "6")),
            new Arc(new Case("A", "7"), new Case("B", "7")),
            new Arc(new Case("A", "8"), new Case("B", "8")),
            new Arc(new Case("A", "9"), new Case("B", "9")),
            new Arc(new Case("B", "1"), new Case("C", "1")),
            new Arc(new Case("B", "2"), new Case("C", "2")),
            new Arc(new Case("B", "3"), new Case("C", "3")),
            new Arc(new Case("B", "4"), new Case("C", "4")),
            new Arc(new Case("B", "5"), new Case("C", "5")),
            new Arc(new Case("B", "6"), new Case("C", "6")),
            new Arc(new Case("B", "7"), new Case("C", "7")),
            new Arc(new Case("B", "8"), new Case("C", "8")),
            new Arc(new Case("B", "9"), new Case("C", "9")),
            new Arc(new Case("C", "1"), new Case("D", "1")),
            new Arc(new Case("C", "2"), new Case("D", "2")),
            new Arc(new Case("C", "3"), new Case("D", "3")),
            new Arc(new Case("C", "4"), new Case("D", "4")),
            new Arc(new Case("C", "5"), new Case("D", "5")),
            new Arc(new Case("C", "6"), new Case("D", "6")),
            new Arc(new Case("C", "7"), new Case("D", "7")),
            new Arc(new Case("C", "8"), new Case("D", "8")),
            new Arc(new Case("C", "9"), new Case("D", "9")),
            new Arc(new Case("D", "1"), new Case("E", "1")),
            new Arc(new Case("D", "2"), new Case("E", "2")),
            new Arc(new Case("D", "3"), new Case("E", "3")),
            new Arc(new Case("D", "4"), new Case("E", "4")),
            new Arc(new Case("D", "5"), new Case("E", "5")),
            new Arc(new Case("D", "6"), new Case("E", "6")),
            new Arc(new Case("D", "7"), new Case("E", "7")),
            new Arc(new Case("D", "8"), new Case("E", "8")),
            new Arc(new Case("D", "9"), new Case("E", "9")),
            new Arc(new Case("E", "1"), new Case("F", "1")),
            new Arc(new Case("E", "2"), new Case("F", "2")),
            new Arc(new Case("E", "3"), new Case("F", "3")),
            new Arc(new Case("E", "4"), new Case("F", "4")),
            new Arc(new Case("E", "5"), new Case("F", "5")),
            new Arc(new Case("E", "6"), new Case("F", "6")),
            new Arc(new Case("E", "7"), new Case("F", "7")),
            new Arc(new Case("E", "8"), new Case("F", "8")),
            new Arc(new Case("E", "9"), new Case("F", "9")),
            new Arc(new Case("F", "1"), new Case("G", "1")),
            new Arc(new Case("F", "2"), new Case("G", "2")),
            new Arc(new Case("F", "3"), new Case("G", "3")),
            new Arc(new Case("F", "4"), new Case("G", "4")),
            new Arc(new Case("F", "5"), new Case("G", "5")),
            new Arc(new Case("F", "6"), new Case("G", "6")),
            new Arc(new Case("F", "7"), new Case("G", "7")),
            new Arc(new Case("F", "8"), new Case("G", "8")),
            new Arc(new Case("F", "9"), new Case("G", "9")),
            new Arc(new Case("G", "1"), new Case("H", "1")),
            new Arc(new Case("G", "2"), new Case("H", "2")),
            new Arc(new Case("G", "3"), new Case("H", "3")),
            new Arc(new Case("G", "4"), new Case("H", "4")),
            new Arc(new Case("G", "5"), new Case("H", "5")),
            new Arc(new Case("G", "6"), new Case("H", "6")),
            new Arc(new Case("G", "7"), new Case("H", "7")),
            new Arc(new Case("G", "8"), new Case("H", "8")),
            new Arc(new Case("G", "9"), new Case("H", "9")),
            new Arc(new Case("H", "1"), new Case("I", "1")),
            new Arc(new Case("H", "2"), new Case("I", "2")),
            new Arc(new Case("H", "3"), new Case("I", "3")),
            new Arc(new Case("H", "4"), new Case("I", "4")),
            new Arc(new Case("H", "5"), new Case("I", "5")),
            new Arc(new Case("H", "6"), new Case("I", "6")),
            new Arc(new Case("H", "7"), new Case("I", "7")),
            new Arc(new Case("H", "8"), new Case("I", "8")),
            new Arc(new Case("H", "9"), new Case("I", "9")),

        ]

        this.positionJoueur = {
            "rouge": new Case("E", "1"),
            "jaune": new Case("I", "5"),
            "vert": new Case("A", "5"),
            "bleu": new Case("E", "9")
        }

    }


    // add wall
    deleteArc(arc) {
        var newList = this.listArc.filter(function(a) {
            return !a.compareArc(arc)
        })
        this.listArc = newList
    }


    getListArc() {
        return this.listArc
    }


    evaluate() {
        if (this.positionJoueur["rouge"].getY() == "9") {
            if (currentPlayer == 'rouge') return 1
            else return -1
        } else if (this.positionJoueur["jaune"].getX() == "A")
            if (currentPlayer == 'jaune') return 1
            else return -1
        else if (this.positionJoueur["vert"].getX() == "I")
            return -1
        else if (this.positionJoueur["bleu"].getY() == "1") {
            return -1
        } else
            return -1
    }

    // color -> String
    // newPos -> class Case
    setPositionJoueur(color, newPos) {
        this.positionJoueur[color] = newPos
    }

    getPosition() {
        return this.positionJoueur
    }


}