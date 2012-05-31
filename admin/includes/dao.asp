<%
Class GlobalDAO
	Private M_StartPage
	Private M_MaxRows
	Private M_RecordCount
	Private M_OrderBy
	Private M_Tabela
	Private M_Dados
	Private M_Conn
	Private M_Lazy
	Private M_Debug
	Private T_Conn
	dim M_Rs
	
	Public Property Get StartPage()
		StartPage = M_StartPage
	End Property
	
	Public Property Let StartPage(valor)
		M_Startpage = valor
	End Property
	
	Public Property Get Debug()
		Debug = M_Debug
	End Property
	
	Public Property Let Debug(valor)
		M_Debug = valor
		IF PegarUpType = 3 Then M_Debug = False
	End Property

	
	Public Property Get OrderBy()
		OrderBy = M_Orderby
	End Property
	
	Public Property Let OrderBy(valor)
		If Valor <> "" Then
			M_OrderBy = "ORDER BY " & valor
		Else
			M_OrderBy = ""
		End If
	End Property
	
	
	Public Property Get RecordCount()
		RecordCount = M_RecordCount
	End Property
	
	Public Property Let RecordCount(valor)
	End Property
	
	
	Public Property Get MaxRows()
		MaxRows = M_MaxRows
	End Property
	
	Public Property Let MaxRows(valor)
		M_MaxRows = valor
	End Property
	
	
	Public Property Get Tabela()
		Tabela = M_Tabela
	End Property
	
	Public Property Let Tabela(valor)
		M_Tabela = valor
	End Property
	
	
	Public Property Let Dados(valor)
		M_Dados = valor
	end Property
	
	Public Property Get Dados()
		Dados = M_Dados
	end Property
	
	Public Property Let Lazy(valor)
		M_Lazy = valor
	end Property
	
	Public Property Get Lazy()
		Lazy = M_Lazy
	end Property
	
	Public Function GetConn()
		GetConn = T_Conn.Conn
	End Function
	
	Sub Class_Initialize()
		M_StartPage 	= 0
		M_MaxRows 		= 50
		M_Lazy			= False
		M_Debug			= False
	End Sub
	
	Sub Class_Terminate()
		Set T_Conn = Nothing
	End Sub
	
	Public Function Init(Tabela, Dados)
		Set T_Conn 	= new Conexao
		T_Conn.OpenConn

		Set M_Conn 		= T_Conn.Conn
		Set M_Dados 	= Dados
		
		M_Tabela 		= Tabela
	End Function
	
	Public Function Insert( Objeto )
		
		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.CursorLocation = 3
		rs.CursorType = 1
		rs.LockType = 3
		
		Temp_Tabela = "SELECT * FROM " & M_Tabela
		
		rs.Open Temp_Tabela, M_Conn, 1, 2
		rs.AddNew
		
		ColsFora = Array("Codigo", "DataModificacao")
		Colunas = RemoveCols( M_Dados.Item( M_Tabela ) , ColsFora )
		
		For i = 0 To Ubound( Colunas )
			If M_Debug Then Debuga Array( Colunas(i) , Objeto.Item( Colunas(i) ) )
			rs.Fields( Colunas(i) ).Value = Objeto.Item( Colunas(i) )
		Next
		
		rs.Update
		Insert = rs("Codigo")
		
		rs.Close
		Set rs = Nothing
		
	End Function
	
	Public Function Update( Objeto )

		Set rs = Server.CreateObject("ADODB.Recordset")
		rs.CursorLocation = 3
		rs.CursorType = 1
		rs.LockType = 3
		
		SQL = "SELECT * FROM " & M_Tabela & " WHERE codigo = " & Objeto.Item( "Codigo" )
		If M_Debug Then Debuga SQL
		rs.Open SQL , M_Conn, 1, 2
		
		ColsFora = Array("Codigo", "DataCriacao")
		Colunas = RemoveCols( M_Dados.Item( M_Tabela ) , ColsFora )
		
		For i = 0 To Ubound( Colunas )
			If M_Debug Then Debuga Array( Colunas(i) , Objeto.Item( Colunas(i) ) )
			rs.Fields( Colunas(i) ).Value = Objeto.Item( Colunas(i) )
		Next
		
		rs.Update
		Update = rs("Codigo")
		
		rs.Close
		Set rs = Nothing
	End Function
	
	Public Function Delete(codigo)
		If IsNumeric(codigo) And Not IsEmpty(codigo) And codigo <> 0 Then
			Set rs = Server.CreateObject("ADODB.Recordset")
			SQL = "DELETE FROM " & M_Tabela & " WHERE codigo = " & codigo
			If M_Debug Then Debuga SQL
			M_Conn.Execute SQL
			Set rs = Nothing
		End If
	End Function
	
	Public Function DeleteWhere(filtro)
		Set rs = Server.CreateObject("ADODB.Recordset")
		SQL = "DELETE FROM " & M_Tabela & " WHERE " & filtro
		If M_Debug Then Debuga SQL
		M_Conn.Execute SQL
		Set rs = Nothing
	End Function
	
	Public Function Exec( SQL )
		If M_Debug Then Debuga SQL
		M_Conn.Execute SQL
	End Function
	
	Public Function Counter( filtro )
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		SQL = "SELECT * FROM " & M_Tabela
		If filtro <> "" Then SQL = SQL & " WHERE " & filtro
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		Counter = M_Rs.RecordCount
	End Function
	
	Public Function FindAll() 'Objeto Scriting Dictinary
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		SQL = "SELECT * FROM " & M_Tabela & " " & M_OrderBy
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		M_RecordCount = M_Rs.RecordCount
		
		Set FindAll = FillFromRS( M_Rs )
	End Function
	
	Public Function FindByWhere(filtro) 'Objeto Scriting Dictinary
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		SQL = "SELECT * FROM " & M_Tabela & " WHERE " & filtro & " " & M_OrderBy
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		M_RecordCount = M_Rs.RecordCount
		
		Set FindByWhere = FillFromRS( M_Rs )
	End Function
	
	Public Function FindByCodigo(codigo) 'Objeto Scriting Dictinary
		Set FindByCodigo = FindByCampo("codigo", codigo)
	End Function
	
	Public Function FindByCampo(campo, valor) 'Objeto Scriting Dictinary
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		
		SQL = "SELECT * FROM " & M_Tabela & " WHERE " & campo & " = " & valor & " " & M_OrderBy
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		M_RecordCount = M_Rs.RecordCount
		Set TempLista = FillFromRS( M_Rs )
		If TempLista.Count > 0 Then
			Set FindByCampo = TempLista(0)
		Else
			Set FindByCampo = Nothing
		End If
	End Function
	
	Public Function FindGroup(camposlist, camposgroup) 'Objeto Scriting Dictinary
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		SQL = "SELECT " & camposlist & " FROM " & M_Tabela & " GROUP BY " & camposgroup
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		M_RecordCount = M_Rs.RecordCount
		
		Set FindGroup = FillFromRS( M_Rs )
	End Function
	
	Public Function FindGroupWhere(camposlist, camposgroupm, filtro) 'Objeto Scriting Dictinary
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		SQL = "SELECT " & camposlist & " FROM " & M_Tabela & " WHERE " & filtro & " GROUP BY " & camposgroupm
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		M_RecordCount = M_Rs.RecordCount
		
		Set FindGroupWhere = FillFromRS( M_Rs )
	End Function
	
	Public Function FindJoin(TabelaB, Filtro) 'Objeto Scriting Dictinary
		CamposJoin = ""
		CamposCount = 0 
		
		TotalCampos = Ubound( M_Dados.Item(M_Tabela) ) 
		
		For i = 0 To TotalCampos
			Col = M_Dados.Item(M_Tabela)(i)
			CamposCount = CamposCount + 1
			CamposJoin = CamposJoin & "a." & Col
			If CamposCount <= TotalCampos Then CamposJoin = CamposJoin & ", "
		Next
	
		Set M_Rs = Server.CreateObject("ADODB.Recordset")
		M_Rs.CursorLocation = 3
		SQL = "SELECT " & CamposJoin & " FROM " & M_Tabela & " a ," & TabelaB & " b WHERE " & filtro & " " & M_OrderBy
		If M_Debug Then Debuga SQL
		M_Rs.Open SQL , M_Conn, 3
		M_RecordCount = M_Rs.RecordCount
		
		Set FindJoin = FillFromRS( M_Rs )
	End Function
	
	Private Function FillFromRS(p_RS)
		Dim ObjetoAtual, Lista
		
		If p_RS.RecordCount > 0 Then
			If M_MaxRows <> 0 And M_StartPage <> 0 Then
				p_Rs.PageSize = M_MaxRows
				p_rs.AbsolutePage = M_StartPage
			Else
				p_Rs.PageSize =  p_Rs.RecordCount
				p_rs.AbsolutePage = 1
			End If
			
			Set Lista = Nothing
			Set Lista = Server.CreateObject("Scripting.Dictionary")
			Rc = 0
			Do Until p_Rs.eof
				Set ObjetoAtual = Populate( p_RS )
				Lista.Add Rc, ObjetoAtual
				Rc = Rc + 1
				p_RS.MoveNext
				
				If Rc >= p_Rs.PageSize Then Exit Do
			Loop
		Else
			Set Lista = Server.CreateObject("Scripting.Dictionary")
		End If
		
		Set FillFromRS = Lista
		CloseAll
	End Function
	
	Private Function Populate( p_RS )
		Set ObjetoAtual = Server.CreateObject("Scripting.Dictionary")
		Dim k
		k = 0
		
		For Each Col In M_Dados.Item(M_Tabela)
			ColunaAtual = Col
			
			TemColuna = False
			For i = 0 To p_RS.Fields.Count -1
				If ColunaAtual = p_RS.Fields(i).Name Then TemColuna = True
			Next
			
			If TemColuna Then
				Valor = p_RS.Fields( ColunaAtual ).Value
				
				'Debuga Array( M_Dados.Item(M_Tabela & "Type")(k), IsTable( M_Dados.Item(M_Tabela & "Type")(k) ) )
				
				If IsTable( M_Dados.Item(M_Tabela & "Type")(k) ) And Not Lazy And Not IsNull(Valor) Then
					ColunaBackup = ColunaAtual
					
					Set TempDao = new GlobalDao
					TempDao.Init M_Dados.Item(M_Tabela & "Type")(k) , M_Dados
					Set Valor = TempDao.FindByCodigo( Valor )
					Set TempDao = Nothing
					
					ColunaAtual = ColunaBackup
				End If
				ObjetoAtual.Add ColunaAtual, Valor
			End IF
			k = k + 1
		Next
		
		Set Populate = ObjetoAtual
	End Function
	
	Private Function RemoveCols( Colunas , ColsFora )
		ColsNames = Array()
						
		For i = 0 To Ubound( Colunas )
			ColBase = Colunas(i)
			
			Inserir = True
			For Each Fora In ColsFora
				If LCase( ColBase ) = LCase( Fora ) Then
					Inserir = False
				End If
			Next
			If Inserir Then
				ArrayPush ColsNames , ColBase
			End If
		Next
		
		RemoveCols = ColsNames
	End Function
	
	Private Function IsTable( p_Name )
		Dim Sim
		Sim = False
		For Each Key In M_Dados.Keys
			If LCase(Key) = LCase( p_Name ) Then Sim = True
		Next
		IsTable = Sim
	End Function
		
	Public Sub CloseAll()
		M_Rs.Close
		Set M_Rs = Nothing
	End Sub
End Class
%>