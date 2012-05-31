<%
Dim Estados, Tipos, Zonas, ServerNames, UpTypes, Emails, Semana, SemanaShort

Const EncC1 = 109
Const EncC2 = 191
Const EncKey = 161
Dim HojeFormatado
HojeFormatado = StrZero( Day(Now) , 2) & "/" & StrZero( Month(Now) , 2 ) & "/" & StrZero(Year(Now),4)

ScriptAtual = Request.ServerVariables("SCRIPT_NAME")
ScriptSplit = Split( ScriptAtual , "/" )
ArquivoAtual = ScriptSplit( Ubound(ScriptSplit) )

TamPagina = 50

ServerNames = Array()
UpTypes = Array()

ArrayPush serverNames, "agente16"
ArrayPush serverNames, "localhost"
ArrayPush serverNames, "www.gustavofelizola.com"
ArrayPush serverNames, "catavento.gustavofelizola.com"
ArrayPush serverNames, "fabricadecultura.org.br"

ArrayPush upTypes, 1
ArrayPush upTypes, 1
ArrayPush upTypes, 2
ArrayPush upTypes, 2
ArrayPush upTypes, 3

UploadsDir = "../../arquivos/"
UploadsDirVar = Server.MapPath( UploadsDir )
%>