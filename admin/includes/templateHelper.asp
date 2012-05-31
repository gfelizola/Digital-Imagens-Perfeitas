<%
Dim vars, blocks, p_content, regex, blockBegin, blockEnd, validVarnamesPattern
Set vars = server.createObject("Scripting.Dictionary")
Set blocks = server.createObject("Scripting.Dictionary")
placeHolderBegin = "{{{"
placeHolderEnd = "}}}"
blockBegin = "BLOCK"
blockEnd = "ENDBLOCK"
validVarnamesPattern = "[(a-zA-Z0-9)|_]+"
Set Regex = new RegExp
Regex.IgnoreCase = true
Regex.Global = true

Function GetFileContents( NomeArquivo )
	Set FSO = Server.CreateObject("Scripting.FileSystemObject")
	ArquivoPath = Server.MapPath( NomeArquivo )
	
	Set Arquivo = FSO.OpenTextFile( ArquivoPath, 1, False )
	GetFileContents = Arquivo.ReadAll()
	Arquivo.Close()
	Set Arquivo = Nothing
	
	Set FSO = Nothing
end function

Function ParseTemplate( input )
	ParseTemplate = input
	
	For Each varName In vars.keys
		ParseTemplate = replacePlaceHolders(parseTemplate, varName, vars(varName) & "")
	Next
	
	regex.pattern = getBlockPattern(validVarnamesPattern)
	ParseTemplate = regex.replace(ParseTemplate, "")
	ParseTemplate = replacePlaceHolders(ParseTemplate, validVarnamesPattern, "")
End Function

Sub Add(varName, varValue)
	var = uCase(varName)
	If vars.exists(var) Then vars.remove(var)
	vars.add var, varValue
End Sub

Function ReplacePlaceHolders(input, varName, varValue)
	Regex.pattern = PlaceHolderBegin & varName & PlaceHolderEnd
	ReplacePlaceHolders = Regex.replace(input & "", varValue & "")
End Function

Function GetBlockPattern(blockName)
	getBlockPattern = 	PlaceHolderBegin & BlockBegin & _
						" (" & blockName & ")" & placeHolderEnd & "[\s\S]*?" & _
						placeHolderBegin & blockEnd & " (\1)" & placeHolderEnd
End Function
%>
