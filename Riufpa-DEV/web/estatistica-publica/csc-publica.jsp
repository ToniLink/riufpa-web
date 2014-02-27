

<%@page import="org.dspace.content.Collection"%>
<%@page import="org.dspace.content.Community"%>
<%--
  - Renders a page containing a statistical summary of the repository usage
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<dspace:layout navbar="off"  titlekey="jsp.statistics.report.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>
    <h1><fmt:message key="estatistica.titulo.publica"/></h1>

    <dspace:include page="/estatistica-publica/navbar-publica.jsp" />

    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.comuSubcomuCol"/></td>
        </tr>

        <tr>
            <td><fmt:message key="estatistica.qtde.comu"/></td>
            <td class="qtde">${requestScope.total_comunidades}</td>
        </tr>

        <tr class="stripe">
            <td><fmt:message key="estatistica.qtde.subcom"/></td>
            <td class="qtde">${requestScope.total_sub_comunidades}</td>
        </tr>

        <tr>
            <td><fmt:message key="estatistica.qtde.col"/></td>
            <td class="qtde">${requestScope.total_colecoes}</td>
        </tr>
    </table>


   
</dspace:layout>



