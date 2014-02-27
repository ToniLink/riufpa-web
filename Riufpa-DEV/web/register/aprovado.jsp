<%-- 
    Document   : aprovado
    Created on : 13/04/2012, 08:59:13
    Author     : portal
--%>

<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.eperson.EPerson"%>
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
           O cadastro foi aprovado com sucesso
    </p>
    
    <p style="margin-left: auto; margin-right: auto; text-align: center; font-size: 12pt;">
        Agora, o usuário <b><%= nome %></b> poderá logar no RIUFPA.<br />
        Um e-mail foi enviado para o usuário acima dizendo que seu acesso foi liberado.
    </p>
    
</dspace:layout>