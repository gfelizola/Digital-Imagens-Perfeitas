<!-- #include file="../includes/head.asp" -->
<%
Acao = Request.QueryString("ac")
Id = Request.QueryString("id")

acaoNumero = "0"
If Acao = "inserir" Then AcaoNumero = "1"
If Acao = "editar" Then AcaoNumero = "2"

If acao = "inserir" Or acao = "editar" Then

	Set Objeto = Server.CreateObject("Scripting.Dictionary")
	For Each Col In Dados.Item(SessaoAtual)
		Objeto.Add Col, ""
	Next
	
	Objeto.Item("Nome") 	= RF("Nome")
	Objeto.Item("Login") 	= RF("Login")
	Objeto.Item("Regras") 	= RF("Regra")
	
	Set Dao = new GlobalDAO
	Dao.Init SessaoAtual , Dados
	
	If Acao = "inserir" Then
		'Objeto.Item("Senha") = SingleQuotes( EncriptaStr( RF("Senha") ) )
		Objeto.Item("Senha") = SingleQuotes( RF("Senha") )
		Objeto.Item("DataCriacao") = Now
		Retorno = Dao.Insert( Objeto )
		Session("sucesso") = "Registro inserido com sucesso"
	Else
		Objeto.Item("Codigo") = Id
		
		If RF("Senha") = "" Then
			Objeto.Item("Senha") = Dao.FindByCodigo( Id ).Item("Senha")
		Else
			'Objeto.Item("Senha") = SingleQuotes( EncriptaStr( RF("Senha") ) )
			Objeto.Item("Senha") = SingleQuotes( RF("Senha") )
		End If
		Objeto.Item("DataModificacao") = Now
		
		Retorno = Dao.Update( Objeto )
		Session("sucesso") = "Registro atualizado com sucesso."
	End If
	
	ObjetoToLog Objeto, Acao, SessaoAtual
	Response.Redirect "../" & SessaoAtual
End If
%>