% INSTRUCTIONS
% Open server.pl with SWI-Prolog
% Use the command start. to start the server
% Then navigate to http://localhost:5000 in your browser


:- module(echo_server,
  [ start/0,
    stop/0
  ]
).


:- use_module(library(lists)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/websocket)).

% http_handler docs: http://www.swi-prolog.org/pldoc/man?predicate=http_handler/3
% =http_handler(+Path, :Closure, +Options)=
%
% * root(.) indicates we're matching the root URL
% * We create a closure using =http_reply_from_files= to serve up files
%   in the local directory
% * The option =spawn= is used to spawn a thread to handle each new
%   request (not strictly necessary, but otherwise we can only handle one
%   client at a time since echo will block the thread)
:- http_handler(root(.),
                http_reply_from_files('.', []),
                [prefix]).
% * root(quoridorIA) indicates we're matching the quoridorIA path on the URL e.g.
%   localhost:5000/quoridorIA of the server
% * We create a closure using =http_upgrade_to_websocket=
% * The option =spawn= is used to spawn a thread to handle each new
%   request (not strictly necessary, but otherwise we can only handle one
%   client at a time since echo will block the thread)
:- http_handler(root(quoridorIA),
                http_upgrade_to_websocket(echo, []),
                [spawn([])]).

start :-
    default_port(Port),
    start(Port).
start(Port) :-
    http_server(http_dispatch, [port(Port)]).

stop() :-
    default_port(Port),
    stop(Port).
stop(Port) :-
    http_stop(Port, []).

default_port(5002).



%! echo(+WebSocket) is nondet.
% This predicate is used to read in a message via websockets and echo it
% back to the client
echo(WebSocket) :-
    ws_receive(WebSocket, Message, [format(json)]),
    ( Message.opcode == close
    -> true
    ; get_response(Message.data, Response),
      write("Response: "), writeln(Response),
      ws_send(WebSocket, json(Response)),
      echo(WebSocket)
    ).

%! get_response(+Message, -Response) is det.
% Pull the message content out of the JSON converted to a prolog dict
% then pass it back up to be sent to the client

%╔════════════════════════════════════════════════════════════════╗
%║                 IA                                             ║
%╚════════════════════════════════════════════════════════════════╝

gauche("i5","h5").
gauche("h5","g5").

haut("e1", "e2").
haut("e2", "e3").

get_response(Message, Response) :-
  Message.request_type = "game",
  gauche(Message.cell,X),
  Response = _{action: 'move', cell: X, color: 'yellow', request_type : 'game' }.

get_response(Message, Response) :-
  Message.request_type = "game",
  haut(Message.cell,X),
  Response = _{action: 'move', cell: X, color: 'red', request_type : 'game' }.



%╔════════════════════════════════════════════════════════════════╗
%║                 Qbot                                           ║
%╚════════════════════════════════════════════════════════════════╝

get_response(Message, Response) :-
  write("\n test"),
  Message.request_type = "bot",
  question_to_keywords(Message.question, Keywords),
  produce_response(Keywords, ResponseTxt),
  Response = _{response : ResponseTxt, request_type : 'bot' }.


/*****************************************************************************/
% question_to_keywords(Question, Keywords)
%  Removes all punctuation characters from the string Question, and converts it
%  into a list of atomic terms, e.g., [this,is,an,example].

question_to_keywords(Question, Keywords) :-
	string_lower(Question, LowerString),
  string_codes(LowerString, Code),
	clean_string(Code,Cleanstring),
  extract_atomics(Cleanstring,Keywords).


/*****************************************************************************/
% produce_response(Keywords, Response) :                          
% Keywords : list of keywords which represents user's question'                                                                        
% Response : the bot response


produce_response(Keywords,Response) :-
   % write(Keywords),
   mclef(M), member(M,Keywords),
   clause(regle_rep(M,Pattern,Response),Body),
   match_pattern(Pattern,Keywords),
   call(Body), !.

produce_response(_,'Désolé, je ne connais pas la réponse à votre question.').

%╔════════════════════════════════════════════════════════════════╗
%║                 Gestion des données entrées                    ║
%╚════════════════════════════════════════════════════════════════╝

match_pattern(Pattern,Lmots) :-
   sublist(Pattern,Lmots).

match_pattern(LPatterns,Lmots) :-
   match_pattern_dist([100|LPatterns],Lmots).

match_pattern_dist([],_).

match_pattern_dist([N,Pattern|Lpatterns],Lmots) :-
   within_dist(N,Pattern,Lmots,Lmots_rem),

   match_pattern_dist(Lpatterns,Lmots_rem).

within_dist(_,Pattern,Lmots,Lmots_rem) :-
   prefixrem(Pattern,Lmots,Lmots_rem),write('\n in1').
within_dist(N,Pattern,[_|Lmots],Lmots_rem) :-
   N > 1, Naux is N-1,
  within_dist(Naux,Pattern,Lmots,Lmots_rem),write('\n in2').


sublist(SL,L) :- 
   prefix(SL,L), !.
sublist(SL,[_|T]) :- sublist(SL,T).

sublistrem(SL,L,Lr) :- 
   prefixrem(SL,L,Lr), !.
sublistrem(SL,[_|T],Lr) :- sublistrem(SL,T,Lr).

prefixrem([],L,L).
prefixrem([H|T],[H|L],Lr) :- prefixrem(T,L,Lr).


% ----------------------------------------------------------------%

taille_jeu(9,9).
nb_barriere_par_joueur(5).

% ----------------------------------------------------------------%

mclef(commence).
mclef(barriere).
mclef(barrieres).
mclef(deplacer).
mclef(placer).
mclef(sauter).
mclef(coup).

% ----------------------------------------------------------------%

regle_rep(commence,
  [ [qui, commence], 3, [jeu] ],
  'C\'est au pion bleu de commencer. Puis aux pions rouge, vert et jaune.').

% ----------------------------------------------------------------%

regle_rep(barrieres,
 [ [ combien ], 3, [ barrieres ], 5, [ debut, du, jeu ] ],
  'Vous disposez de 5 barrieres.').

% ----------------------------------------------------------------%

regle_rep(deplacer,
  [ [deplacer], 3, [barriere], 3, [placee] ],
  'Non').

  % ----------------------------------------------------------------%

regle_rep(sauter,
  [ [sauter], 3, [dessus], 3 , [pion] ],
  'En principe oui mais vous ne pouvez pas enfermer un pion adverse.').

regle_rep(sauter,
  [ [sauter], 3, [audessus], 3 , [pion] ],
  'En principe oui mais vous ne pouvez pas enfermer un pion adverse.').

  % ----------------------------------------------------------------%

regle_rep(placer,
  [ [placer], 3, [barriere], 5, [ou, je, veux] ],
  'Oui, s\'il n\'est pas suivi d\'un autre pion ou d\'une barrière').


  % ----------------------------------------------------------------%

regle_rep(coup, [ [pion], 3, [bleu], 4, [coup] ], Move) :- advice_move(blue, Move).

regle_rep(coup, [ [pion], 3,[vert],4, [coup] ], Move) :- advice_move(green, Move).

regle_rep(coup,[ [pion], 3,[rouge], 4, [coup] ], Move) :- advice_move(red, Move).

regle_rep(coup, [ [pion], 3,[jaune], 4, [coup] ], Move) :- advice_move(yellow, Move).




% À compléter !!! 
% Il faudra utiliser l'IA pour proposer à l'utilisateur un coup 


advice_move(blue, 'bleu-A1').
advice_move(red, 'rouge-A1').
advice_move(yellow, 'jaune-A1').
advice_move(green, 'vert-A1').

/* --------------------------------------------------------------------- */
/*                                                                       */
/*          CONVERSION D'UNE QUESTION DE L'UTILISATEUR EN                */
/*                        LISTE DE MOTS                                  */
/*                                                                       */
/* --------------------------------------------------------------------- */



/*****************************************************************************/
% my_char_type(+Char,?Type)
%    Char is an ASCII code.
%    Type is whitespace, punctuation, numeric, alphabetic, or special.

my_char_type(46,period) :- !.
my_char_type(X,alphanumeric) :- X >= 65, X =< 90, !.
my_char_type(X,alphanumeric) :- X >= 97, X =< 123, !.
my_char_type(X,alphanumeric) :- X >= 48, X =< 57, !.
my_char_type(X,whitespace) :- X =< 32, !.
my_char_type(X,punctuation) :- X >= 33, X =< 47, !.
my_char_type(X,punctuation) :- X >= 58, X =< 64, !.
my_char_type(X,punctuation) :- X >= 91, X =< 96, !.
my_char_type(X,punctuation) :- X >= 123, X =< 126, !.
my_char_type(_,special).


/*****************************************************************************/
% lower_case(+C,?L)
%   If ASCII code C is an upper-case letter, then L is the
%   corresponding lower-case letter. Otherwise L=C.

lower_case(X,Y) :-
	X >= 65,
	X =< 90,
	Y is X + 32, !.

lower_case(X,X).


/*****************************************************************************/
% read_lc_string(-String)
%  Reads a line of input into String as a list of ASCII codes,
%  with all capital letters changed to lower case.

read_lc_string(String) :-
	get0(FirstChar),
	lower_case(FirstChar,LChar),
	read_lc_string_aux(LChar,String).

read_lc_string_aux(10,[]) :- !.  % end of line

read_lc_string_aux(-1,[]) :- !.  % end of file

read_lc_string_aux(LChar,[LChar|Rest]) :- read_lc_string(Rest).


/*****************************************************************************/
% extract_word(+String,-Rest,-Word) (final version)
%  Extracts the first Word from String; Rest is rest of String.
%  A word is a series of contiguous letters, or a series
%  of contiguous digits, or a single special character.
%  Assumes String does not begin with whitespace.

extract_word([C|Chars],Rest,[C|RestOfWord]) :-
	my_char_type(C,Type),
	extract_word_aux(Type,Chars,Rest,RestOfWord).

extract_word_aux(special,Rest,Rest,[]) :- !.
   % if Char is special, don't read more chars.

extract_word_aux(Type,[C|Chars],Rest,[C|RestOfWord]) :-
	my_char_type(C,Type), !,
	extract_word_aux(Type,Chars,Rest,RestOfWord).

extract_word_aux(_,Rest,Rest,[]).   % if previous clause did not succeed.


/*****************************************************************************/
% remove_initial_blanks(+X,?Y)
%   Removes whitespace characters from the
%   beginning of string X, giving string Y.

remove_initial_blanks([C|Chars],Result) :-
	my_char_type(C,whitespace), !,
	remove_initial_blanks(Chars,Result).

remove_initial_blanks(X,X).   % if previous clause did not succeed.


/*****************************************************************************/
% digit_value(?D,?V)
%  Where D is the ASCII code of a digit,
%  V is the corresponding number.

digit_value(48,0).
digit_value(49,1).
digit_value(50,2).
digit_value(51,3).
digit_value(52,4).
digit_value(53,5).
digit_value(54,6).
digit_value(55,7).
digit_value(56,8).
digit_value(57,9).


/*****************************************************************************/
% string_to_number(+S,-N)
%  Converts string S to the number that it
%  represents, e.g., "234" to 234.
%  Fails if S does not represent a nonnegative integer.

string_to_number(S,N) :-
	string_to_number_aux(S,0,N).

string_to_number_aux([D|Digits],ValueSoFar,Result) :-
	digit_value(D,V),
	NewValueSoFar is 10*ValueSoFar + V,
	string_to_number_aux(Digits,NewValueSoFar,Result).

string_to_number_aux([],Result,Result).


/*****************************************************************************/
% string_to_atomic(+String,-Atomic)
%  Converts String into the atom or number of
%  which it is the written representation.

string_to_atomic([C|Chars],Number) :-
	string_to_number([C|Chars],Number), !.

string_to_atomic(String,Atom) :- name(Atom,String).
  % assuming previous clause failed.


/*****************************************************************************/
% extract_atomics(+String,-ListOfAtomics) (second version)
%  Breaks String up into ListOfAtomics
%  e.g., " abc def  123 " into [abc,def,123].

extract_atomics(String,ListOfAtomics) :-
	remove_initial_blanks(String,NewString),
	extract_atomics_aux(NewString,ListOfAtomics).

extract_atomics_aux([C|Chars],[A|Atomics]) :-
	extract_word([C|Chars],Rest,Word),
	string_to_atomic(Word,A),       % <- this is the only change
	extract_atomics(Rest,Atomics).

extract_atomics_aux([],[]).


/*****************************************************************************/
% clean_string(+String,-Cleanstring)
%  removes all punctuation characters from String and return Cleanstring

clean_string([C|Chars],L) :-
	my_char_type(C,punctuation),
	clean_string(Chars,L), !.

clean_string([C|Chars],[C|L]) :-
	clean_string(Chars,L), !.

clean_string([C|[]],[]) :-
my_char_type(C,punctuation), !.
  
clean_string([C|[]],[C]).




:-start.










