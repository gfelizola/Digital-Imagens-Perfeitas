// JavaScript Document
$(function() {
	$.datepicker.regional['pt-BR'] = {
		closeText: 'Fechar',
		prevText: '&#x3c;Anterior',
		nextText: 'Pr&oacute;ximo&#x3e;',
		currentText: 'Hoje',
		monthNames: ['Janeiro','Fevereiro','Mar&ccedil;o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
		monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'],
		dayNames: ['Domingo','Segunda-feira','Ter&ccedil;a-feira','Quarta-feira','Quinta-feira','Sexta-feira','S&aacute;bado'],
		dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','S&aacute;b'],
		dayNamesMin: ['Dom','Seg','Ter','Qua','Qui','Sex','S&aacute;b'],
		weekHeader: 'Sm',
		dateFormat: 'dd/mm/yy',
		firstDay: 0,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
		
	$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
	
	//BOTÕES
	$('.botao').button();
	$('.botoes').buttonset();
	//$('#opcoes_relatorios').buttonset();
	
	$('.btSelecionarTodos').click(function(e) {
		$('.Fabrica' + $( this ).attr('rel') ).attr('checked', true);
	});
	
	$('.btDeselecionarTodos').click(function(e) {
		$('.Fabrica' + $( this ).attr('rel') ).attr('checked', false);
	});
	
	$('#FabricaAtual').change(function(e) {
		var valor = $(this).val() ;
		if( valor != "" ){
			var url = window.location.href ;
			if( url.indexOf('?') >= 0 ){
				url = url.split('?')[0];
			}
			url += '?fa=' + valor ;
			window.location.href = url ;
		}
	});
	
	$('.tipo_galeria').change(function(e) {
		var valor = $(this).val() ;
		if( valor != "" ){
			var url = window.location.href ;
			if( url.indexOf('tg') >= 0 ){
				url = url.split('?')[0];
			}
			url += '?tg=' + valor ;
			window.location.href = url ;
		}
	});
	
	$('#FiltroArea').change(function(e) {
		var valor = $(this).val() ;
		if( valor != "" ){
			var url = window.location.href ;
			if( url.indexOf('?') >= 0 ){
				url = url.split('?')[0];
			}
			url += '?area=' + valor ;
			window.location.href = url ;
		}
	});
	
	$('#login-dialog-confirm').dialog({
		modal: true,
		buttons: {
			Ok: function() {
				$(this).dialog('close');
			}
		}
	});
	
	$('tr.linha-lista').hover( 
		function(){
			$(this).removeClass('ui-widget-content');
			$(this).addClass('ui-state-highlight');
		},
		function(){
			$(this).addClass('ui-widget-content');
			$(this).removeClass('ui-state-highlight');
		}
	);	
	
	// VALIDAÇÕES
	$.validator.setDefaults({
		highlight: function(input) {
			$(input).addClass("ui-state-highlight");
		},
		unhighlight: function(input) {
			$(input).removeClass("ui-state-highlight");
		}
	});

	$('#form-validate').validate({ 
		errorLabelContainer:$('#errors-container') 
	});
	
	// MÁSCARAS
	$(".telefone-mask").mask("(99) 9999-9999");
	$(".cep-mask").mask("99999-999");
	$(".data-mask").mask("99/99/9999");
	$(".cnpj-mask").mask("99.999.999/9999-99");
	
	$('.corpicker').ColorPicker({
		onSubmit: function(hsb, hex, rgb, el) {
			$(el).val('#'+hex);
			$(el).ColorPickerHide();
		},
		onBeforeShow: function () {
			$(this).ColorPickerSetColor(this.value);
		}
	})
	.bind('keyup', function(){
		$(this).ColorPickerSetColor(this.value);
	});

	// COMBOBOX
	$.widget( "ui.combobox", {
		_create: function() {
			var self = this;
			var select = this.element.hide(),
				selected = select.children( ":selected" ),
				value = selected.val() ? selected.text() : "";
			var input = $( "<input>" )
				.insertAfter( select )
				.val( value )
				.autocomplete({
					delay: 0,
					minLength: 0,
					source: function( request, response ) {
						var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
						response( select.children( "option" ).map(function() {
							var text = $( this ).text();
							if ( this.value && ( !request.term || matcher.test(text) ) )
								return {
									label: text.replace(
										new RegExp(
											"(?![^&;]+;)(?!<[^<>]*)(" +
											$.ui.autocomplete.escapeRegex(request.term) +
											")(?![^<>]*>)(?![^&;]+;)", "gi"
										), "<strong>$1</strong>" ),
									value: text,
									option: this
								};
						}) );
					},
					select: function( event, ui ) {
						ui.item.option.selected = true;
						//select.val( ui.item.option.value );
						self._trigger( "selected", event, {
							item: ui.item.option
						});
						if( select.attr('id') == "Instituicao" ){
							var id = ui.item.option.value ;
							$('#historico').attr('src','../Instituicao/Historico.asp?id=' + id );
							$('#Onibus').attr("checked", TemOnibus( id ) ).button("refresh");
							$('#Telefone').val( GetTelefone( id ) ) ;
							$('#Email').val( GetEmail( id ) ) ;
						}
					},
					change: function( event, ui ) {
						if ( !ui.item ) {
							var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
								valid = false;
							select.children( "option" ).each(function() {
								if ( this.value.match( matcher ) ) {
									this.selected = valid = true;
									return false;
								}
							});
							if ( !valid ) {
								$( this ).val( "" );
								select.val( "" );
								return false;
							}
						}
						
					}
				})
				.addClass( "ui-widget ui-widget-content ui-corner-left" )
				.css('height','24px')
				.css('width','250px');

			input.data( "autocomplete" )._renderItem = function( ul, item ) {
				return $( "<li></li>" )
					.data( "item.autocomplete", item )
					.append( "<a>" + item.label + "</a>" )
					.appendTo( ul );
			};

			$( "<button type='button'>&nbsp;</button>" )
				.attr( "tabIndex", -1 )
				.attr( "title", "Ver opções" )
				.insertAfter( input )
				.button({
					icons: {
						primary: "ui-icon-triangle-1-s"
					},
					text: false
				})
				.removeClass( "ui-corner-all" )
				.addClass( "ui-corner-right ui-button-icon" )
				.css('margin-top','5px')
				.click( function() {
					if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
						input.autocomplete( "close" );
						return;
					}

					// pass empty string as value to search for, displaying all results
					input.autocomplete( "search", "" );
					input.focus();
				});
			}
		});
		
		//COMBOS DE ROTEIROS
		$(".combobox").combobox();
	}
);