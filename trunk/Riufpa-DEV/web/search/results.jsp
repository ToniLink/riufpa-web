<%--
  - results.jsp
  -
  - Version: $Revision: 4055 $
  -
  - Date: $Date: 2009-07-07 00:25:02 +0000 (Tue, 07 Jul 2009) $
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


<%--
  - Display the results of a simple search
  -
  - Attributes to pass in:
  -
  -   community        - pass in if the scope of the search was a community
  -                      or a collection in this community
  -   collection       - pass in if the scope of the search was a collection
  -   community.array  - if the scope of the search was "all of DSpace", pass
  -                      in all the communities in DSpace as an array to
  -                      display in a drop-down box
  -   collection.array - if the scope of a search was a community, pass in an
  -                      array of the collections in the community to put in
  -                      the drop-down box
  -   items            - the results.  An array of Items, most relevant first
  -   communities      - results, Community[]
  -   collections      - results, Collection[]
  -
  -   query            - The original query
  -
  -   admin_button     - If the user is an admin
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.net.URLEncoder"            %>
<%@ page import="org.dspace.content.Community"   %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.Item"        %>
<%@ page import="org.dspace.search.QueryResults" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Set" %>

<%
    String order = (String) request.getAttribute("order");
    String ascSelected = (SortOption.ASCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    String descSelected = (SortOption.DESCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    SortOption so = (SortOption) request.getAttribute("sortedBy");
    String sortedBy = (so == null) ? null : so.getName();

    // Get the attributes
    Community community = (Community) request.getAttribute("community");
    Collection collection = (Collection) request.getAttribute("collection");
    Community[] communityArray = (Community[]) request.getAttribute("community.array");
    Collection[] collectionArray = (Collection[]) request.getAttribute("collection.array");

    Item[] items = (Item[]) request.getAttribute("items");
    Community[] communities = (Community[]) request.getAttribute("communities");
    Collection[] collections = (Collection[]) request.getAttribute("collections");

    String query = (String) request.getAttribute("query");
    String queryOriginal = query; //a ser usada na paginação, pois lá temos de ter o AND, NOT e OR.
    //TRADUZ OS BOOLEANOS PARA PORTUGUÊS.
    query = query.replaceAll("\\bAND\\b", "E");
    query = query.replaceAll("\\bNOT\\b", "NÃO");
    query = query.replaceAll("\\bOR\\b", "OU");
    QueryResults qResults = (QueryResults) request.getAttribute("queryresults");

    int pageTotal = ((Integer) request.getAttribute("pagetotal")).intValue();
    int pageCurrent = ((Integer) request.getAttribute("pagecurrent")).intValue();
    int pageLast = ((Integer) request.getAttribute("pagelast")).intValue();
    int pageFirst = ((Integer) request.getAttribute("pagefirst")).intValue();
    int rpp = qResults.getPageSize();
    int etAl = qResults.getEtAl();

    // retain scope when navigating result sets
    String searchScope = "";
    if (community == null && collection == null) {
        searchScope = "";
    } else if (collection == null) {
        searchScope = "/handle/" + community.getHandle();
    } else {
        searchScope = "/handle/" + collection.getHandle();
    }

    // Admin user or not
    Boolean admin_b = (Boolean) request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
%>

<dspace:layout titlekey="jsp.search.results.title">

    <%-- Estilos de paginação --%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/paginacao.css" type="text/css" />

    <%-- Estilos para o componente de controle de busca (ordenação, repetir pesquisa, etc) --%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/results.css" type="text/css" />

    <%-- Estilos da tabela de resultados--%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>

    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/results.js"></script>


    <%-- Controle para repetir a busca, ordenação, etc --%>
    <div class="painel" id="controlBusca">

        <h2>
            <fmt:message key="jsp.search.results.title"/>
        </h2>

        <form action="simple-search" method="get" onsubmit="return validarBusca('texto_busca', 'texto_busca_verdadeiro');">

            <table>
                <tr>
                    <td>
                        <label for="tlocation">
                            <strong><fmt:message key="jsp.search.results.searchin"/></strong>
                        </label>
                    </td>
                    <td>
                        <select name="location" id="tlocation">
                            <%
                                if (community == null && collection == null) {
                                    // Scope of the search was all of DSpace.  The scope control will list
                                    // "all of DSpace" and the communities.
                            %>
                            <%-- <option selected value="/">All of DSpace</option> --%>
                            <option selected="selected" value="/"><fmt:message key="jsp.general.genericScope"/></option>
                            <%
                                for (int i = 0; i < communityArray.length; i++) {
                            %>
                            <option value="<%= communityArray[i].getHandle()%>"><%= communityArray[i].getMetadata("name")%></option>
                            <%
                                }
                            } else if (collection == null) {
                                // Scope of the search was within a community.  Scope control will list
                                // "all of DSpace", the community, and the collections within the community.
                            %>
                            <%-- <option value="/">All of DSpace</option> --%>
                            <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                            <option selected="selected" value="<%= community.getHandle()%>"><%= community.getMetadata("name")%></option>
                            <%
                                for (int i = 0; i < collectionArray.length; i++) {
                            %>
                            <option value="<%= collectionArray[i].getHandle()%>"><%= collectionArray[i].getMetadata("name")%></option>
                            <%
                                }
                            } else {
                                // Scope of the search is a specific collection
                            %>
                            <%-- <option value="/">All of DSpace</option> --%>
                            <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                            <option value="<%= community.getHandle()%>"><%= community.getMetadata("name")%></option>
                            <option selected="selected" value="<%= collection.getHandle()%>"><%= collection.getMetadata("name")%></option>
                            <%
                                }
                            %>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="texto_busca"><fmt:message key="jsp.search.results.searchfor"/></label>
                    </td>
                    <td>
                        <%-- A query verdadeira é oculta. O usuário digita na temp_query, o javascript valida o
                        texto digitado, e insere a busca como os operadores traduzidos na query verdadeira.--%>
                        <input type="hidden" name="query" value="" id="texto_busca_verdadeiro"/>
                        <input type="text" name="temp_query" id="texto_busca" value="<%= (query == null ? "" : StringEscapeUtils.escapeHtml(query))%>"/>
                        <input type="submit" class="button" value="<fmt:message key="jsp.general.go"/>" />
                    </td>
                </tr>

            </table>
        </form>

        <hr/>

        <%-- Seção de ordenação dos resultados. --%>
        <form id="ordenar" method="get" action="<%= request.getContextPath() + searchScope + "/simple-search"%>">
            <input type="hidden" id="query" name="query" value="<%= StringEscapeUtils.escapeHtml(query)%>" />
            <table>
                <tr>
                    <td>
                        <label for="rpp"><fmt:message key="search.results.perpage"/></label>
                    </td>
                    <td>
                        <select name="rpp" id="rpp" onchange="ordenar();">
                            <%
                                for (int i = 5; i <= 100; i += 5) {
                                    String selected = (i == rpp ? "selected=\"selected\"" : "");
                            %>
                            <option value="<%= i%>" <%= selected%>><%= i%></option>
                            <%
                                }
                            %>
                        </select>
                    </td>

                    <td>
                        <label for="etal"><fmt:message key="search.results.etal" /></label>
                    </td>
                    <td>
                        <select name="etal" id="etal" onchange="ordenar();">
                            <%
                                String unlimitedSelect = "";
                                if (qResults.getEtAl() < 1) {
                                    unlimitedSelect = "selected=\"selected\"";
                                }
                            %>
                            <option value="0" <%= unlimitedSelect%>><fmt:message key="browse.full.etal.unlimited"/></option>
                            <%
                                boolean insertedCurrent = false;
                                for (int i = 0; i <= 50; i += 5) {
                                    // for the first one, we want 1 author, not 0
                                    if (i == 0) {
                                        String sel = (i + 1 == qResults.getEtAl() ? "selected=\"selected\"" : "");
                            %>
                            <option value="1" <%= sel%>>1</option>
                            <%
                                }

                                // if the current i is greated than that configured by the user,
                                // insert the one specified in the right place in the list
                                if (i > qResults.getEtAl() && !insertedCurrent && qResults.getEtAl() > 1) {
                            %>
                            <option value="<%= qResults.getEtAl()%>" selected="selected"><%= qResults.getEtAl()%></option>
                            <%
                                    insertedCurrent = true;
                                }

                                // determine if the current not-special case is selected
                                String selected = (i == qResults.getEtAl() ? "selected=\"selected\"" : "");

                                // do this for all other cases than the first and the current
                                if (i != 0 && i != qResults.getEtAl()) {
                            %>
                            <option value="<%= i%>" <%= selected%>><%= i%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>

                <noscript>
                    <td>
                        <input type="submit" class="buttonGreen" name="submit_search" value="<fmt:message key="search.update" />" />
                    </td>
                </noscript>


                <%
                    if (admin_button) {
                %>
                <td>
                    <input type="submit" class="button" name="submit_export_metadata" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                </td>
                <%            }
                %>
                </tr>
            </table>

            <hr/>

            <table>
                <tr>
                    <%
                        Set<SortOption> sortOptions = SortOption.getSortOptions();
                        if (sortOptions.size() > 1) {
                    %>
                    <td>
                        <label for="sort_by"><fmt:message key="search.results.sort-by"/></label>
                    </td>
                    <td>
                        <select name="sort_by" id="sort_by" onchange="ordenar();">
                            <option value="0"><fmt:message key="search.sort-by.relevance"/></option>
                            <%
                                for (SortOption sortBy : sortOptions) {
                                    if (sortBy.isVisible()) {
                                        String selected = (sortBy.getName().equals(sortedBy) ? "selected=\"selected\"" : "");
                                        String mKey = "search.sort-by." + sortBy.getName();
                            %> <option value="<%= sortBy.getNumber()%>" <%= selected%>><fmt:message key="<%= mKey%>"/></option><%
                                    }
                                }
                            %>
                        </select>
                    </td>
                    <%
                        }
                    %>

                    <td>
                        <label for="ordem"><fmt:message key="search.results.order"/></label>
                    </td>
                    <td>
                        <select name="order" id="ordem" onchange="ordenar();">
                            <option value="ASC" <%= ascSelected%>><fmt:message key="search.order.asc" /></option>
                            <option value="DESC" <%= descSelected%>><fmt:message key="search.order.desc" /></option>
                        </select>
                    </td>
                </tr>
            </table>
        </form>

    </div>

    <%
    if (qResults.getErrorMsg() != null) {
            String qError = "jsp.search.error." + qResults.getErrorMsg();
    %>

    <p align="center" class="submitFormWarn"><fmt:message key="<%= qError%>"/></p>

    <%
    } else if (qResults.getHitCount() == 0) {
    %>

    <div class="painel">
        <h2>
        <fmt:message key="jsp.search.general.noresults"/>
        </h2>
    </div>

    <%
    } else { // Tudo OK. Exibe os resultados
    %>

    <%-- Inclui a paginação em cima de todos os resultados --%>
    <jsp:include page="/search/componente-paginacao.jsp">
        <jsp:param name="searchScope" value="<%= searchScope%>" />
        <jsp:param name="queryOriginal" value="<%= queryOriginal%>" />
        <jsp:param name="order" value="<%= order%>" />
        <jsp:param name="rpp" value="<%= rpp%>" />
        <jsp:param name="etAl" value="<%= etAl%>" />

        <jsp:param name="pageTotal" value="<%= pageTotal%>" />
        <jsp:param name="pageCurrent" value="<%= pageCurrent%>" />
        <jsp:param name="pageLast" value="<%= pageLast%>" />
        <jsp:param name="pageFirst" value="<%= pageFirst%>" />

        <jsp:param name="so" value="<%= so%>" />

        <jsp:param name="qResults" value="<%= qResults%>" />
    </jsp:include>

    <%-- Comunidades encontradas --%>
    <%
        if (communities.length > 0) {
            request.setAttribute("communities", communities);
    %>
    <%--<dspace:communitylist  communities="<%= communities%>" />--%>
    <jsp:include page="/search/componente-listar-comunidades.jsp" />
    <%
        }
    %>

    <%-- Coleções encontradas --%>
    <%
        if (collections.length > 0) {
            request.setAttribute("collections", collections);
    %>
    <jsp:include page="/search/componente-listar-colecoes.jsp" />
    <%
        }
    %>

    <%-- Itens encontrados --%>
    <%
        if (items.length > 0) {
    %>
    <dspace:itemlist items="<%= items%>" sortOption="<%= so%>" authorLimit="1" />
    <%
        }
    %>

    <%-- Inclui a paginação em baixo de todos os resultados --%>
    <jsp:include page="/search/componente-paginacao.jsp">
        <jsp:param name="searchScope" value="<%= searchScope%>" />
        <jsp:param name="queryOriginal" value="<%= queryOriginal%>" />
        <jsp:param name="order" value="<%= order%>" />
        <jsp:param name="rpp" value="<%= rpp%>" />
        <jsp:param name="etAl" value="<%= etAl%>" />

        <jsp:param name="pageTotal" value="<%= pageTotal%>" />
        <jsp:param name="pageCurrent" value="<%= pageCurrent%>" />
        <jsp:param name="pageLast" value="<%= pageLast%>" />
        <jsp:param name="pageFirst" value="<%= pageFirst%>" />

        <jsp:param name="so" value="<%= so%>" />

        <jsp:param name="qResults" value="<%= qResults%>" />
    </jsp:include>

    <%
        }
    %>

</dspace:layout>