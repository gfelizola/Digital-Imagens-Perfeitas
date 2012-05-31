var ModalWindow = {
	
	parent: "body",
	windowId: null,
	content: null,
	width: null,
	height: null,
	
	Close:function(){
		if (!$.browser.msie) {
            $(".external-modal-window").fadeOut(700, function() {
                $(this).remove();
                $(".external-modal-overlay").fadeOut(300, function() {
                    $(this).remove();
                })
            })
        } else {
            $(".external-modal-window, .external-modal-overlay").remove();
        }
	},
	
	Open:function(){

		var Modal =
			"<div class=\"external-modal-overlay dn\"></div>"+
			"<div id=\"" + this.windowId + "\" class=\"external-modal-window dn\" style=\"width:" + this.width + "px; height:" + this.height + "px; margin-top:-" + (this.height / 2) + "px; margin-left:-" + (this.width / 2) + "px;\">"+
				this.content+
			"</div>";
		
		$(this.parent).append(Modal);
		
		if(!$.browser.msie){
			$('.external-modal-overlay').fadeIn(700, function(){
				$('.external-modal-window').fadeIn(300);
			});
		}else{
			$('.external-modal-overlay, .external-modal-window').show();
		}
		$(".external-modal-window").append("<a class=\"external-modal-close\" title=\"Clique para fechar a janela\">Fechar X</a>");
		$(".external-modal-close").click(function(){ModalWindow.Close();});
		//$(".external-modal-overlay").click(function(){ModalWindow.close();});
	}
};