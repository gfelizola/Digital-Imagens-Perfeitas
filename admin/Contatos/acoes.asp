<!-- #include file="../includes/head.asp" -->
<!-- #include file="../includes/freeaspupload.asp" -->
<%
Acao = Request.QueryString("ac")
Id = Request.QueryString("id")

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
	'Dao.Debug = True
	
	Sigla 							= GetFormItem("Sigla")
	Ordem 							= GetFormItem("Ordem")
	
	Objeto.Item("Nome") 			= GetFormItem("Nome")
	Objeto.Item("Sigla") 			= Sigla
	Objeto.Item("Cor_Dentro") 		= GetFormItem("Cor_Dentro")
	Objeto.Item("Cor_Fora") 		= GetFormItem("Cor_Fora")
	Objeto.Item("Cor_Logo") 		= GetFormItem("Cor_Logo")
	
	MaxOrdem 						= ( Dao.Counter("") + 1 )
	
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
		NomeNovo = SessaoAtual & "_tag_" & Sigla & Extensao
		
		SaveFile "arquivo", NomeNovo
	End If
	
	If GetNomeArquivo("Imagem") <> "" Then
		NomeOriginal = GetNomeArquivo("Imagem")
		Extensao = Right( NomeOriginal, InStr( StrReverse( NomeOriginal ) , "." ) )
		NomeNovo = SessaoAtual & "_primeira_" & Sigla & Extensao
		
		SaveFile "Imagem", NomeNovo
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
	
	SQL = "UPDATE " & SessaoAtual & " SET Ordem = " & OrdemAtual & " WHERE Ordem = " & NovaOrdem
	Set Conn = new Conexao
	Conn.Exec SQL
	
	Dao.Update( Objeto )
	
	ObjetoToLog Objeto, Acao, SessaoAtual
	Response.Redirect "../" & SessaoAtual
	
End If
%>