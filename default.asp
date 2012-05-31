<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- #include file="admin/includes/funcoes.asp" -->
<!-- #include file="admin/includes/commons.asp" -->
<!-- #include file="admin/includes/conexao.asp" -->
<!-- #include file="admin/includes/dao.asp" -->
<% URLXML = Server.MapPath( "admin/xml/config.xml" ) %>
<!-- #include file="admin/includes/get_dados.asp" -->
<% 
Set Dao = new GlobalDAO 
%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="pt-br" lang="pt-br">
	<head>
		<meta http-equiv="content-type" 		content="text/html; charset=utf-8" 													/>
   		
		<title>Digital Imagens Perfeitas</title>
		
		<meta http-equiv="Content-Style-Type"	content="text/css"																	/>
		<meta http-equiv="Content-Language" 	content="pt-br" 																	/>
		<meta http-equiv="pragma" 				content="no-cache"																	/>
		<meta http-equiv="cache-control" 		content="no-cache"																	/>
		<meta name="expires" 					content="0"																			/>
		<meta name="robots" 					content="all" 																		/>
		<meta name="robots" 					content="index,follow" 																/>
		<meta name="title" 						content=""																			/>
		<meta name="description" 				content="" 																			/>
		<meta name="keywords" 					content=""																			/>
		<meta name="distribution" 				content="Global"		 															/>
		
		<link rel="shortcut icon" 				type="image/ico" 								href="img/common/favicon.ico" 		/>
		
		<link rel="stylesheet" 					type="text/css" 	media="screen, projection" 	href="css/screen.css" 				/>

		<!--[if IE 7]>
		<link rel="stylesheet" 					type="text/css" 	media="screen, projection" 	href="css/hackIe7.css" 				/>
		<![endif]-->
        <!--[if IE 8]>
		<link rel="stylesheet" 					type="text/css" 	media="screen, projection" 	href="css/hackIe8.css" 				/>
		<![endif]-->
        <!--[if IE 9]>
		<link rel="stylesheet" 					type="text/css" 	media="screen, projection" 	href="css/hackIe9.css" 				/>
		<![endif]-->
		
		<style>
		<!-- #include file="estilos.asp" -->
		</style>
		
		<!--[if gte IE 9]>
		<style type="text/css">
			.gradiente { filter: none; }
		</style>
		<![endif]-->
		
		<script type="text/javascript" 			src="js/lib/jquery/jquery-1.7.2.min.js"		></script>
		<script type="text/javascript" 			src="js/lib/jquery/jquery.easing.js"		></script>
		<script type="text/javascript" 			src="js/lib/jquery/jquery.scrollTo.js"		></script>
		<script type="text/javascript" 			src="js/lib/jquery/jquery.nav.js"			></script>
		<script type="text/javascript" 			src="js/lib/jquery/jquery.validate.js"		></script>
		<script type="text/javascript" 			src="js/main.js"							></script>
	</head>
	<body>
		<div id="site">
			<h1 class="logo preto rep">Digital Imagens Perfeitas</h1>
			
			<div class="menu_bg"></div>
			<div class="menu">
				<ul class="menu_container">
					<li><a href='#home'><span>Home</span></a></li>
					<%
					Dao.Init "Categorias", Dados
					Dao.OrderBy = "Ordem"
					Set Lista = Dao.FindAll
					
					For Each Categoria In Lista.Items
						OutL( "<li><a href='#" & Categoria.Item("Sigla") & "'><span>" & Categoria.Item("Nome") & "</span></a></li>" )
					Next
					%>
					<li><a href='#contato'><span>Contato</span></a></li>
				</ul>
			</div>
			
			<div class="share">
				<a href="https://twitter.com/share?url=http%3A%2F%2Fwww.digital.ppg.br" class="twitter repfl" title="Compartilhar no Twitter">Compartilhar no Twitter</a>
				<a href="http://www.facebook.com/sharer.php?u=http%3A%2F%2Fwww.digital.ppg.br&t=Digital%20Imagens%20Perfeitas" class="facebook repfl" title="Compartilhar no Facebook">Compartilhar no Facebook</a>
				<a href="#" class="feed repfl" title="Mantenha-se atualizado">Mantenha-se atualizado</a>
			</div>
			<div class="direcionais">
				<a href="#" class="cima pa"><span class="rep">Área Anterior</span></a>
				<a href="#" class="direita pa"><span class="rep">Próxima Imagem</span></a>
				<a href="#" class="esquerda pa"><span class="rep">Imagem Anterior</span></a>
				<a href="#" class="baixo pa"><span class="rep">Próxima Área</span></a>
			</div>

			<div id="content">
				<div id="home" class="area gradiente pr">
					<div class="tags"></div>
					<div class="imagem_container">
						<div class="imagem"><img src="img/olho_digital.gif" /></div>
					</div>
				</div>
				
				<%
				Dao.Init "Imagens", Dados
				Dao.OrderBy = "Ordem"
				Dao.MaxRows = 1
				
				For Each Categoria In Lista.Items
					OutL( "<div id='" & Categoria.Item("Sigla") & "' class='area gradiente pr' logo='" & Categoria.Item("Cor_Logo") & "'>" )
						OutL( "<div class='tags'></div>" )
						OutL( "<div class='imagem_container'>" )
							OutL( "<div class='primeira'>" )
								OutL( "<div>" )
									OutL( "<img src='arquivos/Categorias_primeira_" & Categoria.Item("Sigla") & ".jpg' height='100%' />" )
								OutL( "</div>" )
							OutL( "</div>" )
							
						Set Imagens = Dao.FindByWhere("Categoria = " & Categoria.Item("Codigo") )
						If Imagens.Count > 0 Then
							For Each Img In Imagens.Items
								
								OutL( "<div class='imagem' data='" & Img.Item("Codigo") & "'>" )
								
								If InStr( Img.Item("Arquivo"), "youtube" ) > 0 Then
									QS = Split( Img.Item("Arquivo"), "?")
									Attrs = Split( QS( Ubound( QS ) ), "&")
									For i = 0 To Ubound( Attrs )
										If InStr (Attrs(i) ,"v") > 0 Then
											Vars = Split( Attrs(i), "=" )
											Codigo = Vars( Ubound(Vars) )
										End If
									Next
								
									OutL( "<iframe width='640' height='480' src='https://www.youtube.com/embed/" & Codigo & "' frameborder='0' allowfullscreen></iframe>")
								Else
									OutL( "<img src='arquivos/" & Img.Item("Arquivo") & "' />" )
								End If
								
								OutL( "</div>" )
							Next
						End If
						
						OutL( "</div>" )
					OutL( "</div>" )
				Next
				%>
				
				<div id="contato" class="area gradiente pr" logo="preto">
					<div class="conteudo_contato">
						<h2 class="titulo">CONTATO</h2>
						<form id="form_contato" action="envia.asp" method="post">
							<fieldset>
								<label>Email:
									<input type="text" name="Email" id="Email" class="required email" title="O campo Email é obrigatório e deve ser um e-mail válido" value="" />
								</label>
							</fieldset>
							<fieldset>
								<label>Nome:
									<input type="text" name="Nome" id="Nome" class="required" title="O campo Nome é obrigatório" value="" />
								</label>
							</fieldset>
							<fieldset>
								<label>Mensagem:
									<textarea name="Mensagem" id="Mensagem" class="required" title="O campo Mensagem é obrigatório"></textarea>
								</label>
							</fieldset>
							<input type="submit" name="Enviar" id="Enviar" value="ENVIAR" />
							<div class="errors dn"></div>
							<% If RQ("sucesso") = "true" Then OutL("<p class='sucesso'>CONTATO ENVIADO COM SUCESSO</p>") %>
						</form>
						
						<div class="dados">
							<p class="endereco">Rua Arizona, 1426 2º andar<br />
								Brooklin Paulista<br />
								São Paulo - SP</p>
							<p class="telefone">Fone:<br />
								sp 11.3345.1020<br />
								poa 51.3062.7404</p>
							<p class="email"><a href="mailto:digital@digitalppg.com">digital@digitalppg.com</a></p>
						</div>
					</div>
				</div>
		</div>
   		
		
		<script type="text/javascript">
		    $(document).ready(function() {
				Site.Init();
				Site.Home();
			});
			Site.Resize();
		</script>
	</body>
<% 
Set Dao = Nothing 
%>
</html>