<!-- #include file="../includes/head.asp" -->
<%
Dim SQL, Login, Senha, Url, Usuario
Login 	= Request.Form("login")
Senha 	= Request.Form("senha")
Url 	= Request.QueryString("ret")

Login = SingleQuotes( Login )
Senha = SingleQuotes( senha )

SQL = "Login like '" & Login & "' AND Senha like '" & Senha & "'"

Set Dao = new GlobalDAO
Dao.Init "Usuario_Admin", Dados
'Dao.Debug = True
Set Lista = Dao.FindByWhere( SQL )
Set Dao = Nothing

If lista.Count > 0 Then
	Session.Timeout = 60
	Set Session("Usuario_Login") = Lista.item(0)
	
	'ACOES DE LOGIN
	ObjetoToLog Session("Usuario_Login"), "Login", "Sistema"
	
	If url <> "" Then
		Response.Redirect(url)
	Else
		Response.Redirect("../Login")
	End If
Else
	Response.Redirect("../Login?e=1")
End If
%>