<%@page import="servletsRIUFPA.estatisticas.controller.Estatisticas.Resultado"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<%
    ArrayList<Resultado> itens = (ArrayList<Resultado>) request.getAttribute("itens");
%>

<dspace:layout navbar="off" titlekey="jsp.statistics.report.title" >

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>
    <style type="text/css">
        .tabela .qtde{
            text-align: center;
        }
    </style>

    <h1><fmt:message key="estatistica.titulo"/></h1>

    <dspace:include page="/statistics/navbar.jsp" />

    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.itensMaisBaixados"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.item.nome.arquivo"/></th>
            <th><fmt:message key="estatistica.qtdeDownloads"/></th>
        </tr>

        <%
            for (int i = 0; i < itens.size(); i++) {

                if(i % 2 == 0){
        %>
        <tr>
            <%
                } else {
                %>
        <tr class="stripe">
            <%}%>

            <td>
                <a href="<%= itens.get(i).getUrl() %>" target="_blank">
                    <%= itens.get(i).getNome() %>
                </a>
            </td>
            <td class="qtde">
                <%= itens.get(i).getVisitas() %>
            </td>
        </tr>
        <%
            }
        %>

    </table>

</dspace:layout>