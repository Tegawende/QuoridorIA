function minimax(depth, nodeIndex, maximizingPlayer, values, alpha, beta) {
    // Terminating condition. i.e  
    // leaf node is reached 
    if (depth == 3)
        return values[nodeIndex];

    if (maximizingPlayer) {
        var best = MIN;

        // Recur for left and 
        // right children 
        for (var i = 0; i < 2; i++) {
            var val = minimax(depth + 1, nodeIndex * 2 + i,
                false, values, alpha, beta);
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
        for (var i = 0; i < 2; i++) {

            var val = minimax(depth + 1, nodeIndex * 2 + i,
                true, values, alpha, beta);
            best = Math.min(best, val);
            beta = Math.min(beta, best);

            // Alpha Beta Pruning 
            if (beta <= alpha)
                break;
        }
        return best;
    }

}