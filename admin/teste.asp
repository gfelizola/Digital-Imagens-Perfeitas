<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>
<%
Set myMail = Server.CreateObject("CDO.Message")

myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.cl03.mobimail.com"
myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "contato@gustavofelizola.com"
myMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "contato@123"
myMail.Configuration.Fields.Update

myMail.Subject = "Novo agendamento para visita ao Catavento Cultural"
myMail.From = "contato@cataventocultural.org.br"
myMail.To = "gfelizola@gmail.com"
myMail.HtmlBody = "Teste de email<br>Chega logo"

myMail.Send
Set myMail = Nothing
Response.Write("mensagem enviada com sucesso")
%>
</body>
</html>