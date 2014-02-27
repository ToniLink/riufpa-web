<%--
  - display-statistics.jsp
  -
  - Version: $Revision$
  -
  - Date: $Date$
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
--%>

<%@page import="org.dspace.content.Collection"%>
<%@page import="org.dspace.content.Community"%>
<%--
  - Display item/collection/community statistics
  -
  - Attributes:
  -    statsVisits - bean containing name, data, column and row labels
  -    statsMonthlyVisits - bean containing name, data, column and row labels
  -    statsFileDownloads - bean containing name, data, column and row labels
  -    statsCountryVisits - bean containing name, data, column and row labels
  -    statsCityVisits - bean containing name, data, column and row labels
  -    isItem - boolean variable, returns true if the DSO is an Item
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Community[] comunidades = (Community[]) request.getAttribute("comunidades");
    Community[] sub_comunidades = (Community[]) request.getAttribute("sub_comunidades");
    Collection[] colecoes = (Collection[]) request.getAttribute("colecoes");
    String[] acessoComu = (String[]) request.getAttribute("aceComu");
    String[] acessoSubComu = (String[]) request.getAttribute("aceSubComu");
    String[] acessoCol = (String[]) request.getAttribute("aceCole");
%>


<dspace:layout navbar="off" titlekey="jsp.statistics.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>

    <h1><fmt:message key="estatistica.titulo"/></h1>

    <dspace:include page="/statistics/navbar.jsp" />

    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.visuComunidade"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.nomeComunidade"/></th>
            <th><fmt:message key="estatistica.qtdeAcessos"/></th>
        </tr>

        <%
            int cont = 0;
            for (int i = 0; i < comunidades.length; i++) {
                if (cont % 2 == 0) {
        %>
        <tr>
            <%
                } else {
            %>
        <tr class="stripe">
            <%
                }
            %>
            <td><%= comunidades[i].getName() %></td>
            <td class="qtde"><%= acessoComu[i] %></td>
        </tr>
        <%
                cont++;
            }
        %>

    </table>

    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.visuSubcomunidade"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.nomeSubcomunidade"/></th>
            <th><fmt:message key="estatistica.qtdeAcessos"/></th>
        </tr>

        <%
            cont = 0;
            for (int i = 0; i < sub_comunidades.length; i++) {
                if (cont % 2 == 0) {
        %>
        <tr>
            <%           } else {
            %>
        <tr class="stripe">
            <%               }
            %>
            <td><%= sub_comunidades[i].getName() %></td>
            <td class="qtde"><%= acessoSubComu[i] %></td>
        </tr>
        <%
                cont++;
            }
        %>

    </table>

    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.visuColecao"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.nomeColecao"/></th>
            <th><fmt:message key="estatistica.qtdeAcessos"/></th>
        </tr>

        <%
            cont = 0;
            for (int i = 0; i < colecoes.length; i++) {
                if (cont % 2 == 0) {
        %>
        <tr>
            <%           } else {
            %>
        <tr class="stripe">
            <%
                }
            %>
            <td><%= colecoes[i].getName() %></td>
            <td class="qtde"><%= acessoCol[i] %></td>
        </tr>
        <%
                cont++;
            }
        %>
    </table>

</dspace:layout>



