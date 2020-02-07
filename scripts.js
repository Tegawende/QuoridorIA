
$(function() { 


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
			$(this).val("");
		}
	});
	
	
	
 });

