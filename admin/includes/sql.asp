<!-- #include file="../includes/head.asp" -->
<%
Dim sql
sql = RF("sql")

Set Dao = new GlobalDAO
Dao.Init TabelaAtual, Dados
Dao.Debug = True

Dao.Exec SQL

Set Dao = Nothing
%>
<body>
<form action="sql.asp" method="post">
	<textarea name="sql" id="sql" cols="400" rows="100"><%=sql%></textarea>
	<input type="submit" name="enviar" value="Rodar"
</form>
<%Debuga SQL%>
</body>
</html>
