<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="admin/includes/funcoes.asp" -->
<!-- #include file="admin/includes/commons.asp" -->
<!-- #include file="admin/includes/conexao.asp" -->
<!-- #include file="admin/includes/dao.asp" -->
<% URLXML = Server.MapPath( "admin/xml/config.xml" ) %>
<!-- #include file="admin/includes/get_dados.asp" -->
<%
Set Dao = new GlobalDAO
Dao.Init "Contatos", Dados

Set Objeto = Server.CreateObject("Scripting.Dictionary")
For Each Col In Dados.Item("Contatos")
	Objeto.Add Col, ""
Next

Corpo = "Dados enviados pelo formulário de contato do site<br><br>"

Function AcertaCampo(nomeCampo)
	valor = Ucase( Trim( Request.Form(nomeCampo) ) )
	valor = Replace( valor , "'" , "" )
	
	Corpo = Corpo & NomeCampo & ": " & Valor & "<br>"
	
	Objeto.Item(nomeCampo) = valor
	AcertaCampo = valor
End Function 

AcertaCampo "Nome"
AcertaCampo "Email"
AcertaCampo "Mensagem"

Objeto.Item("DataCriacao") = Now

Retorno = Dao.Insert( Objeto )

SET AspEmail = Server.CreateObject("Persits.MailSender")
AspEmail.Host = "localhost"
AspEmail.FromName = "Contato"
AspEmail.From = "contato@digitalppg.com"
 
'Configura os destinatários da mensagem
AspEmail.AddAddress "gfelizola@gmail.com", "Dell - PartnerDirect"
'AspEmail.AddAddress "digital@digitalppg.com", "Digital"
AspEmail.Subject = "Novo contato - Site Digital"
AspEmail.IsHTML = True
AspEmail.Body = Corpo

On Error Resume Next
 
AspEmail.Send
 
'Caso ocorra problemas no envio, descreve os detalhes do mesmo.
If Err <> 0 Then
	erro = "<b><font color='red'> Erro ao enviar a mensagem.</font></b><br>"
	erro = erro & "<b>Erro.Description:</b> " & Err.Description & "<br>"
	erro = erro & "<b>Erro.Number:</b> "      & Err.Number & "<br>"
	erro = erro & "<b>Erro.Source:</b> "      & Err.Source & "<br>"
	Response.write erro
Else
    Response.write "<font color='blue'><b>Mensagem enviada com sucesso</b></font> "
	Response.Redirect("default.asp?sucesso=true")
End If

SET AspEmail = Nothing
%>