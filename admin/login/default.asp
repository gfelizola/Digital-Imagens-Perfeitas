<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="../includes/funcoes.asp" -->
<!-- #include file="../includes/commons.asp" -->
<!-- #include file="../includes/conexao.asp" -->
<!-- #include file="../includes/dao.asp" -->
<!-- #include file="../includes/get_dados.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
erro = Request.QueryString("e")

' -- verifica sessão logada --------
If Not IsEmpty( Session("Usuario_Login") ) Then
	Response.Redirect "../Categorias"
End If


mensagem = ""
If erro <> "" Then
	If erro = "1" Then mensagem = "Login e/ou senha inválido(s)"
	If erro = "2" Then mensagem = "Sua sessão expirou, por favor, faça o login novamente para continuar."
	If erro = "3" Then mensagem = "Sua sessão foi fechada com sucesso."
	If erro = "4" Then mensagem = "Seu usuário não tem acesso a nenhuma área do sistema."
End If
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<link type="text/css" href="../css/ui-lightness/jquery-ui-1.8.4.custom.css" rel="Stylesheet" />	
	<link type="text/css" href="../css/main.css" rel="Stylesheet" />	
	<script type="text/javascript" src="../js/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="../js/jquery-ui-1.8.4.custom.min.js"></script>
	<script type="text/javascript" src="../js/main.js"></script>
	<title>Digital Imagens Perfeitas - Área Administrativa</title>
</head>
<body>
	<form name="formLogin" id="formLogin" method="post" action="verifica.asp?ret=<%=Server.URLEncode(request.QueryString("ret"))%>">
	<table id="tblLogin" class="ui-widget ui-widget-content ui-corner-all" align="center" cellpadding="5" width="400">
		<thead>
			<tr class="">
				<th colspan="2"><img src="../images/logo.png" /></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td align="right" width="15%">Login:</td>
				<td><input type="text" name="login" id="login" class="text ui-widget-content ui-corner-all" /></td>
			</tr>
			<tr>
				<td align="right">Senha:</td>
				<td><input type="password" name="senha" id="senha" class="text ui-widget-content ui-corner-all" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" name="btLogar" id="btLogar" value="Enviar" class="botao" /></td>
			</tr>
		</tbody>
	</table>
	</form>
	<%If mensagem <> "" Then%>
	<div id="login-dialog-confirm" title="Alerta">
		<p>
			<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>
			<%=mensagem%>
		</p>
	</div>
	<%End If%>
</body>
</html>