<%If pageCounter > 1 Then%>
<tr>
<td align="center" colspan="3" id="area-paginacao" class="botoes">
<%
pagina = Request.QueryString("pag")
If pagina = "" then
	pagina = Session.Contents(sessaoAtual & "_pagina")
Else
	pagina = cint(pagina)
	if pagina < 1 then
		pagina = 1
	else
		if pagina > pageCounter then
			pagina = pageCounter
		end if
	end if
end if

qs = Request.ServerVariables("QUERY_STRING")
if instr(qs,"pag") > 0 then
	qss = split(qs,"&")
	qsfinal = ""
	for i = 0 to ubound(qss)
		if not instr(qss(i),"pag") > 0 then qsfinal = qsfinal & qss(i) & "&"
	next
	qs = qsfinal & "pag="
else
	if qs = "" then
		qs = qs & "pag="
	else
		qs = qs & "&pag="
	end if
end if

if pagina > 1 then
	Response.Write("<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?" & qs & "1" & " class='linkAzul botao'>PRIMEIRA</a>")
	Response.Write("<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?" & qs & (pagina-1) & " class='linkAzul botao'>ANTERIOR</a>")
else
	Response.Write("<button class='ui-state-disabled ui-priority-secondary'>PRIMEIRA</button>")
	Response.Write("<button class='ui-state-disabled ui-priority-secondary'>ANTERIOR</button>")
end if

inicio = 1
final = pageCounter

for i = inicio to final
	if i <> pagina then
		Response.Write("<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?" & qs & i & " class='linkAzul'>" & i & "</a>")
	else
		Response.Write("<button class='ui-state-disabled ui-priority-secondary'>" & i & "</button>")
	end if
next

if pagina < pageCounter then
	Response.Write("<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?" & qs & (pagina+1) & " class='linkAzul'>PRÓXIMO</a>")
	Response.Write("<a href=" & Request.ServerVariables("SCRIPT_NAME") & "?" & qs & pageCounter & " class='linkAzul'>ULTIMO</a>")
else
	Response.Write("<button class='ui-state-disabled ui-priority-secondary'>PRÓXIMO</button>")
	Response.Write("<button class='ui-state-disabled ui-priority-secondary'>ULTIMO</button>")
end if

%>
</td>
</tr>
<%
If cint(pagina) <> cint( Session.Contents(sessaoAtual & "_pagina") ) Then
	Session.Contents(sessaoAtual & "_pagina") = pagina
	Response.Redirect(Request.ServerVariables("SCRIPT_NAME") & "?" & qs & pagina)
End If
End If
%>