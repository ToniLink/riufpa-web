<%--
    Document   : report-items
    Created on : 18/09/2012, 11:36:23
    Author     : Jefferson
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="servletsRIUFPA.estatisticas.controller.Estatisticas.Resultado"%>
<%@page import="org.dspace.content.Collection"%>
<%@page import="org.dspace.content.Community"%>
<%--
  - Renders a page containing a statistical summary of the repository usage
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    Community[] comunidades = (Community[]) request.getAttribute("comunidades");
    Community[] sub_comunidades = (Community[]) request.getAttribute("sub_comunidades");
    Collection[] colecoes = (Collection[]) request.getAttribute("colecoes");
    ArrayList<Resultado> itens = (ArrayList<Resultado>) request.getAttribute("itens");
%>

<dspace:layout navbar="off" titlekey="jsp.statistics.report.title" >
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>

    <h1><fmt:message key="estatistica.titulo"/></h1>

    <dspace:include page="/statistics/navbar.jsp" />

    <table class="tabela">
        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.itens"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.tipoDoc"/></th>
            <th><fmt:message key="estatistica.qtde"/></th>
        </tr>

        <tr>
            <td>Artigo de evento</td>
            <td class="qtde">${requestScope.total_trabalho}</td>
        </tr>

        <tr class="stripe">
            <td>Artigo de periódico</td>
            <td class="qtde">${requestScope.total_artigo}</td>
        </tr>
        <tr>
            <td>Dissertação (mestrado)</td>
            <td class="qtde">${requestScope.total_dissertacao}</td>
        </tr>
        <tr class="stripe">
            <td>Resenha de livro ou de artigo</td>
            <td class="qtde">${requestScope.total_resenha}</td>
        </tr>

        <tr>
            <td>Tese (doutorado)</td>
            <td class="qtde">${requestScope.total_tese}</td>
        </tr>

        <tr class="stripe">
            <td><b>Total de Itens no RIUFPA</b></td>
            <td class="qtde"><b>${requestScope.total_itens}</b></td>
        </tr>
    </table>
        
    
    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.itensMaisVisitados"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.item.nome"/></th>
            <th><fmt:message key="estatistica.qtdeAcessos"/></th>
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
        

    <table class="tabela">
        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.itensComunidade"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.nomeComunidade"/></th>
            <th><fmt:message key="estatistica.qtde"/></th>
        </tr>
        <%
            for (int i = 0; i < comunidades.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr>
            <%       } else {
            %>
        <tr class="stripe">
            <%           }
            %>
            <td><%= comunidades[i].getName()%></td>
            <td class="qtde"><%= comunidades[i].countItems()%></td>
        </tr>

        <%
            }
        %>
    </table>


    <table class="tabela">
        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.itensSubcomunidade"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.nomeSubcomunidade"/></th>
            <th><fmt:message key="estatistica.qtde"/></th>
        </tr>
        <%
            for (int i = 0; i < sub_comunidades.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr>
            <%       } else {
            %>
        <tr class="stripe">
            <%           }
            %>
            <td><%= sub_comunidades[i].getName()%></td>
            <td class="qtde"><%= sub_comunidades[i].countItems()%></td>
        </tr>

        <%
            }
        %>
    </table>

    <table class="tabela">
        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.itensColecao"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.nomeColecao"/></th>
            <th><fmt:message key="estatistica.qtde"/></th>
        </tr>
        <%
            for (int i = 0; i < colecoes.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr>
            <%       } else {
            %>
        <tr class="stripe">
            <%           }
            %>
            <td><%= colecoes[i].getName()%></td>
            <td class="qtde"><%= colecoes[i].countItems()%></td>
        </tr>

        <%
            }
        %>
    </table>

</dspace:layout>