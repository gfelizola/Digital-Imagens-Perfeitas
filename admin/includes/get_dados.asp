<%
If URLXML = "" Then URLXML = Server.MapPath( "../xml/config.xml" )
Dim Tabelas, Colunas, TabelaAtual, ColunaAtual, Dados, ArrayColunas, ArrayNomes

Dim XML
Set XML = Server.CreateObject("Microsoft.XMLDOM")
XML.async = False
XML.load( URLXML )

Set Dados = Server.CreateObject("Scripting.Dictionary")
Set Tabelas = xml.getElementsByTagName("table")

For i = 0 To Tabelas.Length - 1
	TabelaAtual 	= Tabelas.Item(i).attributes.getNamedItem("name").nodeValue
	TabelaAtualS 	= Tabelas.Item(i).attributes.getNamedItem("showAs").nodeValue
	
	Set Colunas 	= Tabelas.Item(i).getElementsByTagName("colum")
	ArrayColunas 	= Array()
	ArrayNomes 		= Array()
	ArrayTipos 		= Array()
	
	'Debuga "--------------------------------"
	'Debuga Array( i, TabelaAtual )
	
	For j = 0 To Colunas.Length - 1
		ColunaAtual = Colunas.Item(j).attributes.getNamedItem("name").nodeValue
		
		'Debuga Array( j, ColunaAtual )
		
		ShowAtual = Colunas.Item(j).attributes.getNamedItem("showAs").nodeValue
		TipoAtual = Colunas.Item(j).attributes.getNamedItem("type").nodeValue
		
		ArrayPush ArrayColunas 	, ColunaAtual
		ArrayPush ArrayNomes 	, ShowAtual
		ArrayPush ArrayTipos 	, TipoAtual
	Next
	
	ArrayPush ArrayColunas 	, "Codigo"
	ArrayPush ArrayNomes 	, "Cуdigo"
	ArrayPush ArrayTipos 	, "Number"
	
	ArrayPush ArrayColunas 	, "DataCriacao"
	ArrayPush ArrayNomes 	, "Data de Criaзгo"
	ArrayPush ArrayTipos 	, "Date"
	
	ArrayPush ArrayColunas 	, "DataModificacao"
	ArrayPush ArrayNomes 	, "Data de Modificaзгo"
	ArrayPush ArrayTipos 	, "Date"
	
	Dados.Add TabelaAtual, ArrayColunas
	Dados.Add TabelaAtual & "Nome", TabelaAtualS
	Dados.Add TabelaAtual & "Show", ArrayNomes
	Dados.Add TabelaAtual & "Type", ArrayTipos
Next
%>