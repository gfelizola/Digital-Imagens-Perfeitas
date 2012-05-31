<!-- #include file="funcoes.asp" -->
<!-- #include file="commons.asp" -->
<!-- #include file="conexao.asp" -->
<!-- #include file="dao.asp" -->
<!-- #include file="get_dados.asp" -->
<%
Response.Charset = "ISO-8859-1"

Set Con = new Conexao
Con.OpenConn

SQL = Request("sql")

If Sql <> "" Then

	'spl = Split( SQL, ";" )
	'Tabela = spl(0)
	'Filtro = spl(1)
	
	'AcertarOrdem Tabela, Filtro, Con.Conn 

	Set RS = Server.CreateObject("ADODB.RecordSet")
	Rs.Open sql, Con.Conn, 3
	
	
End If
%>
<html>
<head><title>SQL RESULT</title></head>
<body>
<form action="select.asp" method="post">
	<textarea name="sql" id="sql" cols="100" rows="10"><%=sql%></textarea>
	<br>
	<input type="submit" name="enviar" value="Rodar" />
</form>
<%
If Sql <> "" Then
	If rs.RecordCount > 0 Then
%>
<table cellpadding="1" cellspacing="5" boder="2">
    <tr>
		<% 
        'Percorre cada campo e imprime o nome dos campos da tabela
        For i = 0 to rs.fields.count - 1 
        	%>
        	<td><strong><% = rs(i).name %></strong></td>
       		<% 
		Next 
		%>
    </tr>
    <% 
    
    'Percorre cada linha e exibe cada campo da tabela
    
    While Not rs.eof
    %>
        <tr>
			<% For i = 0 to rs.fields.count - 1 %>
                <td><% Response.Write( rs(i) ) %></td>
            <% Next %>
        </tr>
    <%
    rs.MoveNext
    
    Wend
    
    rs.Close
    Con.CloseConn
	
	Set rs = Nothing
    %>
</table>
<%
	End If
End If
%>
</body>
</html>