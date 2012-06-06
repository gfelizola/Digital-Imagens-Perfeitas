var vw = $(window).width();
var vh = $(window).height();

var current_nav = '' ;
var isMoving = false ;
var usingKey = false ;
var posAtual = 0 ;
var currentSeta = null ;
var tagsLeft = 0 ;
var ease = 'easeInOutExpo' ;

var Site = {
    Init: function() {
		$('a[href^=http], a[href*=pdf]').click(function () {
            window.open(this.href);
            return false;
        });
    },
	Home: function() {
		$('.menu').hover(function(e){
			$('.menu_container').stop().animate({right:0});
			$('.menu_bg').stop().fadeIn();
		},function(e){
			$('.menu_container').stop().animate({right:-40});
			$('.menu_bg').stop().fadeOut();
		});
		
		$('.menu_container').onePageNav({
			changeHash: true,
			currentClass: 'current_nav',
			easing: ease,
			begin: function(){
				$('.imagem_container').animate({left:0}, 500, 'swing');
			},
			change: function(){
				Nav.Change();
			}
		});
		
		$('.menu_container li a').hover( function(){
			Nav.ColorMenu( $(this).parent('li').index('.menu_container li') );
		}, function(){
			Nav.ColorMenu();
		});
		
		$('.direcionais a').hover(function(e){
			var props = {opacity:1};
			if( $(this).hasClass('cima') ) props.top = 10 ;
			if( $(this).hasClass('baixo') ) props.bottom = 10 ;
			if( $(this).hasClass('direita') ) props.right = 10 ;
			if( $(this).hasClass('esquerda') ) props.bottom = 10 ;
			
			$(this).children('span').stop().animate(props, 300, 'swing');
			currentSeta = this ;
		},function(e){
			var props = {opacity:0};
			if( $(this).hasClass('cima') ) props.top = 30 ;
			if( $(this).hasClass('baixo') ) props.bottom = 30 ;
			if( $(this).hasClass('direita') ) props.right = 30 ;
			if( $(this).hasClass('esquerda') ) props.bottom = 30 ;
			
			$(this).children('span').stop().animate(props, 300, 'swing');
			currentSeta = null ;
			
		}).click(function(e) {
			var atual = $('.menu_container').find('li.current_nav');
			if( atual.length == 0 ) atual = $('.menu_container').find('li:eq(0)');
			
			if( $(this).hasClass('esquerda') ){
				if( ! isMoving && $(this).is(':visible') ){
					isMoving = true;
					$('.direcionais a.direita').show();
					posAtual -- ;
					Nav.Move();
				}
				
			} else if( $(this).hasClass('direita') ){
				if( ! isMoving && $(this).is(':visible') ){
					$('.direcionais a.esquerda').show();
					posAtual ++ ;
					Nav.Move();
				}
				
			} else if( $(this).hasClass('cima') && $(this).is(':visible') ){
				atual.prev().find('a').click();
				Nav.Change();
			} else if( $(this).hasClass('baixo') && $(this).is(':visible') ){
				atual.next().find('a').click();
				Nav.Change();
			}
					
			
			
		}).attr('href','javascript:void(0)');
		
		$(window).keydown(function (e) {
			usingKey = true ;
			if (e.keyCode == 38) {
				$('.direcionais a.cima').click();
				e.preventDefault();
			} else if (e.keyCode == 40) {
				$('.direcionais a.baixo').click();
				e.preventDefault();
			} else if (e.keyCode == 37) {
				$('.direcionais a.esquerda').click();
				e.preventDefault();
			} else if (e.keyCode == 39) {
				$('.direcionais a.direita').click();
				e.preventDefault();
			}
			
			usingKey = false ;
		});
		
		var hash = window.location.hash ;
		if( hash != '' )
		{
			var spl = hash.split('/');
			if( spl.length >= 1 )
			{
				$('.menu_container li a[href="' + spl[0] + '"]').parent('li').addClass('current_nav');
				Nav.Change();
				
				if( spl.length > 1 ){
					var id = spl[1] ;
					posAtual = $(current_nav + ' .imagem_container .imagem[data="' + id + '"]').index() ;
					Nav.Move();
				}
			}
		} else {
			$('.menu_container li:eq(0)').addClass('current_nav');
			Nav.Change();
		}
		
		var qtde = $('.menu_container li').length ;
		var r = 110, g = 31, b = 171, inicial = 0 ;
		for( var i = inicial; i < qtde ; i++ ) {
			r -= 5 ; g += 18 ; b += 6 ;
			$('.menu_container li:eq(' + i + ') a span').css('background-color', 'rgb(' + r + ', ' + g + ', ' + b + ')');
		}
		
		$('#form_contato').validate({
			errorLabelContainer:$('.errors') 	
		});
	},
	Resize: function() {
		
		function DoResize(e){
			vw = $(window).width();
			vh = $(window).height();
			tagsLeft = ( vw / 2 + 100 ) ;
			
			$('.primeira div').css({
				left:( (vw / 2) - (534 / 2) ) + 'px',
				top:( (vh / 2) - (301 / 2) - 118 ) + 'px'
			});
			
			$('.area').each(function(index, element) {
				var imc = $(this).children('.imagem_container');
				imc.width( imc.children('div').length * vw );
				imc.children('.imagem').width(vw);
				imc.children('.primeira').width(vw);
			});
			
			$('.tags').css({
				left: tagsLeft + 'px',
				top:  ( vh / 2 - 25 ) + 'px'
			});
			
			$( '.direcionais a' ).each(function(index, element) {
				var props = {opacity:0};
				if( $(this).hasClass('cima') ) props.left = ( vw / 2 ) - 31 ;
				if( $(this).hasClass('baixo') ) props.left = ( vw / 2 ) - 31 ;
				if( $(this).hasClass('direita') ) props.top = ( vh / 2 ) - 31 ;
				if( $(this).hasClass('esquerda') ) props.top = ( vh / 2 ) - 31 ;
				
				$(this).find('span').css(props);
			});
		}
		
		$(window).resize(DoResize);
		DoResize();
	}
}

var Nav = {
	Change: function(){
		var atual = $('.menu_container').find('li.current_nav').find('a');
		var at = atual;
		var oldNav = '' ;
		if( current_nav != at.attr('href') ){
			oldNav = current_nav ;
			current_nav = at.attr('href') ;
			posAtual = 0;
			
			$('.imagem_container').delay(300).animate({left:0}, 1200, 'easeInOutExpo');
			Nav.HideSeta('esquerda');
			
			if( current_nav == '#home' || current_nav == '#contato' ){
				Nav.HideSeta('direita');
				
				if( current_nav == '#home' ){
					Nav.HideSeta('cima');
				}
				if( current_nav == '#contato' ){
					Nav.HideSeta('baixo');
					$('.direcionais').css('height','100px');
				}
			} else {
				Nav.ShowSeta('cima');
				Nav.ShowSeta('baixo');
				Nav.ShowSeta('direita');
				
				$('.direcionais').css('height','100%');
			}
			
			var corLogo = 'branco' ;
			var corPelaDiv = $(current_nav).attr('logo') ;
			if( corPelaDiv != undefined ) corLogo = corPelaDiv ;
			$('.logo').removeClass('branco').removeClass('preto').addClass( corLogo.toLowerCase() );
			/*
			$('.logo').stop().fadeIn();
			if( oldNav != '' ){
				$( oldNav + ' .tags').stop().delay(1500).fadeIn();
			}
			*/
			Nav.ColorMenu();
			Nav.UpdateShare();
		}
	},
	
	Move: function()
	{
		isMoving = true;
		var pos = posAtual * vw * -1 ;
		
		if( posAtual >= $(current_nav + ' .imagem_container').children('div').length - 1 ) $('.direcionais a.direita').hide();
		if( posAtual <= 0 ) $('.direcionais a.esquerda').hide();
		
		var imgAtual = $(current_nav + ' .imagem_container .imagem:eq(' + (posAtual-1) + ')') ;
		var imgId = imgAtual.attr('data')
		var hashStr = current_nav ;
		if( imgId != undefined ) hashStr += '/' + imgId ;
		
		$(current_nav + ' .imagem_container, .logo').animate({left:pos}, 800, ease, function(){
			isMoving = false ;
			window.location.hash = hashStr ;
			Nav.UpdateShare();
		});
		
		$(current_nav + ' .tags').animate({left:pos + tagsLeft}, 800, ease);
		
		//$(current_nav + ' .imagem_container .imagem div').fadeIn();
		/*
		if( posAtual > 0 ){
			$(' .tags, .logo').stop().fadeOut();
		} else {
			$(' .tags, .logo').stop().fadeIn();
		}
		*/
	},
	
	UpdateShare: function(){
		var facebook = 'http://www.facebook.com/sharer.php?u=' + encodeURIComponent( window.location.href ) + '&t=Digital%20Imagens%20Perfeitas' ;
		var twitter = 'https://twitter.com/share?url=' + encodeURIComponent( window.location.href ) ;
		
		$('a.facebook').attr('href', facebook);
		$('a.twitter').attr('href', twitter);
	},
	
	ShowSeta: function(direcao){
		$( '.direcionais a.' + direcao ).show();
		if( ! $(currentSeta).hasClass(direcao) ) {
			$('.direcionais a.' + direcao + ' span').css({opacity:0});
		}
	},
	
	HideSeta: function(direcao){
		$('.direcionais a.' + direcao ).hide();
		if( ! $(currentSeta).hasClass(direcao) ) {
			$('.direcionais a.' + direcao + ' span').css({opacity:0});
		}
	},
	
	ColorMenu: function( indice ){
		var qtde = $('.menu_container li').length ;
				
		var r = 110, g = 31, b = 171 ;
		var inicial = $('.menu_container li.current_nav').css('background-color', 'rgb('+r+','+g+','+b+')').index('.menu_container li');
		if( indice != null ) inicial = indice ;
		
		for( var i = inicial; i < qtde ; i++ ) {
			r -= 5 ; g += 18 ; b += 6 ;
			$('.menu_container li:eq(' + i + ') a').css('background-color', 'rgb('+r+','+g+','+b+')');
		}
		for( i = 0; i < inicial ; i++ ) {
			r -= 5 ; g += 18 ; b += 6 ;
			$('.menu_container li:eq(' + i + ') a').css('background-color', 'rgb('+r+','+g+','+b+')');
		}
	}
}