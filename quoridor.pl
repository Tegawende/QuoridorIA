% move(+Pos, -NextPos)
% True if there is a legal (according to rules) move from Pos to NextPos.
move([X1, play, Board], [X2, win, NextBoard]) :-
    nextPlayer(X1, X2),
    move_aux(X1, Board, NextBoard),
    winPos(X1, NextBoard), !.


move([X1, play, Board], [X2, play, NextBoard]) :-
    nextPlayer(X1, X2),
    move_aux(X1, Board, NextBoard).

% move_aux(+Player, +Board, -NextBoard)
% True if NextBoard is Board whith an empty case replaced by Player mark.
move_aux(P, [0|Bs], [P|Bs]).

move_aux(P, [B|Bs], [B|B2s]) :-
    move_aux(P, Bs, B2s).


% blue_to_move(+Pos)
% True if the next player to play is the blue player.
blue_to_move([blue, _, _]).

% jaune_to_move(+Pos)
% True if the next player to play is the jaune player.
jaune_to_move([jaune, _, _]).

% rouge_to_move(+Pos)
% True if the next player to play is the rouge player.
rouge_to_move([rouge, _, _]).

% vert_to_move(+Pos)
% True if the next player to play is the vert player.
vert_to_move([vert, _, _]).

% utility(+Pos, -Val) :-
% True if Val the the result of the evaluation function at Pos.
% We will only evaluate for final position.
% So we will only have MAX win, MIN win or draw.
% We will use  1 when MAX win
%             -1 when MIN win
%              0 otherwise.
utility([jaune, win, _], 1).       % Previous player (MAX) has win.
utility([vert, win, _], 1).      % Previous player (MIN) has win.
utility([bleu, win, _], 1).
utility([rouge, win, _], 1).
utility([jaune, fail, _], -1).       
utility([vert, fail, _], -1).     
utility([bleu, fail, _], -1).
utility([rouge, fail, _], -1).


% winPos(+Player, +Color)
% True if Player win in Board.
winPos([C|L], Color) :-
    ligneArriver(Color, C); 
    ligneArriver(Color, L).


% ligneArriver(Color, Arriver).
% return la ligne d arriver
ligneArriver( 'blue', '1').
ligneArriver( 'rouge', '9').
ligneArriver( 'vert', 'i').
ligneArriver( 'jaune', 'a').
