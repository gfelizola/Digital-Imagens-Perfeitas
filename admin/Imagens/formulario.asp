<!-- #include file="../includes/head.asp" -->
<%
Id = Request.QueryString("id")
Erro = Request.QueryString("e")
Acao = Request.QueryString("ac")
Acao = VerificaAcao(acao, "../" & SessaoAtual)

Set Objeto = Server.CreateObject("Scripting.Dictionary")
For Each Col In Dados.Item(SessaoAtual)
	Objeto.Add Col, ""
Next

Set Dao = new GlobalDAO
Dao.Init SessaoAtual, Dados
Dao.Lazy = True

Objeto.Item("Ordem") = Dao.Counter("Categoria = " & Session.Contents(sessaoAtual & "_area")) + 1

If id <> "" Then
	
	Set Objeto = Dao.FindByCodigo( id )	
	
	If acao = "editar" Then
		If TypeName(Objeto) = "Nothing" Then
			Session("sucesso") = "Registro não encontrado."
			Response.Redirect("../" & SessaoAtual)
		End If
	Else
		If ApagarRegistro( Dao, Id ) Then
			If TypeName(Objeto) <> "Nothing" Then
				Set fso = Server.CreateObject("Scripting.FileSystemObject")
				
				Arquivo = UploadsDirVar & "\" & Objeto.Item("Arquivo")
				
				If fso.FileExists(Arquivo) Then
					fso.DeleteFile Arquivo, True
				End If
				
				Set fso = Nothing
			
				SQL = "UPDATE " & SessaoAtual & " SET Ordem = Ordem - 1 WHERE Ordem > " & Objeto.Item("Ordem") & " AND Categoria = " & Session.Contents(sessaoAtual & "_area")
				Dao.Exec SQL
			End If
			
			Session("sucesso") = "Registro removido com sucesso"
			Response.Redirect("../" & SessaoAtual)
		End If
	End If
End If
Set Dao = Nothing
%>
<body>
<!-- #include file="../includes/header.asp" -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td valign="top">
			<table align="left" cellpadding="5" width="100%">
				<tr>
					<td width="300" nowrap="nowrap" class="titulo_area"><%=Dados.Item( SessaoAtual & "Nome" )%></td>
					<td>
						<%
						If Session("Sucesso") <> "" Then
						%>
						<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"> 
							<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span> 
							<strong>Alerta:</strong> <%=Session("Sucesso")%>.</p>
						</div>
						<%
						Session("Sucesso") = ""
						End If
						%>
					</td>
					<td width="100" nowrap="nowrap" align="right"><a href='../<%=SessaoAtual%>' class="botao">Cancelar</a></td>
				</tr>
			</table>
			<form id="form-validate" action="acoes.asp?ac=<%=acao%>&id=<%=id%>" enctype="multipart/form-data" method="post">
			
			<table align="left" cellpadding="5" width="100%" class="ui-widget-content ui-corner-all">
				<tbody>
					<tr>
						<td colspan="6">
							<div id="errors-container" class="ui-state-error ui-corner-all" style="padding: .7em; display:none;">
								<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
								<span id="container"></span>
							</div>
						</td>
					</tr>
					
					<tr>
						<td width="10%">Nome:</td>
						<td colspan="3"><input type="text" name="Nome" id="Nome" class="required text ui-widget-content ui-corner-all" title="O campo Nome é obrigatório<br />" value="<%=Objeto.Item("Nome")%>" /></td>
					</tr>
					
					<tr>
						<td>Imagem:</td>
						<td colspan="3"><input type="file" name="Arquivo" id="Arquivo" class="required text ui-widget-content ui-corner-all" title="O campo Tag é obrigatório<br />" value="<%=Objeto.Item("Nome")%>" /></td>
					</tr>
					
					<tr>
						<td>Ordem:</td>
						<td><input type="text" name="Ordem" id="Ordem" class="text ui-widget-content ui-corner-all" title="O campo Ordem é obrigatório<br />" value="<%=Objeto.Item("Ordem")%>" /></td>
					</tr>
					
					<tr>
						<td>&nbsp;</td>
						<td><input type="submit" name="btEnviar" id="btEnviar" value="Enviar" class="botao" /></td>
					</tr>
				</tbody>
			</table>
			</form>
		</td>
	</tr>
</table>
<!-- #include file="../includes/footer.asp" -->	
</body>
</html>