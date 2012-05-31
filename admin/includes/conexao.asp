<%
Class Conexao
	Private GConn
	Private StringConn
	Private BaseFileName
	Private BaseFilePathFinal
	Private BaseFullPathFinal
	Private TestServers
	Private CurrentServer
	Private Opened
	
	Public Property Get State()
		State = GConn.State
	End Property
	
	Public Property Get Conn()
		Set Conn = GConn
	End Property
	
	Public Property Let Conn(PConn)
		Set GConn = PConn
	End Property
	
	Sub Class_Initialize()
		TestServers = Array("localhost", "gustavo-pc")
		CurrentServer = LCase( Request.ServerVariables("SERVER_NAME") )
		BaseFileName = "digital.mdb"
		BaseFilePathFinal = "e:\home\gustavofelizola\Dados\"
		
		For i = 0 To Ubound( TestServers )
			If TestServers(i) = CurrentServer Then
				BaseFilePathFinal = Server.MapPath( "/Bancos/" ) & "\"
			End If
		Next
		
		BaseFullPathFinal = BaseFilePathFinal & BaseFileName
		
		Set GConn = Server.CreateObject ("ADODB.Connection")
				
		' -- ACCESS ---------
		StringConn = "Provider=Microsoft.jet.OLEDB.4.0;Data Source=" & BaseFullPathFinal
		
		Opened = False
	End Sub
	
	Sub Class_Terminate()
		If State = 1 Then CloseConn()
		Set GConn = Nothing
		Opened = False
	End Sub
	
	Public Function StartTrans()
		GConn.BeginTrans
	End Function
	
	Public Function RollBackTrans()
		GConn.RollBackTrans
	End Function
	
	Public Function CommitTrans()
		GConn.CommitTrans
	End Function
	
	Public Function CloseConn()
		GConn.Close()
	End Function
	
	Public Function OpenConn()
		Set GConn = Server.CreateObject ("ADODB.Connection")
		GConn.Open StringConn
		Opened = True
	End Function
	
	Public Function Exec(Comand)
		BackOpened = Opened
		If Not Opened Then OpenConn
		GConn.Execute Comand
		If Not BackOpened Then CloseConn
	End Function
End Class
%>