<!-- #include file="../includes/head.asp" -->
<!-- #include file="../includes/freeaspupload.asp" -->
<%
Acao = Request.QueryString("ac")
Id = Request.QueryString("id")
Tipo = Request.QueryString("t")

acaoNumero = "0"
If Acao = "inserir" Then AcaoNumero = "1"
If Acao = "editar" Then AcaoNumero = "2"

If acao = "inserir" Or acao = "editar" Then

	IniciarUpload
	
	Set Objeto = Server.CreateObject("Scripting.Dictionary")
	For Each Col In Dados.Item(SessaoAtual)
		Objeto.Add Col, ""
	Next
	
	Set Dao = new GlobalDAO
	Dao.Init SessaoAtual , Dados
	
	Ordem 							= GetFormItem("Ordem")
	Categoria 						= Session.Contents(sessaoAtual & "_area")
	
	Objeto.Item("Nome") 			= GetFormItem("Nome")
	Objeto.Item("Categoria") 		= Categoria
	Objeto.Item("Tipo") 			= 1
	
	MaxOrdem 						= ( Dao.Counter("Categoria = " & Categoria) + 1 )
	Objeto.Item("Ordem") 			= MaxOrdem
	
	If Ordem <> "" Then
		Ordem = CInt( Ordem )
		If Ordem < MaxOrdem Then 
			Objeto.Item("Ordem") 	= Ordem
			Dao.Exec "UPDATE " & SessaoAtual & " SET Ordem = ( Ordem + 1 ) WHERE Ordem >= " & Ordem
		End IF
	End If
	
	If Acao = "inserir" Then
		Objeto.Item("DataCriacao") = Now
		Retorno = Dao.Insert( Objeto )
		Session("sucesso") = "Registro inserido com sucesso"
	Else
		Objeto.Item("Codigo") = Id
		Objeto.Item("DataModificacao") = Now
		
		Retorno = Dao.Update( Objeto )
		Session("sucesso") = "Registro atualizado com sucesso."
	End If
	
	If GetNomeArquivo("Arquivo") <> "" Then
		NomeOriginal = GetNomeArquivo("Arquivo")
		Extensao = Right( NomeOriginal, InStr( StrReverse( NomeOriginal ) , "." ) )
		NomeNovo = SessaoAtual & "_" & Retorno & Extensao
		
		SaveFile "arquivo", NomeNovo
		
		Objeto.Item("Codigo") = Retorno
		Objeto.Item("Arquivo") = NomeNovo
		Objeto.Item("DataModificacao") = Now
		Dao.Update( Objeto )
	End If
	
	ObjetoToLog Objeto, Acao, SessaoAtual
	Response.Redirect "../" & SessaoAtual
	
ElseIf acao = "video" Then

	Set Objeto = Server.CreateObject("Scripting.Dictionary")
	For Each Col In Dados.Item(SessaoAtual)
		Objeto.Add Col, ""
	Next
	
	Set Dao = new GlobalDAO
	Dao.Init SessaoAtual , Dados
	
	Ordem 							= RF("Ordem")
	Categoria 						= Session.Contents(sessaoAtual & "_area")
	
	Objeto.Item("Nome") 			= RF("Nome")
	Objeto.Item("Arquivo") 			= RF("Arquivo")
	Objeto.Item("Categoria") 		= Categoria
	Objeto.Item("Tipo") 			= 2
	
	MaxOrdem 						= ( Dao.Counter("Categoria = " & Categoria) + 1 )
	Objeto.Item("Ordem") 			= MaxOrdem
	
	If Ordem <> "" Then
		Ordem = CInt( Ordem )
		If Ordem < MaxOrdem Then 
			Objeto.Item("Ordem") 	= Ordem
			Dao.Exec "UPDATE " & SessaoAtual & " SET Ordem = ( Ordem + 1 ) WHERE Ordem >= " & Ordem
		End IF
	End If
	
	If Id <> "" Then
		Objeto.Item("Codigo") = Id
		Objeto.Item("DataModificacao") = Now
		
		Retorno = Dao.Update( Objeto )
		Session("sucesso") = "Registro atualizado com sucesso."
	Else
		Objeto.Item("DataCriacao") = Now
		Retorno = Dao.Insert( Objeto )
		Session("sucesso") = "Registro inserido com sucesso"
	End If
	
	ObjetoToLog Objeto, Acao, SessaoAtual
	Response.Redirect "../" & SessaoAtual
	
ElseIf acao = "subir" Or acao = "descer" Then
	Set Dao = new GlobalDAO
	Dao.Init SessaoAtual, Dados
	Dao.Lazy = True
	Set Objeto = Dao.FindByCodigo( id )	
	
	OrdemAtual = Objeto.Item("Ordem")

	If Acao = "descer" Then
		NovaOrdem = OrdemAtual + 1
	Else
		NovaOrdem = OrdemAtual - 1
	End If
	
	Objeto.Item("Ordem") = NovaOrdem
	
	SQL = "UPDATE " & SessaoAtual & " SET Ordem = " & OrdemAtual & " WHERE Ordem = " & NovaOrdem & " AND Categoria = " & Session.Contents(sessaoAtual & "_area")
	Set Conn = new Conexao
	Conn.Exec SQL
	
	Dao.Update( Objeto )
	
	ObjetoToLog Objeto, Acao, SessaoAtual
	Response.Redirect "../" & SessaoAtual
	
End If
%>