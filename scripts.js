$(function () {


    var currentPlayer = 'bleu';
    var walls = { "bleu": 5, "rouge": 5, "vert": 5, "jaune": 5 };
    var board = new Board();

    // We create the socket
    const connection = openWebSocket();

    // Player order : bleu -> rouge -> vert -> jaune

    const cells = [
        'a1',
        'a2',
        'a3',
        'a4',
        'a5',
        'a6',
        'a7',
        'a8',
        'a9',
        'b1',
        'b2',
        'b3',
        'b4',
        'b5',
        'b6',
        'b7',
        'b8',
        'b9',
        'c1',
        'c2',
        'c3',
        'c4',
        'c5',
        'c6',
        'c7',
        'c8',
        'c9',
        'd1',
        'd2',
        'd3',
        'd4',
        'd5',
        'd6',
        'd7',
        'd8',
        'd9',
        'e1',
        'e2',
        'e3',
        'e4',
        'e5',
        'e6',
        'e7',
        'e8',
        'e9',
        'f1',
        'f2',
        'f3',
        'f4',
        'f5',
        'f6',
        'f7',
        'f8',
        'f9',
        'g1',
        'g2',
        'g3',
        'g4',
        'g5',
        'g6',
        'g7',
        'g8',
        'g9',
        'h1',
        'h2',
        'h3',
        'h4',
        'h5',
        'h6',
        'h7',
        'h8',
        'h9',
        'i1',
        'i2',
        'i3',
        'i4',
        'i5',
        'i6',
        'i7',
        'i8',
        'i9',
    ];

    yellow = {
        color: 'yellow',
        cell: 'i5',
    };
    red = {
        color: 'red',
        cell: 'e1',
    };

    // For pawns animations
    setTimeout(function () {
        $('#game-info').removeClass('delay-custom');
        $('#bleu').removeClass('bounceInDown faster');
        $('#green').removeClass('bounceInDown faster');
        $('#yellow').removeClass('bounceInDown faster');
        $('#red').removeClass('bounceInDown faster');
    }, 3000);

    // Chatbot inputs
    $('#input-msg').keypress(function (e) {
        if (e.which == 13 && !e.shiftKey) {
            $('#chatbox').append('<label> Vous : ' + $(this).val() + '</label>');
            $('#chatbox').scrollTop($('#chatbox')[0].scrollHeight);
            var question = $(this).val();
            var q = question.normalize('NFD').replace(/[\u0300-\u036f]/g, '');

            var msg = {
                request_type: 'bot',
                question: q,
            };
            $(this).val('');
            e.preventDefault();
            sendMessage(connection, JSON.stringify(msg));
        }
    });

    // Game inputs
    $('#action').keypress(function (e) {
        if (e.which == 13 && !e.shiftKey) {
            var action = $(this).val();
            var msg;
            var $err = $('#error');
            $err.html('');
            var fields = action.split('-');
            var turnCompleted = false;
            console.log("Current player = " + currentPlayer);
            // Action = move
            if (
                fields[0].toLowerCase() == currentPlayer &&
                cells.includes(fields[1].toLowerCase())
            ) {
                cell = fields[1].toUpperCase();

                if (currentPlayer == 'bleu') {
                    var $pawn = $('#bleu');
                    movePawn($pawn, cell);
                    // msg = {
                    // request_type: 'game',
                    // action: 'move',
                    // cell: red.cell,
                    // color: red.color,
                    // };
                } else {
                    var $pawn = $('#green');
                    movePawn($pawn, cell);
                    // msg = {
                    // request_type: 'game',
                    // action: 'move',
                    // cell: yellow.cell,
                    // color: yellow.color,
                    // };
                }
                console.log("Le pion " + currentPlayer + " se déplace en " + cell);
                board.setPositionJoueur(currentPlayer, new Case(cell.charAt(0), cell.charAt(1)));
                console.log("Distance to win = " + (board.getDistanceToWin(currentPlayer)));
                //sendMessage(connection, JSON.stringify(msg));
                turnCompleted = true;
            }
            // Action = wall
            else if (
                fields[0].toLowerCase() == 'mur' &&
                cells.includes(fields[1].toLowerCase()) && ['h', 'v'].includes(fields[2].toLowerCase())
            ) {
                var cell = fields[1].toLowerCase();
                var direction = fields[2].toLowerCase();

                if ((cell.charAt(1) == 1 && direction == "h") || (cell.charAt(1) == 1 && direction == "v") || (cell.charAt(0) == "i" && direction == "v")) {
                    $err.remove();
                    $err.html("Impossible de placer une barrière ici ! ");
                    $('#play-area div').append($err);
                    return;
                }



                addWall(cell, direction);


                // msg = {
                //     request_type: 'game',
                //     action: 'wall',
                //     cell: cell,
                //     direction: direction,
                // };

                // Lister les arcs à supprimer
                let deletedArcs = [];
                let letter = cell.charAt(0).toUpperCase();
                var newLetter = String.fromCharCode(letter.charCodeAt() + 1);
                let num = parseInt(cell.charAt(1), 10);

                console.log("Un mur a été ajouté : " + letter + num + "-" + direction);

                if (direction == "h") {
                    deletedArcs.push(new Arc(new Case(letter, num), new Case(letter, num - 1)));
                    deletedArcs.push(new Arc(new Case(letter, num - 1), new Case(letter, num)));
                    deletedArcs.push(new Arc(new Case(newLetter, num), new Case(newLetter, num - 1)));
                    deletedArcs.push(new Arc(new Case(newLetter, num - 1), new Case(newLetter, num),));
                    console.log("Les arcs (bidirectionnels) suivants ont été supprimés : (" + letter + num + "," + letter + (num - 1) + ") et (" + newLetter + num + "," + newLetter + (num - 1) + ")");
                } else {
                    deletedArcs.push(new Arc(new Case(letter, num), new Case(newLetter, num)));
                    deletedArcs.push(new Arc(new Case(newLetter, num), new Case(letter, num)));
                    deletedArcs.push(new Arc(new Case(letter, num - 1), new Case(newLetter, num - 1)));
                    deletedArcs.push(new Arc(new Case(newLetter, num - 1), new Case(letter, num),));
                    console.log("Les arcs (bidirectionnels) suivants ont été supprimés : (" + letter + num + "," + newLetter + num + ") et (" + letter + (num - 1) + "," + newLetter + (num - 1) + ")");
                }


                console.log(board.getListArc());

                deletedArcs.forEach(arc => {
                    board.deleteArc(arc);
                })

                console.log(board.getListArc());

                //sendMessage(connection, JSON.stringify(msg));
                turnCompleted = true;
            } else {
                // Invalid action
                $err.remove();
                $err.html("L'action '" + action + "' n'est pas valide ! ");
                $('#play-area div').append($err);
            }

            $(this).val('');
            if (turnCompleted) {
                if (currentPlayer == 'bleu') {
                    var bestMove = findBestMove(board, "rouge");
                    var $pawn = $('#red');
                    movePawn($pawn, bestMove.getX().getX() + "" + bestMove.getX().getY());
                    board.setPositionJoueur("rouge", bestMove.getX());
                    console.log("Best move du rouge est : " + bestMove.getX().getX() + "" + bestMove.getX().getY());
                    $('#current-player').html('');
                    $('#current-player').html("vert");
                    currentPlayer = "vert";
                    console.log("Positions = " + JSON.stringify(board.getPosition()));
                } else {
                    currentPlayer = 'jaune';
                    var bestMove = findBestMove(board, "jaune");
                    var $pawn = $('#yellow');
                    movePawn($pawn, bestMove.getX().getX() + "" + bestMove.getX().getY());
                    board.setPositionJoueur("jaune", bestMove.getX());
                    console.log("Best move du jaune est : " + bestMove.getX().getX() + "" + bestMove.getX().getY());
                    $('#current-player').html('');
                    $('#current-player').html("bleu");
                    currentPlayer = "bleu";
                    console.log("Positions = " + JSON.stringify(board.getPosition()));
                }


                var $infoLabel = $('#game-info');
                $infoLabel.remove();
                $('#play-area div').prepend($infoLabel);
            }
        }
    });
});

function movePawn($pawn, cell) {
    $pawn.remove();
    if (!$pawn.hasClass('heartBeat')) {
        $pawn.addClass('heartBeat');
    }
    $('#' + cell.toLowerCase()).append($pawn);
}

function addWall(cell, direction) {
    var $cellA = $('#' + cell.toLowerCase());
    var letter = cell.slice(0, 1);
    var num = parseInt(cell.substr(cell.length - 1), 10);

    // Horizontal wall
    if (direction == 'h') {
        var newLetter = String.fromCharCode(letter.charCodeAt() + 1);
        var $cellB = $('#' + newLetter + '' + num);
        $cellA.css('border-bottom', '4px solid');
        $cellB.css('border-bottom', '4px solid');
    }
    // Vertical wall
    if (direction == 'v') {
        var $cellB = $('#' + letter + '' + (num - 1));
        $cellA.css('border-right', '4px solid');
        $cellB.css('border-right', '4px solid');
    }
}

function isEncoded(uri) {
    uri = uri || '';

    let isEncoded = false;
    try {
        isEncoded = uri !== decodeURIComponent(escape(uri));
    } catch (error) { }

    return isEncoded;
}

function wsMessageHandler(event) {
    const msgTmp = JSON.parse(event.data);
    var msg;
    if (isEncoded(JSON.stringify(msgTmp))) {
        msg = JSON.parse(decodeURIComponent(escape(JSON.stringify(msgTmp))));
    } else {
        msg = msgTmp;
    }
    switch (msg.request_type) {
        case 'game':
            switch (msg.action) {
                case 'move':
                    var $pawn = $('#' + msg.color);
                    setTimeout(function () {
                        movePawn($pawn, msg.cell);
                    }, 1500);
                    //permet de changer la position des différent bot
                    if (msg.color == 'yellow') yellow.cell = msg.cell;
                    else if (msg.color == 'red') red.cell = msg.cell;
                    else green.cell = msg.cell; // si c'est le vert
                    break;
                case 'wall':
                    setTimeout(function () {
                        addWall(msg.cell, msg.direction);
                    }, 1500);
                    break;
                default:
                    console.log('Error !');
                    break;
            }
            break;
        case 'bot':
            setTimeout(function () {
                $('#chatbox').append('<label> QBot : ' + msg.response + '</label>');
                $('#chatbox').scrollTop($('#chatbox')[0].scrollHeight);
            }, 750);
            break;
        default:
            console.log('Error !');
            break;
    }
}

function sendMessage(connection, message) {
    console.log('[Client] sending message ' + message);
    connection.send(message);
}

function openWebSocket() {
    const WS_PROTO = 'ws://';
    const WS_ROUTE = '/quoridorIA';

    connection = new WebSocket(WS_PROTO + window.location.host + WS_ROUTE);
    connection.onerror = (error) => {
        console.log('[Error] ' + JSON.stringify(error));
    };
    connection.onmessage = wsMessageHandler;
    return connection;
}