<!-- #include file="../includes/head.asp" -->
<%
If Session.Contents(SessaoAtual & "_pagina") = "" Then
	Session.Contents(SessaoAtual & "_pagina") = 1
End If

filtro = Request.QueryString("f")
ordem = Request.QueryString("o")
AreaAtual = Request.QueryString("area")

If filtro = "" Then
	If Session.Contents(sessaoAtual & "_filtro") = "" Then
		filtro = "Ordem"
		ordem = ""
	Else
		filtro = Session.Contents(sessaoAtual & "_filtro")
		ordem = Session.Contents(sessaoAtual & "_ordem")
	End IF
End If

AreaStr = "0 = 1"
If AreaAtual = "" Then
	If Session.Contents(sessaoAtual & "_area") = "" Then
		AreaAtual = ""
	Else
		AreaAtual = Session.Contents(sessaoAtual & "_area")
	End If
End If

filtroNome = filtro
ordemStr = "DESC"
If ordem = "DESC" Then ordemStr = ""

If filtro <> Session.Contents(sessaoAtual & "_filtro") Then Session.Contents(sessaoAtual & "_filtro") = filtro
If ordem <> Session.Contents(sessaoAtual & "_ordem") Then Session.Contents(sessaoAtual & "_ordem") = ordem
If AreaAtual <> Session.Contents(sessaoAtual & "_area") Then Session.Contents(sessaoAtual & "_area") = AreaAtual

If AreaAtual <> "" And AreaAtual <> "0" Then AreaStr = " Categoria = " & AreaAtual

sqlEnd = filtro & " " & ordem

Set Dao = new GlobalDao
Dao.Init SessaoAtual , Dados
Dao.OrderBy = sqlEnd
Dao.StartPage = Session.Contents(sessaoAtual & "_pagina")
Dao.MaxRows = 18

Set Lista = Dao.FindByWhere( AreaStr )
PageCounter = Floor( Dao.RecordCount / TamPagina, 0)
If ( Dao.RecordCount Mod TamPagina ) > 0 Then PageCounter = PageCounter + 1
Set Dao = Nothing
%>
<body>
<!-- #include file="../includes/header.asp" -->
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td valign="top">
			<table align="left" cellpadding="5" width="100%">
				<tr>
					<td width="150" nowrap="nowrap" class="titulo_area"><%=Dados.Item( SessaoAtual & "Nome" )%></td>
					<td width="200" nowrap="nowrap">Categoria: 
						<select name="FiltroArea" id="FiltroArea">
							<option value="0"></option>
							<%
							Set Dao = new GlobalDao
							Dao.Init "Categorias", Dados
							Dao.OrderBy = "Nome"
							
							Set Areas = Dao.FindAll
							
							For Each Area In Areas.Items
								Sel = ""
								If AreaAtual <> "" Then
									If CDbl(AreaAtual) = Area.Item("Codigo") Then Sel = "selected='selected'"
								End IF
								OutL "<option value='" & Area.Item("Codigo") & "' " & sel & ">" & Area.Item("Nome") & "</option>"
							Next
							Set Dao = Nothing
							%>
						</select>
					</td>
					<td>
						<%
						If Session("Sucesso") <> "" Then
						%>
						<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"> 
							<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span> 
							<strong>Alerta:</strong> <%=Session("Sucesso")%>.</p>
						</div>
						<%
						Session("Sucesso") = ""
						End If
						%>
					</td>
					<%
					If Lista.Count < 18 Then
					%>
					<td width="400" nowrap="nowrap" align="right">
						<a href='formulario.asp?ac=1' class="botao">Inserir Nova Imagem</a>
						<a href='formulario2.asp?ac=1' class="botao">Inserir Novo Vídeo</a>
					</td>
					<%
					End If
					%>
				</tr>
			</table>
			<%If Lista.Count > 0 Then%>
			<table align="left" cellpadding="5" width="100%">
				<thead>
					<tr class="ui-widget-header">
						<%
						ColsNames = Array()
						ColsBases = Array()
						
						ColsFora = Array("Codigo", "Categoria", "Tipo", "DataModificacao")
						
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
							Out "<th>" & ColsNames(i) & "</th>"
						Next
						%>
						<th width="180" nowrap="nowrap">Ações</th>
					</tr>
				</thead>
				<tbody>
					<%
					C = 0
					For Each Item In Lista.Items
						OutL "<tr class='ui-widget-content linha-lista'>"
						For Each Col In ColsBases
							If TypeName( Item.Item( Col ) ) <> "Nothing" Then
								If Col = "Ordem" Then
									Out "<td width='50'>" & Item.Item( Col ) 
									If C < Lista.Count - 1 Then Out "<a href='acoes.asp?id=" & Item.Item( "Codigo" ) & "&ac=descer' class='ui-icon ui-icon-triangle-1-s' style='float:right;'></a>"
									If C > 0 Then Out "<a href='acoes.asp?id=" & Item.Item( "Codigo" ) & "&ac=subir' class='ui-icon ui-icon-triangle-1-n' style='float:right;'></a>"
									OutL "</td>"
								ElseIf Col = "Arquivo" Then
									If InStr( Item.Item("Arquivo"), "youtube" ) > 0 Then
										QS = Split( Item.Item("Arquivo"), "?")
										Attrs = Split( QS( Ubound( QS ) ), "&")
										For i = 0 To Ubound( Attrs )
											If InStr (Attrs(i) ,"v") > 0 Then
												Vars = Split( Attrs(i), "=" )
												Codigo = Vars( Ubound(Vars) )
												Link = "http://www.youtube.com/watch?v=" & Codigo
											End If
										Next
										Imagem = "http://i1.ytimg.com/vi/" & Codigo & "/default.jpg"
									Else
										Imagem = "../../arquivos/" & Item.Item( Col )
									End IF
									
									OutL "<td width='150' align='center'><img src='" & Imagem & "' height='100' /></td>"
								Else
									OutL "<td>" & Item.Item( Col ) & "</td>"
								End IF
							Else
								Response.Write "<td>&nbsp;</td>" & vbCrlf
							End If
						Next
						
						OutL "<td align='center'>"
						OutL "<a href='formulario.asp?id=" & Item.Item( "Codigo" ) & "&ac=3' class='botao'>Apagar</a>"
						OutL "</td>"
						OutL "</tr>"
						
						C = C + 1
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