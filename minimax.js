const MIN = -1000
const MAX = 1000

rougeMovePossible = []
jauneMovePossible = []
vertMovePossible = []
bleuMovePossible = []

const MAXDEPTH = 3


function findBestMove(board, currentPlayer) {
    var bestVal = -1000;
    var bestMove = null;
    movePossible = [];
    var nextPlayer = "";


    if (currentPlayer == "rouge") {
        movePossible = moveSetPossible(board, 'rouge');
        nextPlayer = "vert";
    } else {
        movePossible = moveSetPossible(board, 'jaune');
        nextPlayer = "bleu";
    }


    console.log("MP =" + JSON.stringify(movePossible));

    for (var i = 0; i < movePossible.length; i++) {
        board.setPositionJoueur(currentPlayer, movePossible[i].getY())
        var moveVal = minimax(MAXDEPTH, 0, currentPlayer, currentPlayer, board, MIN, MAX);
        console.log("M val  =" + moveVal + " move =" + JSON.stringify(movePossible[i]));
        if (moveVal > bestVal) {
            bestMove = movePossible[i];
            bestVal = moveVal;
        }
    }

    console.log("BM b =" + JSON.stringify(bestMove));
    return bestMove;

}
function minimax(depth, nodeIndex, maximizingPlayer, currentPlayer, board, alpha, beta) {

    if (board.evaluate() == 1)
        return 1

    rougeMovePossible = moveSetPossible(board, 'rouge')
    jauneMovePossible = moveSetPossible(board, 'jaune')
    vertMovePossible = moveSetPossible(board, 'vert')
    bleuMovePossible = moveSetPossible(board, 'bleu')

    if (depth == MAXDEPTH) {
        return - board.getDistanceToWin(currentPlayer);
    }

    if (maximizingPlayer == 'rouge') {
        if (currentPlayer == 'rouge') {
            var best = MIN;


            for (var i = 0; i < rougeMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, rougeMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'vert', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        } else if (currentPlayer == 'jaune') {
            var best = MAX;

            for (var i = 0; i < jauneMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, jauneMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'bleu', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        } else if (currentPlayer == "vert") {
            var best = MAX;


            for (var i = 0; i < vertMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, vertMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'jaune', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        } else {
            var best = MAX;

            for (var i = 0; i < bleuMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, bleuMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'rouge', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        }
    } else {
        if (currentPlayer == 'rouge') {
            var best = MAX;

            for (var i = 0; i < rougeMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, rougeMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'vert', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        } else if (currentPlayer == 'jaune') {
            var best = MIN;

            for (var i = 0; i < jauneMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, jauneMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'bleu', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        } else if (currentPlayer == "vert") {
            var best = MAX;

            for (var i = 0; i < vertMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, vertMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'jaune', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        } else {
            var best = MAX;

            for (var i = 0; i < bleuMovePossible.length; i++) {
                board.setPositionJoueur(maximizingPlayer, bleuMovePossible[i].getY())
                var val = minimax(depth + 1, nodeIndex * 2 + i, maximizingPlayer, 'rouge', board, alpha, beta);
                best = Math.max(best, val);
                alpha = Math.max(alpha, best);

                // Alpha Beta Pruning 
                if (beta <= alpha)
                    break;
            }
            return best;
        }
    }

}

//Return les movements possibles pour une possition donnée
function moveSetPossible(board, joueur) {

    //Position des joueurs
    let posJoueurs = { ...board.getPosition() }
    var positionActuel = posJoueurs[joueur]
    delete posJoueurs[joueur]

    // Liste des arcs
    var listArc = board.getListArc()


    // Calcule  des déplacements possibles 
    var movePossible = []

    movePossible = listArc.filter(function (a) {
        return a.getX().compareCase(positionActuel) || a.getY().compareCase(positionActuel)
    })

    movePossible = restructList(movePossible, positionActuel)


    var keys = Object.keys(posJoueurs);
    var list = [];
    var list2 = [];
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I"];
    for (var i = 0; i < keys.length; i++) {
        list = movePossible.filter(m => {
            return m.getY().compareCase(posJoueurs[keys[i]]);
        })
    }


    for (var j = 0; j < list.length; j++) {
        if (list[j].getY().getX() == list[j].getX().getX()) {
            if (parseInt(list[j].getY().getY()) > parseInt(list[j].getX().getY())) {
                var y = (parseInt(list[j].getY().getY(), 10) + 1) + "";
                list2.push(new Arc(list[j].getX(), new Case(list[j].getY().getX(), y)))
            } else {
                var y = (parseInt(list[j].getY().getY(), 10) - 1) + "";
                list2.push(new Arc(list[j].getX(), new Case(list[j].getY().getX(), y)))
            }
        } else {
            var l = [];

            l.push(letters.filter(w => {
                return list[j].getX().getX() == w;
            }))

            l.push(letters.filter(w => {
                return list[j].getY().getX() == w;
            }))

            if (letters.indexOf(l[0][0]) > letters.indexOf(l[1][0])) {
                var index = letters.indexOf(l[1][0]) - 1;
                list2.push(new Arc(list[j].getX(), new Case(letters[index], list[j].getX().getY())))
            } else {
                var index = letters.indexOf(l[1][0]) + 1;
                list2.push(new Arc(list[j].getX(), new Case(letters[index], list[j].getX().getY())))
            }
        }


    }
    return movePossible.concat(list2);
}


function restructList(list, pos) {
    for (var j = 0; j < list.length; j++) {
        if (list[j].getY().compareCase(pos)) {
            var n = list[j].getX()
            list[j].setX(list[j].getY())
            list[j].setY(n)
        }

    }
    return list
}

