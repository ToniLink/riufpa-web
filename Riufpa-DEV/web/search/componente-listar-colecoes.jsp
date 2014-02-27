<%--
    Document   : componente-listar-colecoes
    Created on : 17/10/2012, 11:30:01
    Author     : portal
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@page import="org.dspace.content.Collection"%>

<%
    Collection[] colecoes = (Collection[]) request.getAttribute("collections");

%>

<table class="tabela">
    <tr class="tituloTabela">
        <td colspan="2"><fmt:message key="search.results.colecoes"/></td>
    </tr>

    <tr>
        <th><fmt:message key="search.results.nome"/></th>
        <th><fmt:message key="search.results.qtde"/></th>
    </tr>

    <%
        String listra = "";
        for (int i = 0; i < colecoes.length; i++) {
            if (i % 2 == 0) {
                listra = "class=\"stripe\"";
            } else {
                listra = "";
            }
    %>
    <tr <%=listra%>>
        <td>
            <a href="<%= request.getContextPath()%>/handle/<%= colecoes[i].getHandle()%>">
                <%= colecoes[i].getName()%>
            </a>
        </td>
        <td class="num">
            <%= colecoes[i].countItems() %>
        </td>
    </tr>
    <%
        }
    %>
</table>