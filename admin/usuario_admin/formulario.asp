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

If id <> "" Then
	Set Dao = new GlobalDAO
	Dao.Init SessaoAtual, Dados
	
	If acao = "editar" Then
		Set Objeto = Dao.FindByCodigo( id )	
		If TypeName(Objeto) = "Nothing" Then
			Session("sucesso") = "Registro não encontrado."
			Response.Redirect("../" & SessaoAtual)
		End If
	Else
		If ApagarRegistro( Dao, id ) Then
			Session("sucesso") = "Registro removido com sucesso."
			Response.Redirect("../" & SessaoAtual)
		End If
	End If
	
	Set Dao = Nothing
End If
%>
<body>
<!-- #include file="../includes/header.asp" -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td valign="top">
			<table align="left" cellpadding="5" width="100%">
				<tr>
					<td width="100" nowrap="nowrap"><strong><%=Dados.Item( SessaoAtual & "Nome" )%></strong></td>
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
			<form id="form-validate" action="acoes.asp?ac=<%=acao%>&id=<%=id%>" method="post" gfValidateForm="gfValidateForm">
			
			<table align="left" cellpadding="5" width="100%" class="ui-widget-content ui-corner-all">
				<tbody>
					<tr>
						<td colspan="2">
							<div id="errors-container" class="ui-state-error ui-corner-all" style="padding: .7em; display:none;">
								<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
								<span id="container"></span>
							</div>
						</td>
					</tr>
					
					<tr>
						<td width="10%">Nome:</td>
						<td><input type="text" name="nome" id="nome" class="required text ui-widget-content ui-corner-all" title="O campo nome é obrigatório<br />" value="<%=Objeto.Item("Nome")%>" /></td>
					</tr>
					
					<tr>
						<td>Login:</td>
						<td><input type="text" name="login" id="login" class="required text ui-widget-content ui-corner-all" title="O campo login é obrigatório (no mínimo 5 caracteres)<br />" value="<%=Objeto.Item("Login")%>" /></td>
					</tr>
					
					<tr>
						<td>Senha:</td>
						<td><input type="password" name="senha" id="senha" class="required text ui-widget-content ui-corner-all" title="O campo senha é obrigatório (no mínimo 5 caracteres)<br />" value="<%=Objeto.Item("Senha")%>" /></td>
					</tr>
					
					<tr>
						<td>Confirmação da senha:</td>
						<td><input type="password" name="confirmacao_senha" id="confirmacao_senha" equalTo="#senha" class="required text ui-widget-content ui-corner-all" title="O campo confirmação de senha é obrigatório (deve ser igual a senha)<br />" value="<%=Objeto.Item("Senha")%>" /></td>
					</tr>
					
					<tr>
						<td>Acesso:</td>
						<td><div id="form-usuario-regras">
								<%
								RegrasChecks = Dados.Keys
								For i = 0 To Dados.Count - 1 Step 4
									check = ""
									validate = ""
									If i = 0 Then validate = "class='required' title='Selecione ao menos uma regra de acesso'"
									If InStr( Objeto.Item("Regras") , RegrasChecks(i) ) > 0 Then check = "checked='checked' "
									Response.Write 	"<input type='checkbox' name='Regra' id='Regra-" & RegrasChecks(i) & _
													"' value='" & RegrasChecks(i) & _ 
													"' " & check & validate & " /><label for='Regra-" & RegrasChecks(i) & _ 
													"'>" & Dados.Item( RegrasChecks(i+1) ) & _
													"</label>" & vbCrlf
								Next
								%>
							</div>
						</td>
					</tr>
					
					<tr>
						<td>&nbsp;</td>
						<td><input type="submit" name="btEnviar" id="btEnviar" class="botao" /></td>
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