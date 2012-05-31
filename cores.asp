<% 
OutL( "#home.area, home .imagem {" )
OutL( "background: #414141; /* Old browsers */" )
OutL( "background: -moz-radial-gradient(center, ellipse cover, #414141 0%, #161616 100%); /* FF3.6+ */" )
OutL( "background: -webkit-gradient(radial, center center, 0px, center center, 100%, color-stop(0%,#414141), color-stop(100%,#161616)); /* Chrome,Safari4+ */" )
OutL( "background: -webkit-radial-gradient(center, ellipse cover, #414141 0%,#161616 100%); /* Chrome10+,Safari5.1+ */" )
OutL( "background: -o-radial-gradient(center, ellipse cover, #414141 0%,#161616 100%); /* Opera 12+ */" )
OutL( "background: -ms-radial-gradient(center, ellipse cover, #414141 0%,#161616 100%); /* IE10+ */" )
OutL( "background: radial-gradient(center, ellipse cover, #414141 0%,#161616 100%); /* W3C */" )
OutL( "filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#414141', endColorstr='#161616',GradientType=1 ); /* IE6-8 fallback on horizontal gradient */" )
OutL( "}" )

Dao.Init "Categorias", Dados
Set Lista = Dao.FindAll

For Each Cor In Lista.Items
	Sig = Cor.Item("Sigla")
	CorE = Cor.Item("Cor_Fora")
	CorI = Cor.Item("Cor_Dentro")
	
	OutL( "#" & Sig & ".area, " & Sig & " .imagem {" )
	OutL( "background: " & CorE & "; /* Old browsers */" )
	OutL( "background: -moz-radial-gradient(center, ellipse cover, " & CorE & " 0%, " & CorI & " 100%); /* FF3.6+ */" )
	OutL( "background: -webkit-gradient(radial, center center, 0px, center center, 100%, color-stop(0%," & CorE & "), color-stop(100%," & CorI & ")); /* Chrome,Safari4+ */" )
	OutL( "background: -webkit-radial-gradient(center, ellipse cover, " & CorE & " 0%," & CorI & " 100%); /* Chrome10+,Safari5.1+ */" )
	OutL( "background: -o-radial-gradient(center, ellipse cover, " & CorE & " 0%," & CorI & " 100%); /* Opera 12+ */" )
	OutL( "background: -ms-radial-gradient(center, ellipse cover, " & CorE & " 0%," & CorI & " 100%); /* IE10+ */" )
	OutL( "background: radial-gradient(center, ellipse cover, " & CorE & " 0%," & CorI & " 100%); /* W3C */" )
	OutL( "filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='" & CorE & "', endColorstr='" & CorI & "',GradientType=1 ); /* IE6-8 fallback on horizontal gradient */" )
	OutL( "}" )
	
Next
%>
