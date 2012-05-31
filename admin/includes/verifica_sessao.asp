<%
Sub RedirecionaLogin
	URLRetorno = Server.URLEncode(Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING"))
	If Request.ServerVariables("REQUEST_METHOD") = "POST" Then URLRetorno = ""
	Response.Redirect "../Login?ret=" & URLRetorno
	Response.End()
End Sub

If IsEmpty( Session("Usuario_Login") ) And ArquivoAtual <> "verifica.asp" Then
	'Debuga "Sem Login"
	RedirecionaLogin
End If

SessaoAtual = ScriptSplit( Ubound( ScriptSplit ) - 1 )

If ArquivoAtual <> "verifica.asp" And ArquivoAtual <> "logoff.asp" Then
	
End If
%>