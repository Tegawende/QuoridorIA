
$(function() { 

	setTimeout(function(){
		$("#game-info").removeClass("delay-custom")	
		$("#bleu").removeClass("bounceInDown faster");
		$("#green").removeClass("bounceInDown faster");
	}, 3000);

	// Color order : bleu -> rouge -> vert -> jaune
	
	var currentPlayer = "bleu";
	

	// Chatbot
	$("#input-msg").keypress(function (e) {
    if(e.which == 13 && !e.shiftKey) {    
            $("#chatbox").append("<label> Vous : " + $(this).val() + "</label>");
			$("#chatbox").scrollTop($("#chatbox")[0].scrollHeight);
			var msg =  $(this).val();
            $(this).val("");
			e.preventDefault();
        }
    });
	
	
	// Game inputs
	$("#action").keypress(function (e) {
		if(e.which == 13 && !e.shiftKey) { 
			var action = $(this).val();
			
			var $err = $("#error");
			$err.remove();
			
			if(action.startsWith(currentPlayer) || action.startsWith("mur")){
				
			var fields = action.split('-');
			
			// Moves
			if(action.startsWith(currentPlayer)){
				
				var color = fields[0];
				var cell = fields[1];
				var test = fields[2];
				
				if(currentPlayer == "bleu"){
					var $pawn = $("#bleu");
					$pawn.remove();
					if(!$pawn.hasClass("heartBeat")){
						$pawn.addClass("heartBeat");
					}
					$("#" + cell).append($pawn);
				}else{
					var $pawn = $("#green");
					$pawn.remove();
					if(!$pawn.hasClass("heartBeat")){
						$pawn.addClass("heartBeat");
					}
					$("#" + cell).append($pawn);
				}
				
				
			// Walls	
			}else{
				var cell = fields[1];
				var position = fields[2];
			}
		
				
				
			// Update game info label
			if(currentPlayer == "bleu"){
				currentPlayer = "vert";
			}else{
				currentPlayer = "bleu";
			}
			$("#current-player").html("");
			$("#current-player").html(currentPlayer);
			
			var $infoLabel = $("#game-info");
			$infoLabel.remove();
			$("#play-area div").prepend($infoLabel);
				
			}else{
				$err.html("L'action '" + action + "' n'est pas valide ! ");
				$("#play-area div").append($err);
			}
	
			$(this).val("");

		}
	});
	
	

	
 });

