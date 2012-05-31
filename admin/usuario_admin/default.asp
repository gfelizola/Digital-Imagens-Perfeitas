<!-- #include file="../includes/head.asp" -->
<%
If Session.Contents(SessaoAtual & "_pagina") = "" Then
	Session.Contents(SessaoAtual & "_pagina") = 1
End If

filtro = Request.QueryString("f")
ordem = Request.QueryString("o")

If filtro = "" Then
	If Session.Contents(sessaoAtual & "_filtro") = "" Then
		filtro = "Nome"
		ordem = ""
	Else
		filtro = Session.Contents(sessaoAtual & "_filtro")
		ordem = Session.Contents(sessaoAtual & "_ordem")
	End IF
End If
filtroNome = filtro
ordemStr = "DESC"
If ordem = "DESC" Then ordemStr = ""

If filtro <> Session.Contents(sessaoAtual & "_filtro") Then Session.Contents(sessaoAtual & "_filtro") = filtro
If ordem <> Session.Contents(sessaoAtual & "_ordem") Then Session.Contents(sessaoAtual & "_ordem") = ordem

sqlEnd = filtro & " " & ordem

Set Dao = new GlobalDao
Dao.Init SessaoAtual , Dados
Dao.OrderBy = sqlEnd
Dao.StartPage = Session.Contents(sessaoAtual & "_pagina")
TamPagina = Dao.MaxRows

' -- REMOVENDO USUARIO DE SEGURANÇA ----
Set Lista = Dao.FindByWhere("codigo <> 1")
PageCounter = 0

If Dao.RecordCount <> 0 Then 
	PageCounter = Floor( Dao.RecordCount / TamPagina, 0)
	If ( Dao.RecordCount Mod TamPagina ) > 0 Then PageCounter = PageCounter + 1
End If
Set Dao = Nothing
%>
<body>
<!-- #include file="../includes/header.asp" -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td valign="top">
			<table align="left" cellpadding="5" width="100%">
				<tr>
					<td width="100" nowrap="nowrap"><%=Dados.Item( SessaoAtual & "Nome" )%></td>
					<td>
						<%
						If Session("Sucesso") <> "" Then
						%>
						<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"> 
							<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span> 
							<strong>Alerta:</strong> <%=Session("Sucesso")%></p>
						</div>
						<%
						Session("Sucesso") = ""
						End If
						%>
					</td>
					<td width="100" nowrap="nowrap" align="right"><a href='formulario.asp?ac=1' class="botao">Inserir Novo</a></td>
				</tr>
			</table>
			<%If Lista.Count > 0 Then%>
			<table align="left" cellpadding="5" width="100%">
				<thead>
					<tr class="ui-widget-header">
						<%
						ColsNames = Array()
						ColsBases = Array()
						
						ColsFora = Array("Codigo", "DataModificacao", "Senha", "Regras")
						
						For i = 0 To Ubound( Dados.Item(SessaoAtual & "Show") )
							ColName = Dados.Item(SessaoAtual & "Show")(i)
							ColBase = Dados.Item(SessaoAtual)(i)
							
							Inserir = True
							For Each Fora In ColsFora
								If LCase( ColBase ) = LCase( Fora ) Then
									Inserir = False
								End If
							Next
							If Inserir Then
								ArrayPush ColsNames , ColName
								ArrayPush ColsBases , ColBase
							End If
						Next
						
						ColsTotal = Ubound(ColsNames)
						ColSize = 80 / ( ColsTotal + 1 )
						
						For i = 0 To ColsTotal
							Response.Write("<th><a href='../")
							Response.Write( SessaoAtual & "?f=" & ColsBases(i) & "&o=" & ordemStr )
							Response.Write("' title='" & ColsNames(i) & "'>" & ColsNames(i) & vbCrlf)
							If FiltroNome = ColsBases(i) Then
								if ordem = "DESC" Then
									Response.Write("<span class='ui-icon ui-icon-triangle-1-s' style='float:right;'></span>")
								Else
									Response.Write("<span class='ui-icon ui-icon-triangle-1-n' style='float:right;'></span>")
								End If
							End If
							Response.Write("</a></th>")
						Next
						%>
						<th width="180" nowrap="nowrap">Ações</th>
					</tr>
				</thead>
				<tbody>
					<%
					For Each Item In Lista.Items
						Response.Write("<tr class='ui-widget-content linha-lista'>")
						For Each Col In ColsBases
							Response.Write "<td>" & Item.Item( Col ) & "</td>" & vbCrlf
						Next
						
						Response.Write "<td align='center'>" & vbCrlf
						Response.Write "<a href='formulario.asp?id=" & Item.Item( "Codigo" ) & "&ac=2' class='botao'>Editar</a>" & vbCrlf
						Response.Write "<a href='formulario.asp?id=" & Item.Item( "Codigo" ) & "&ac=3' class='botao'>Apagar</a>" & vbCrlf
						Response.Write "</td>" & vbCrlf
						Response.Write("</tr>")
					Next
					%>
				</tbody>
			</table>
			<%
			End If%>
		</td>
	</tr>
</table>
<!-- #include file="../includes/paginacao.asp" -->	
<!-- #include file="../includes/footer.asp" -->	
</body>
</html>