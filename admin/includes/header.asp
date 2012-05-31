<table id="tblConteudo" align="left" cellpadding="5" width="100%">
	<thead>
		<tr class="ui-widget-header">
			<th><a href="/" target="_blank"><img src="../images/logo.png" /></a></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td class="ui-widget-content">
				<div id="menu" class="botoes">
					<%
					Regras = Session("Usuario_Login").Item("Regras")
					SRegras = Split( Regras , "," )
					For i = 0 To Ubound( SRegras )
						Regra = Trim( SRegras(i) )
						Response.Write("<a href='../" & Regra & "' 	id='menu'>" & Dados.Item( Regra & "Nome" ) & "</a>")
					Next
					%>
				</div>
				<div id="usuarioLogado">
					Olá, <strong><%=Session("Usuario_Login").Item("Nome")%></strong> (<a href="../Login/logoff.asp">Sair</a>)<br />
				</div>
			</td>
		</tr>
		<tr>
			<td>
			