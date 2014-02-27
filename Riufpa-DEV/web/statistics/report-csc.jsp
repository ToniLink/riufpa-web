<%--
  - report.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
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
  - Renders a page containing a statistical summary of the repository usage
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    Community[] comunidades = (Community[]) request.getAttribute("comunidades");
    Community[] sub_comunidades = (Community[]) request.getAttribute("sub_comunidades");
    Collection[] colecoes = (Collection[]) request.getAttribute("colecoes");
%>

<dspace:layout navbar="off" parentlink="/dspace-admin" parenttitlekey="jsp.administer" titlekey="jsp.statistics.report.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>
    <h1><fmt:message key="estatistica.titulo"/></h1>

    <dspace:include page="/statistics/navbar.jsp" />

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


    <table class="tabela">

        <tr id="tituloTabela">
            <td><fmt:message key="estatistica.comunidades"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.comunidades.nome"/></th>
        </tr>

        <%
            for (int i = 0; i < comunidades.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr>
            <%            } else {%>
        <tr class="stripe">
            <%            }%>
            <td><%= comunidades[i].getName() %></td>
        </tr>
        <%
            }
        %>
    </table>


    <table class="tabela">

        <tr id="tituloTabela">
            <td><fmt:message key="estatistica.subcomunidades"/></td>
        </tr>
        <tr>
            <th><fmt:message key="estatistica.subcomunidades.nome"/></th>
        </tr>

        <%
            for (int i = 0; i < sub_comunidades.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr>
            <%            } else {%>
        <tr class="stripe">
            <%            }%>
            <td><%= sub_comunidades[i].getName() %></td>
        </tr>
        <%
            }
        %>
    </table>


    <table class="tabela">

        <tr id="tituloTabela">
            <td><fmt:message key="estatistica.colecao"/></td>
        </tr>
        <tr>
            <th><fmt:message key="estatistica.colecao.nome"/></th>
        </tr>

        <%
            for (int i = 0; i < colecoes.length; i++) {
                if (i % 2 == 0) {
        %>
        <tr>
            <%            } else {%>
        <tr class="stripe">
            <%            }%>
            <td><%= colecoes[i].getName() %></td>
        </tr>
        <%
            }
        %>
    </table>

</dspace:layout>



