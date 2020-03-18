% INSTRUCTIONS
% Open server.pl with SWI-Prolog
% Use the command start. to start the server
% Then navigate to http://localhost:4000 in your browser


:- module(echo_server,
  [ start/0,
    stop/0
  ]
).


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
%   localhost:3000/quoridorIA of the server
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

default_port(4000).

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

% Game behaviour
get_response(Message, Response) :-
  game_request(Message.request_type),
  Response = _{action:'move',  cell: 'a2', color : 'red', request_type : 'game' }.



% Bot behaviour 
get_response(Message, Response) :-
  bot_request(Message.request_type),
  bot_response(Message.question, BotResponse),
  Response = _{response : BotResponse, request_type : 'bot' }.

% Code du bot à compléter ici
bot_response(X,'Désolé, je ne suis pas encore fonctionnel :)').


game_request("game").
bot_request("bot").