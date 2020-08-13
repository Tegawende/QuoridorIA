const MIN = 0
const MAX = 10000

rougeMovePossible = []
jauneMovePossible = []
vertMovePossible = []
bleuMovePossible = []

const MAXDEPTH = 3

function minimax(depth, nodeIndex, maximizingPlayer, p, board, alpha, beta) {
    // Terminating condition. i.e  
    // leaf node is reached 
    if (board.evaluate() == 1)
        return 1

    rougeMovePossible = moveSetPossible(board, 'rouge')
    jauneMovePossible = moveSetPossible(board, 'jaune')
    vertMovePossible = moveSetPossible(board, 'vert')
    bleuMovePossible = moveSetPossible(board, 'bleu')

    if (depth == MAXDEPTH) {
        return board.getDistanceToWin(p);
    }

    if (maximizingPlayer == 'rouge') {
        if (p == 'rouge') {
            var best = MIN;

            // Recur for left and 
            // right children 
            console.log(rougeMovePossible)
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
        } else if (p == 'jaune') {
            var best = MAX;

            // Recur for left and 
            // right children 
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
        } else if (p == "vert") {
            var best = MAX;

            // Recur for left and 
            // right children 
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

            // Recur for left and 
            // right children 
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
        if (p == 'rouge') {
            var best = MAX;

            // Recur for left and 
            // right children 
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
        } else if (p == 'jaune') {
            var best = MIN;

            // Recur for left and 
            // right children 
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
        } else if (p == "vert") {
            var best = MAX;

            // Recur for left and 
            // right children 
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

            // Recur for left and 
            // right children 
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

//retourn le movement possible pour une possition données
function moveSetPossible(board, joueur) {

    //possition des joueur
    let posJoueurs = { ...board.getPosition() }
    var positionActuel = posJoueurs[joueur]
    delete posJoueurs[joueur]

    // liste des arcs
    var listArc = board.getListArc()


    // calcule deplacement possible 
    var movePossible = []

    movePossible = listArc.filter(function (a) {
        return a.getX().compareCase(positionActuel) || a.getY().compareCase(positionActuel)
    })

    movePossible = restructList(movePossible, positionActuel)

    return movePossible

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


function weshalors() {

}