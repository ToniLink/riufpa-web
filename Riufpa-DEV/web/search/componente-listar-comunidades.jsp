<%--
    Document   : componente-listar-comunidades
    Created on : 17/10/2012, 10:31:23
    Author     : portal
--%>

<%@page import="org.dspace.content.Community"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    Community[] comunidades = (Community[]) request.getAttribute("communities");
%>

<table class="tabela">
    <tr class="tituloTabela">
        <td colspan="2"><fmt:message key="search.results.comunidades"/></td>
    </tr>

    <tr>
        <th><fmt:message key="search.results.nome"/></th>
        <th><fmt:message key="search.results.qtde"/></th>
    </tr>

    <%
        String listra = "";
        for (int i = 0; i < comunidades.length; i++) {
            if (i % 2 == 0) {
                listra = "class=\"stripe\"";
            } else {
                listra = "";
            }
    %>
    <tr <%=listra%>>
        <td>
            <a href="<%= request.getContextPath()%>/handle/<%= comunidades[i].getHandle()%>">
                <%= comunidades[i].getName()%>
            </a>
        </td>
        <td class="num">
            <%= comunidades[i].countItems() %>
        </td>
    </tr>
    <%
        }
    %>
</table>