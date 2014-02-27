<%-- 
    Document   : reprovado
    Created on : 13/04/2012, 11:32:54
    Author     : portal
--%>

<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.core.Context"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
String id = request.getParameter("id_user");
Context context = new Context();
EPerson eperson = EPerson.find(context, Integer.parseInt(id));
String nome = "";
if(eperson != null){
    nome = eperson.getFullName();
}
%>

<dspace:layout locbar="link" navbar="admin" parentlink="/dspace-admin/" parenttitlekey="Administrador">
    
    <p style="margin-left: auto; margin-right: auto; text-align: center; font-size: 14pt; font-weight: bold;">
           O cadastro foi rejeitado com sucesso
    </p>
    
    <p style="margin-left: auto; margin-right: auto; text-align: center; font-size: 12pt;">
        Agora, o usuário <b><%= nome %></b> não poderá logar mais no RIUFPA.<br />
        Um e-mail foi enviado para esse usuário dizendo que ele teve seu cadastro rejeitado.
    </p>
    
</dspace:layout>