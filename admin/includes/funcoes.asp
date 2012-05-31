<%
dim serverName
dim compSetado
dim upl

compSetado = false

Function StrZero( v , z )
	StrZero = String( z - Len( Trim( CStr(v) ) ),"0" ) & Trim( Cstr(v) )
End Function

Function SingleQuotes(StrEntrada)
	If StrEntrada = "" Or IsNull(StrEntrada) Then Exit Function
	Dim StrSaida
	StrSaida = Trim(StrEntrada)
	StrSaida = Replace(StrSaida, "'", "")
	StrSaida = Replace(StrSaida, "\", "\\")
	SingleQuotes = StrSaida
End Function

Function RF(campo)
	RF = SingleQuotes( Trim( Request.Form(campo) ) )
End Function

Function RFZero(campo)
	Valor = RF(campo)
	If Valor = "" Then Valor = "0"
	RFZero = Valor
End Function

Function RQ(campo)
	RQ = SingleQuotes( Trim( Request.QueryString(campo) ) )
End Function

Function RQZero(campo)
	Valor = RQ(campo)
	If Valor = "" Then Valor = "0"
	RQZero = Valor
End Function

Sub Out( msg )
	Response.Write msg
	'Response.Flush()
End Sub
	
Sub OutL( msg )
	Out( msg & vbcrlf )
End Sub

Sub Debuga( mensagem )
	Dim msg
	msg = MontaMensagem( mensagem )
	Out msg
End Sub

Sub ToLog(Mensagem)
	PastaLog = Server.MapPath("../../arquivos/logs")
	DataStr = "log_" & StrZero(Year(Now),4) & "_" & StrZero( Month(Now) , 2 ) & "_" & StrZero( Day(Now) , 2) & ".log"
	NomeArquivo = PastaLog & "/" & DataStr

	Set fs = Server.CreateObject("Scripting.FileSystemObject")
	Set Arquivo = fs.OpenTextFile( NomeArquivo , 8 , True )
	Arquivo.WriteLine(Mensagem)
	Arquivo.Close
	Set Arquivo = nothing
	Set fs = nothing
End Sub

Sub ObjetoToLog( Objeto , Acao , Sessao )
	LogMessage = 	"[" & Now & "][" & Session("Usuario_Login").Item("Nome") & "] - " & acao & " - " & Sessao & " - [ "
	For Each Chave In Objeto.Keys
		LogMessage = LogMessage & Chave & ": " & Objeto.Item(Chave) & ", "
	Next
	
	LogMessage = Left( LogMessage , Len( LogMessage ) - 2 )
	LogMessage = LogMessage & " ]"
	
	ToLog LogMessage
End Sub

Function MontaMensagem( mensagem )
	Dim sTemp
	sTemp = ""
	If IsArray( mensagem ) Then
		For Each valor In mensagem
			If sTemp <> "" Then sTemp = sTemp & " | "
			sTemp = sTemp & valor
		Next
	ElseIf TypeName( mensagem ) = "Dictionary" Then
		For Each valor In mensagem.Items
			If sTemp <> "" Then sTemp = sTemp & " | "
			
			sTemp = sTemp & valor
		Next
	Else
		sTemp = mensagem
	End If
	MontaMensagem = "[INFO]: " & Now & " Source: " & Request.ServerVariables("SCRIPT_NAME") & " | Msg: [ " & sTemp & " ]<br />" & vbCrlf
End Function

Function EncriptaStr(Texto)
    Dim TempStr, TempResult, TempNum, TempChar
    Dim TempKey
    Dim i
    TempStr = Texto
    TempResult = ""
    TempKey = ((EncKey * EncC1) + EncC2) Mod 65536
    For i = 1 To Len(TempStr)
        TempNum = (Asc(Mid(TempStr, i, 1)) Xor (AuxShr(TempKey, 8))) Mod 256
        TempChar = Chr(TempNum)
        TempKey = (((Asc(TempChar) + TempKey) * EncC1) + EncC2) Mod 65536
        TempResult = TempResult & TempChar
    Next
    EncriptaStr = TempResult
End Function

Function DecriptaStr(Texto)
    Dim TempStr, TempResult, TempNum, TempChar
    Dim TempKey
    Dim i
    TempStr = Texto
    TempResult = ""
    TempKey = ((EncKey * EncC1) + EncC2) Mod 65536
    For i = 1 To Len(TempStr)
        TempNum = (Asc(Mid(TempStr, i, 1)) Xor (AuxShr(TempKey, 8))) Mod 256
        TempChar = Chr(TempNum)
        TempKey = (((Asc(Mid(TempStr, i, 1)) + TempKey) * EncC1) + EncC2) Mod 65536
        TempResult = TempResult & TempChar
    Next
    DecriptaStr = TempResult
End Function

Function AuxShr(Numero, BShr)
    AuxShr = Int(Numero / (2 ^ BShr))
End Function

Function ArrayPush(mArray, mValue)
	Dim mValEl
	
	If IsArray(mArray) Then
		If IsArray(mValue) Then
			For Each mValEl In mValue
				Redim Preserve mArray(UBound(mArray) + 1)
				mArray(UBound(mArray)) = mValEl
			Next
		Else
			Redim Preserve mArray(UBound(mArray) + 1)
			If TypeName( mValue ) = "Dictionary" Then
				Set mArray(UBound(mArray)) = mValue
			Else
				mArray(UBound(mArray)) = mValue
			End If
		End If
	Else
		If IsArray(mValue) Then
			mArray = mValue
		Else
			mArray = Array(mValue)
		End If
	End If
	Push = UBound(mArray)
End Function

Function ArrayContain(mArray, mValue)
	Dim mValEl
	Dim mRet
	mRet = false
	For Each mValEl In mArray
		If mValEl = mValue Then mRet = true
	Next
	ArrayContain = mRet
End Function

Function Floor(pvarNum, pvarDecimals)
	Dim varNum
	Dim varDecimals
	Dim varBigValue
	
	If (Not IsNumeric(pvarNum)) Or (Not IsNumeric(pvarDecimals)) Then
		Floor = 0
		Exit Function
	End If
	
	varNum = pvarNum
	varDecimals = Round(pvarDecimals, 0)
	varBigValue = varNum * 10 ^ varDecimals
	Floor = Fix(varBigValue) / 10 ^ varDecimals
End Function 

Function PegarServer
	strTemp = ""
	strName = LCase( Request.ServerVariables("SERVER_NAME"))
	
	For i = 0 to ubound(serverNames) 
		If InStr( strName, serverNames(i) ) > 0 Then strTemp = serverNames(i)
	Next
	
	If strTemp = "" Then strTemp = strName
	pegarServer = strTemp
End Function

Function PegarUpType
	iTemp = -1
	strName = LCase( Request.ServerVariables("SERVER_NAME"))
	For i = 0 to ubound(serverNames) 
		If InStr( strName, serverNames(i) ) > 0 Then iTemp = upTypes(i)
	Next
	
	If iTemp < 0 Then iTemp = 1
	pegarUpType = iTemp
End Function

Sub IniciarUpload
	If pegarUpType = 2 Then
		Set upl = Server.CreateObject("SoftArtisans.FileUp")
		upl.Path = uploadsDirVar
	ElseIf pegarUpType = 3 Then
		Set upl = Server.CreateObject("Dundas.Upload.2")
		upl.UseUniqueNames = False
		upl.SaveToMemory
	Else
		Set upl = New FreeASPUpload
		upl.Save UploadsDirVar
	End If
	compSetado = true
End sub

Function GetFormItem(fieldName)
	strTemp = ""
	If fieldName <> "" Then
		If Not compSetado Then
			iniciarUpload
		End If
		
		strTemp = upl.Form(fieldName)
	Else
		strTemp = "Nenhum campo informado"
	End If
	getFormItem = strTemp
End Function

Function GetNomeArquivo(fieldName)
	If fieldName <> "" Then
		If Not compSetado Then
			iniciarUpload
		End If
		If pegarUpType = 2 Then
			GetNomeArquivo = upl.Form(fieldName).UserFilename
		ElseIf pegarUpType = 3 Then
			If upl.Files(fieldName).OriginalPath <> "" Then
				GetNomeArquivo = upl.GetFileName( upl.Files(fieldName).OriginalPath )
			Else
				GetNomeArquivo = ""
			End If
		Else
			If Not IsEmpty( upl.UploadedFiles(LCase(fieldName)) ) Then
				GetNomeArquivo = upl.UploadedFiles(LCase(fieldName)).FileName
			Else
				GetNomeArquivo = ""
			End If
		End If
	End If
End Function

Function GetTamanhoArquivo( FieldName )
	If fieldName <> "" Then
		Set fs = Server.CreateObject("Scripting.FileSystemObject")
		NomeArquivo = UploadsDirVar & "\" & GetNomeArquivo( fieldName )
		If fs.FileExists( NomeArquivo ) Then
			Set f = fs.GetFile( NomeArquivo )
			GetTamanhoArquivo = f.Size
			Set f = Nothing
		Else 
			GetTamanhoArquivo = 0
		End IF
		Set fs = Nothing
	End If
End Function

Sub SaveFile(fieldName,fileName)
	If fieldName <> "" Then
		If Not compSetado Then
			iniciarUpload
		End If
		If pegarUpType = 2 Then
			If Not IsEmpty( upl.Form(fieldName) ) Then
				upl.Form(fieldName).SaveAs fileName
			End If
		ElseIf pegarUpType = 3 Then
			upl.Files(fieldName).SaveAs UploadsDirVar & "\" & FileName
		Else
			Set fso = Server.CreateObject("Scripting.FileSystemObject")
			NomeArquivo = GetNomeArquivo( fieldName )
			Debuga Array( "AQUI", NomeArquivo)
			fso.MoveFile UploadsDirVar & "\" & NomeArquivo, UploadsDirVar & "\" & FileName
			Set fso = Nothing
		End If
	End If
End Sub

Sub FinalizarUpload
	If compSetado Then
		Set upl = Nothing
	End If
End Sub

Function VerificaAcao(acao, retorno)
	If acao = "1" Then
		VerificaAcao = "inserir"
	ElseIf acao = "2" Then
		VerificaAcao = "editar"
	ElseIf acao = "3" Then
		VerificaAcao = "deletar"
	ElseIf acao = "4" Then
		VerificaAcao = "aprovar"
	ElseIf acao = "5" Then
		VerificaAcao = "desaprovar"
	ElseIf acao = "6" Then
		VerificaAcao = "subir"
	ElseIf acao = "7" Then
		VerificaAcao = "descer"
	ElseIf acao = "8" Then
		VerificaAcao = "video"
	Else
		Session("sucesso") = "AÇÃO NÃO DEFINIDA."
		Response.Redirect( retorno )
	End If
End Function

Function ApagarRegistro(P_Dao, Codigo)
	c = Request.QueryString("c")
	If c = "true" Then
		Set ObjetoD = P_Dao.FindByCodigo( Codigo )
		ObjetoToLog Objeto, "excluir", SessaoAtual
		
		P_Dao.Delete( Codigo )
		ApagarRegistro = True
	Else
	
		URL = Request.ServerVariables("SCRIPT_NAME") & "?" & Request.ServerVariables("QUERY_STRING") & "&c=true"
		%>
		<script>
		var c = confirm('Deseja realmente apagar este registro?')
		if(c){
			window.location.href = '<%=URL%>' ;
		} else {
			history.go(-1);
		}
		</script>
		<%
		Response.End()
	End If
End Function

Function GetSimNao(valor)
	If valor = 1 Then
		GetSimNao = "SIM"
	Else
		GetSimNao = "NÃO"
	End If
End Function

Function GetTipo(valor)
	GetTipo = Tipos( Clng(Valor) - 1 )
End Function

Function FormataData( Data )
	FormataData = StrZero( Day( Data ) , 2) & "/" & StrZero( Month( Data ) , 2 ) & "/" & StrZero( Year( Data ) , 4)
End Function

Function GetAmanha(Data)
	Dia = Day( Data )
	Mes = Month( Data )
	Ano = Year( Data )
	
	DataTeste = StrZero( ( Dia + 1 ) , 2) & "/" & StrZero( Mes , 2 ) & "/" & StrZero( Ano ,4)
	If Not IsDate( DataTeste ) Then
		DataTeste = "01/" & StrZero( Mes + 1 , 2 ) & "/" & StrZero( Ano ,4)
		If Not IsDate( DataTeste ) Then
			DataTeste = "01/01/" & StrZero( Ano + 1 ,4)
		Else
			GetAmanha = DataTeste
		End If
	Else
		GetAmanha = FormatDateTime(DataTeste , 2)
	End If
End Function

Function MostraNulo( Valor, Chave )
	If TypeName( Valor ) = "Nothing" Then
		MostraNulo = "Registro removido ou inexistente"
	Else
		MostraNulo = Valor.Item( Chave )
	End If
End Function

Function EnviaEmail( De, Para, Assunto, Corpo , Cc , Bcc , ReplyTo, Servidor, Usuario, Senha )
	If PegarUpType <> 1 Then
		Set Mail = Server.CreateObject("CDO.Message")
		Set Conf = Server.CreateObject ("CDO.Configuration")
		
		'Conf.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.cataventocultural.org.br"
		'Conf.Fields("http://schemas.microsoft.com/cdo/configuration/smtpserverport")= 25
		'Conf.Fields("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		'Conf.Fields("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 30
		
		Conf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		Conf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = Servidor
		Conf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		Conf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		Conf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = Usuario
		Conf.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = Senha
		Conf.Fields.update
		
		Set Mail.Configuration = Conf
		Mail.From = De
		Mail.To = Para
		Mail.Subject = Assunto
		Mail.HtmlBody = Corpo
		
		If Not IsNull( Cc ) Then Mail.CC = Cc
		If Not IsNull( Bcc ) Then Mail.BCC = Bcc
		If Not IsNull( ReplyTo ) Then Mail.ReplyTo = ReplyTo
		
		On Error Resume Next
		Mail.Send
		
		Set Mail = Nothing
		Set conf = Nothing
	
		If err.number = 0 Then
			EnviaEmail = "Email foi enviado com exitô"
		Else
			EnviaEmail = "Erro ao enviar a mensagem: " & Err.description
		End If
	Else
		EnviaEmail = "Servidor não suporta envio de e-mail"
	End If
End Function

Sub AcertarOrdem( Tabela, Filtro, Conexao )
	Set DaoOrdem = new GlobalDAO
	DaoOrdem.Init Tabela, Dados
	'DaoOrdem.Debug = True
	DaoOrdem.Lazy = True
	
	Set ListaOrdem = DaoOrdem.FindByWhere(Filtro)
	
	If ListaOrdem.Count > 0 Then
		OrdemAtualizada = 1
		For Each Item In ListaOrdem.Items
			Set ObjetoAtual = Item
			ObjetoAtual.Item("Ordem") = OrdemAtualizada
			
			DaoOrdem.Update( ObjetoAtual )
			
			OrdemAtualizada = OrdemAtualizada + 1
		Next
	End If
End Sub
%>