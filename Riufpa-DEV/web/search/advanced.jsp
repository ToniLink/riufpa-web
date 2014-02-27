<%--
  - advanced.jsp
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

<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%--
  - Advanced Search JSP
  -
  -
  -
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.search.QueryResults" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<%
    Community[] communityArray = (Community[]) request.getAttribute("communities");
    String query1 = request.getParameter("query1") == null ? "" : request.getParameter("query1");
    String query2 = request.getParameter("query2") == null ? "" : request.getParameter("query2");
    String query3 = request.getParameter("query3") == null ? "" : request.getParameter("query3");

    String field1 = request.getParameter("field1") == null ? "ANY" : request.getParameter("field1");
    String field2 = request.getParameter("field2") == null ? "ANY" : request.getParameter("field2");
    String field3 = request.getParameter("field3") == null ? "ANY" : request.getParameter("field3");

    String conjunction1 = request.getParameter("conjunction1") == null ? "AND" : request.getParameter("conjunction1");
    String conjunction2 = request.getParameter("conjunction2") == null ? "AND" : request.getParameter("conjunction2");

    QueryResults qResults = (QueryResults) request.getAttribute("queryresults");
%>

<dspace:layout titlekey="jsp.search.advanced.title"
               nocache="true">

    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/advanced.js"></script>

    <%-- Inicializa os nomes dos tipos dos documentos independentemente do idioma.--%>
    <script type="text/javascript">
        TipoDoc.article = "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.search.advanced.type.article") %>";
        TipoDoc.masterThesis = "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.search.advanced.type.masterThesis") %>";
        TipoDoc.doctoralThesis = "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.search.advanced.type.doctoralThesis") %>";
        TipoDoc.review = "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.search.advanced.type.review") %>";
        TipoDoc.conferenceObject = "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.search.advanced.type.conferenceObject") %>";
    </script>

    <style type="text/css">
        .buscaAvanForm{
            width: 60%;
            padding: 20px;
            background: #EBF0FD;
            overflow:auto;

            margin-left:auto;
            margin-right:auto;

            /* Border style */
            border: 1px solid #5E78B5;
            -moz-border-radius: 3px;
            -webkit-border-radius: 3px;
            border-radius: 3px;
        }
        .buscaAvanForm th{
            line-height: 0;
        }
        .buscaAvanForm h3{
            text-align: center;
            font-size: 14pt;
            text-shadow: 1px 1px 1px rgb(204, 204, 204);
        }

        #alerta{
            color: red;
        }
    </style>

    <form action="<%= request.getContextPath()%>/simple-search" method="get">

        <table class="buscaAvanForm">
            <tr>
                <th colspan="3">
            <h3>
                <fmt:message key="jsp.search.advanced.title"/>
            </h3>
            </th>
            </tr>

            <%
                if (request.getParameter("query") != null) {
                    if (qResults.getErrorMsg() != null) {
                        String qError = "jsp.search.error." + qResults.getErrorMsg();
            %>
            <tr>
                <th colspan="3" id="alerta">
                    <fmt:message key="<%= qError%>"/>
                </th>
            </tr>
            <%
            } else {
            %>
            <tr>
                <th colspan="3" id="alerta">
                    <fmt:message key="jsp.search.general.noresults"/>
                </th>
            </tr>
            <%                    }
                }
            %>
            <tr>
                <td>
                    <strong><fmt:message key="jsp.search.advanced.search"/></strong>
                </td>
                <td colspan="2">
                    <input type="hidden" name="advanced" value="true"/>
                    <select name="location">
                        <option selected="selected" value="/"><fmt:message key="jsp.general.genericScope"/></option>
                        <%
                            for (int i = 0; i < communityArray.length; i++) {
                        %>
                        <option value="<%= communityArray[i].getHandle()%>"><%= communityArray[i].getMetadata("name")%></option>
                        <%
                            }
                        %>
                    </select>
                </td>
            </tr>

            <tr>
                <td>

                </td>
                <td>
                    <b><label for="tfield1"><fmt:message key="jsp.search.advanced.type"/></label></b>
                </td>
                <td>
                    <b><label for="tquery1"><fmt:message key="jsp.search.advanced.searchfor"/></label></b>
                </td>
            </tr>

            <tr>
                <td></td>

                <td>
                    <select onchange="exibirBusca(this, 'tipo_doc', 'tquery1');" name="field1" id="tfield1">
                        <option value="ANY" <%= field1.equals("ANY") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.keyword"/></option>
                        <option value="author" <%= field1.equals("author") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.author"/></option>
                        <option value="title" <%= field1.equals("title") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.title"/></option>
                        <option value="keyword" <%= field1.equals("keyword") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.subject"/></option>
                        <option value="abstract" <%= field1.equals("abstract") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.abstract"/></option>
                        <option value="series" <%= field1.equals("series") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.series"/></option>
                        <option value="sponsor" <%= field1.equals("sponsor") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.sponsor"/></option>
                        <option value="identifier" <%= field1.equals("identifier") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.id"/></option>
                        <option value="language" <%= field1.equals("language") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.language"/></option>
                        <option value="type" <%= field1.equals("type") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.type"/></option>
                    </select>
                </td>

                <td>
                    <%--ComboBox para quando o item "tipos de documentos" for selecionado.--%>
                    <select onchange="preencherCampo('tipo_doc', 'tquery1');" id="tipo_doc" style="display: none;">
                        <option>
                            <fmt:message key="jsp.search.advanced.type.article"/>
                        </option>
                        <option>
                            <fmt:message key="jsp.search.advanced.type.masterThesis"/>
                        </option>
                        <option>
                            <fmt:message key="jsp.search.advanced.type.doctoralThesis"/>
                        </option>
                        <option>
                            <fmt:message key="jsp.search.advanced.type.review"/>
                        </option>
                        <option>
                            <fmt:message key="jsp.search.advanced.type.conferenceObject"/>
                        </option>
                    </select>
                    <%-- Campo de texto para a pesquisa--%>
                    <input style="display: block;" type="text" name="query1" id="tquery1" value="<%=StringEscapeUtils.escapeHtml(query1)%>" size="50" />
                </td>
            </tr>

            <tr>
                <td>
                    <select name="conjunction1" id="conjunction1">
                        <option value="AND" <%= conjunction1.equals("AND") ? "selected=\"selected\"" : ""%>> <fmt:message key="jsp.search.advanced.logical.and" /> </option>
                        <option value="OR" <%= conjunction1.equals("OR") ? "selected=\"selected\"" : ""%>> <fmt:message key="jsp.search.advanced.logical.or" /> </option>
                        <option value="NOT" <%= conjunction1.equals("NOT") ? "selected=\"selected\"" : ""%>> <fmt:message key="jsp.search.advanced.logical.not" /> </option>
                    </select>
                </td>
                <td>
                    <select onchange="exibirBusca(this, 'tipo_doc2', 'query2');" name="field2" id="field2">
                        <option value="ANY" <%= field2.equals("ANY") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.keyword"/></option>
                        <option value="author" <%= field2.equals("author") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.author"/></option>
                        <option value="title" <%= field2.equals("title") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.title"/></option>
                        <option value="keyword" <%= field2.equals("keyword") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.subject"/></option>
                        <option value="abstract" <%= field2.equals("abstract") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.abstract"/></option>
                        <option value="series" <%= field2.equals("series") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.series"/></option>
                        <option value="sponsor" <%= field2.equals("sponsor") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.sponsor"/></option>
                        <option value="identifier" <%= field2.equals("identifier") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.id"/></option>
                        <option value="language" <%= field2.equals("language") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.language"/></option>
                        <option value="type" <%= field1.equals("type") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.type"/></option>
                    </select>
                </td>
                <td>
                    <%--ComboBox para quando o item "tipos de documentos" for selecionado.--%>
                    <select onchange="preencherCampo(this, 'query2');" id="tipo_doc2" style="display: none;">
                        <option value="ANY" selected="selected">
                            <fmt:message key="jsp.search.advanced.type.article"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.masterThesis"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.doctoralThesis"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.review"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.conferenceObject"/>
                        </option>
                    </select>
                    <input type="text" name="query2" id="query2" value="<%=StringEscapeUtils.escapeHtml(query2)%>" size="50"/>
                </td>
            </tr>

            <tr>
                <td>
                    <select name="conjunction2" id="conjunction2">
                        <option value="AND" <%= conjunction2.equals("AND") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.logical.and" /> </option>
                        <option value="OR" <%= conjunction2.equals("OR") ? "selected=\"selected\"" : ""%>> <fmt:message key="jsp.search.advanced.logical.or" /> </option>
                        <option value="NOT" <%= conjunction2.equals("NOT") ? "selected=\"selected\"" : ""%>> <fmt:message key="jsp.search.advanced.logical.not" /> </option>
                    </select>
                </td>
                <td>

                    <select onchange="exibirBusca(this, 'tipo_doc3', 'query3');" name="field3" id="field3">
                        <option value="ANY" <%= field3.equals("ANY") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.keyword"/></option>
                        <option value="author" <%= field3.equals("author") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.author"/></option>
                        <option value="title" <%= field3.equals("title") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.title"/></option>
                        <option value="keyword" <%= field3.equals("keyword") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.subject"/></option>
                        <option value="abstract" <%= field3.equals("abstract") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.abstract"/></option>
                        <option value="series" <%= field3.equals("series") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.series"/></option>
                        <option value="sponsor" <%= field3.equals("sponsor") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.sponsor"/></option>
                        <option value="identifier" <%= field3.equals("identifier") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.id"/></option>
                        <option value="language" <%= field3.equals("language") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.language"/></option>
                        <option value="type" <%= field1.equals("type") ? "selected=\"selected\"" : ""%>><fmt:message key="jsp.search.advanced.type.type"/></option>
                    </select>
                </td>
                <td>
                    <%--ComboBox para quando o item "tipos de documentos" for selecionado.--%>
                    <select onchange="preencherCampo(this, 'query3');" id="tipo_doc3" style="display: none;">
                        <option value="ANY" selected="selected">
                            <fmt:message key="jsp.search.advanced.type.article"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.masterThesis"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.doctoralThesis"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.review"/>
                        </option>
                        <option value="ANY">
                            <fmt:message key="jsp.search.advanced.type.conferenceObject"/>
                        </option>
                    </select>
                    <input type="text" name="query3" id="query3" value="<%=StringEscapeUtils.escapeHtml(query3)%>" size="50"/>
                </td>
            </tr>

            <tr>
                <td colspan="3" style="text-align: center; padding-top: 20px;">
                    <input class="button" type="submit" name="submit" value="<fmt:message key="jsp.search.advanced.search2"/>" />
                    <button class="button" type="button" onclick="limpar();"><fmt:message key="jsp.search.advanced.clear"/></button>
                </td>
            </tr>
        </table>
    </form>

</dspace:layout>
