<!-- #include file="../includes/commons.asp" -->
<!-- #include file="../includes/funcoes.asp" -->
<%
ObjetoToLog Session("Usuario_Login"), "Logout", "Sistema"
Session.Abandon()
Response.Redirect("../Login?e=3")
%>