<%--
  - full.jsp
  -
  - Version: $Revision: 4639 $
  -
  - Date: $Date: 2009-12-20 08:20:35 +0000 (Sun, 20 Dec 2009) $
  -
  - Copyright (c) 2006, Hewlett-Packard Company and Massachusetts
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
  - Display the results of browsing a full hit list
    Exibe as listagens de DATA DE PUBLICAÇÃO ou TÍTULO, ou qualquer outra coisa que precise ser listada com muitos detalhes.
    Como essa é uma listagem simples, a classe se chama single.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    String urlFragment = "browse";
    String layoutNavbar = "default";
    boolean withdrawn = false;
    if (request.getAttribute("browseWithdrawn") != null) {
        layoutNavbar = "admin";
        urlFragment = "dspace-admin/withdrawn";
        withdrawn = true;
    }

    // First, get the browse info object
    BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
    BrowseIndex bix = bi.getBrowseIndex();
    SortOption so = bi.getSortOption();

    // values used by the header
    String scope = "";
    String type = "";
    String value = "";

    Community community = null;
    Collection collection = null;
    if (bi.inCommunity()) {
        community = (Community) bi.getBrowseContainer();
    }
    if (bi.inCollection()) {
        collection = (Collection) bi.getBrowseContainer();
    }

    if (community != null) {
        scope = "\"" + community.getMetadata("name") + "\"";
    }
    if (collection != null) {
        scope = "\"" + collection.getMetadata("name") + "\"";
    }

    type = bix.getName();

    // next and previous links are of the form:
    // [handle/<prefix>/<suffix>/]browse?type=<type>&sort_by=<sort_by>&order=<order>[&value=<value>][&rpp=<rpp>][&[focus=<focus>|vfocus=<vfocus>]

    // prepare the next and previous links
    String linkBase = request.getContextPath() + "/";
    if (collection != null) {
        linkBase = linkBase + "handle/" + collection.getHandle() + "/";
    }
    if (community != null) {
        linkBase = linkBase + "handle/" + community.getHandle() + "/";
    }

    String direction = (bi.isAscending() ? "ASC" : "DESC");

    String argument = null;
    if (bi.hasAuthority()) {
        value = bi.getAuthority();
        argument = "authority";
    } else if (bi.hasValue()) {
        value = bi.getValue();
        argument = "value";
    }

    String valueString = "";
    if (value != null) {
        valueString = "&amp;" + argument + "=" + URLEncoder.encode(value);
    }

    String sharedLink = linkBase + urlFragment + "?";

    if (bix.getName() != null) {
        sharedLink += "type=" + URLEncoder.encode(bix.getName());
    }

    sharedLink += "&amp;sort_by=" + URLEncoder.encode(Integer.toString(so.getNumber()))
            + "&amp;order=" + URLEncoder.encode(direction)
            + "&amp;rpp=" + URLEncoder.encode(Integer.toString(bi.getResultsPerPage()))
            + "&amp;etal=" + URLEncoder.encode(Integer.toString(bi.getEtAl()))
            + valueString;

    String next = sharedLink;
    String prev = sharedLink;

    if (bi.hasNextPage()) {
        next = next + "&amp;offset=" + bi.getNextOffset();
    }

    if (bi.hasPrevPage()) {
        prev = prev + "&amp;offset=" + bi.getPrevOffset();
    }

    // prepare a url for use by form actions
    String formaction = request.getContextPath() + "/";
    if (collection != null) {
        formaction = formaction + "handle/" + collection.getHandle() + "/";
    }
    if (community != null) {
        formaction = formaction + "handle/" + community.getHandle() + "/";
    }
    formaction = formaction + urlFragment;

    // prepare the known information about sorting, ordering and results per page
    String sortedBy = so.getName();
    String ascSelected = (bi.isAscending() ? "selected=\"selected\"" : "");
    String descSelected = (bi.isAscending() ? "" : "selected=\"selected\"");
    int rpp = bi.getResultsPerPage();

    // the message key for the type
    String typeKey;

    if (bix.isMetadataIndex()) {
        typeKey = "browse.type.metadata." + bix.getName();
    } else if (bi.getSortOption() != null) {
        typeKey = "browse.type.item." + bi.getSortOption().getName();
    } else {
        typeKey = "browse.type.item." + bix.getSortOption().getName();
    }

    // Admin user or not
    Boolean admin_b = (Boolean) request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

    String letraAtual = request.getParameter("starts_with");
    if (letraAtual == null) {
        letraAtual = "";
    }
%>

<%-- OK, so here we start to develop the various components we will use in the UI --%>

<%@page import="java.util.Set"%>
<dspace:layout titlekey="browse.page-title" navbar="<%=layoutNavbar%>">

    <%-- Estilos de paginação --%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/paginacao.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/browse-single-full.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css" />
    
    <h1>
        <fmt:message key="browse.full.header">
            <fmt:param value="<%= scope%>"/>
        </fmt:message>
        <fmt:message key="<%= typeKey%>"/>
        <%= value%>
    </h1>

    <%-- Include the main navigation for all the browse pages --%>
    <%-- This first part is where we render the standard bits required by both possibly navigations --%>
    <div id="browse_navigation" class="browseBar">
        <form method="get" action="<%= formaction%>" id="localizacao">

            <input type="hidden" name="type" value="<%= bix.getName()%>"/>
            <input type="hidden" name="sort_by" value="<%= so.getNumber()%>"/>
            <input type="hidden" name="order" value="<%= direction%>"/>
            <input type="hidden" name="rpp" value="<%= rpp%>"/>
            <input type="hidden" name="etal" value="<%= bi.getEtAl()%>" />

            <%
                if (bi.hasAuthority()) {
            %>
            <input type="hidden" name="authority" value="<%=bi.getAuthority()%>"/><%
            } else if (bi.hasValue()) {
            %>
            <input type="hidden" name="value" value="<%= bi.getValue()%>"/><%
                }
                //ORDENAÇÃO POR DATA DE PUBLICAÇÃO.
                if (so.isDate() || (bix.isDate() && so.isDefault())) {
            %>

            <table class="tabelaNavegacao">
                <tr>
                    <td class="dir">
                        <fmt:message key="browse.nav.date.jump"/>
                    </td>
                    <td class="esq">
                        <select name="year">
                            <option selected="selected" value="-1"><fmt:message key="browse.nav.year"/></option>
                            <%
                                int thisYear = DCDate.getCurrent().getYear();
                                for (int i = thisYear; i >= 1990; i--) {
                            %>
                            <option><%= i%></option>
                            <%
                                }
                            %>
                            <option>1985</option>
                            <option>1980</option>
                            <option>1975</option>
                            <option>1970</option>
                            <option>1960</option>
                            <option>1950</option>
                        </select>

                        <select name="month">
                            <option selected="selected" value="-1"><fmt:message key="browse.nav.month"/></option>
                            <%
                                for (int i = 1; i <= 12; i++) {
                            %>
                            <option value="<%= i%>"><%= DCDate.getMonthName(i, UIUtil.getSessionLocale(request))%></option>
                            <%
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="dir">
                        <fmt:message key="browse.nav.type-year"/>
                    </td>
                    <td class="esq">
                        <input type="text" name="starts_with" size="7" maxlength="4"/>
                        <input class="button" type="submit" size="35" value="<fmt:message key="browse.nav.go"/>" />
                    </td>
                </tr>
            </table>
            <%
            } //ORDENAÇÃO POR TÍTULO.
            else {
            %>

            <span class="browseBarLabel" ><fmt:message key="browse.nav.jump"/></span>

            <ul class="paginacao">
                <%
                    if (letraAtual.equals("0")) {
                %>
                <li><a class="atual" href="<%= sharedLink%>&amp;starts_with=0">0-9</a></li>
                    <%
                    } else {
                    %>
                <li><a href="<%= sharedLink%>&amp;starts_with=0">0-9</a></li>
                    <%
                        }
                        for (char c = 'A'; c <= 'Z'; c++) {
                            if (letraAtual.equals(c + "")) {

                    %>
                <li><a class="atual" href="<%= sharedLink%>&amp;starts_with=<%= c%>"><%= c%></a></li>
                    <%
                    } else {
                    %>
                <li><a href="<%= sharedLink%>&amp;starts_with=<%= c%>"><%= c%></a></li>
                    <%
                            }
                        }
                    %>
            </ul>

            <span class="browseBarLabel"><fmt:message key="browse.nav.enter"/>&nbsp;</span>
            <input type="text" name="starts_with"/>&nbsp;<input class="button" type="submit" value="<fmt:message key="browse.nav.go"/>" />

            <%
                }
            %>
        </form>

        <hr>

        <script type="text/javascript">
            //Quando algum componente de ordenação for alterado, submete os dados
            //para que o usuário não precise clicar em "Atualizar".
            function submeter() {
                document.getElementById('ordenacao').submit();
            }
        </script>

        <%-- ORDENAÇÃO --%>
        <form method="get" action="<%= formaction%>" id="ordenacao">

            <input type="hidden" name="type" value="<%= bix.getName()%>"/>
            <%
                if (bi.hasAuthority()) {
            %>
            <input type="hidden" name="authority" value="<%=bi.getAuthority()%>"/>
            <%
            } else if (bi.hasValue()) {
            %>
            <input type="hidden" name="value" value="<%= bi.getValue()%>"/><%
                }
            %>

            <table class="tabelaNavegacao">
                <tr>
                    <td>
                        <fmt:message key="browse.full.order"/>
                    </td>
                    <td class="sel">
                        <select name="order" onchange="submeter();">
                            <option value="ASC" <%= ascSelected%>><fmt:message key="browse.order.asc" /></option>
                            <option value="DESC" <%= descSelected%>><fmt:message key="browse.order.desc" /></option>
                        </select>
                    </td>
                    <td>
                        <fmt:message key="browse.full.rpp"/>
                    </td>
                    <td class="sel">
                        <select name="rpp" onchange="submeter();">
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
                        <fmt:message key="browse.full.etal" />
                    </td>
                    <td class="sel">
                        <select name="etal" onchange="submeter();">
                            <%
                                String unlimitedSelect = "";
                                if (bi.getEtAl() == -1) {
                                    unlimitedSelect = "selected=\"selected\"";
                                }
                            %>
                            <option value="0" <%= unlimitedSelect%>><fmt:message key="browse.full.etal.unlimited"/></option>
                            <%
                                int cfgd = ConfigurationManager.getIntProperty("webui.browse.author-limit");
                                boolean insertedCurrent = false;
                                boolean insertedDefault = false;
                                for (int i = 0; i <= 50; i += 5) {
                                    // for the first one, we want 1 author, not 0
                                    if (i == 0) {
                                        String sel = (i + 1 == bi.getEtAl() ? "selected=\"selected\"" : "");
                            %><option value="1" <%= sel%>>1</option><%
                                }

                                // if the current i is greated than that configured by the user,
                                // insert the one specified in the right place in the list
                                if (i > bi.getEtAl() && !insertedCurrent && bi.getEtAl() != -1 && bi.getEtAl() != 0 && bi.getEtAl() != 1) {
                            %><option value="<%= bi.getEtAl()%>" selected="selected"><%= bi.getEtAl()%></option><%
                                    insertedCurrent = true;
                                }

                                // if the current i is greated than that configured by the administrator (dspace.cfg)
                                // insert the one specified in the right place in the list
                                if (i > cfgd && !insertedDefault && cfgd != -1 && cfgd != 0 && cfgd != 1 && bi.getEtAl() != cfgd) {
                            %><option value="<%= cfgd%>"><%= cfgd%></option><%
                                    insertedDefault = true;
                                }

                                // determine if the current not-special case is selected
                                String selected = (i == bi.getEtAl() ? "selected=\"selected\"" : "");

                                // do this for all other cases than the first and the current
                                if (i != 0 && i != bi.getEtAl()) {
                                %>
                            <option value="<%= i%>" <%= selected%>><%= i%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>

                    <%-- Exibe o botão de atualizar apenas se o Javascript não estiver ativado.--%>
                <noscript>
                <td class="sel">
                    <input type="submit" class="button" name="submit_browse" value="<fmt:message key="jsp.general.update"/>"/>
                </td>
                </noscript>

                </tr>
            </table>
            <%
                if (admin_button && !withdrawn) {
            %>
            <input type="submit" class="button" name="submit_export_metadata" value="<fmt:message key="jsp.general.metadataexport.button"/>" /><%            }
            %>
        </form>
    </div>
    <%-- End of Navigation Headers --%>

    <%-- give us the top report on what we are looking at --%>
    <div align="center" class="browse_range">
        <fmt:message key="browse.full.range">
            <fmt:param value="<%= Integer.toString(bi.getStart())%>"/>
            <fmt:param value="<%= Integer.toString(bi.getFinish())%>"/>
            <fmt:param value="<%= Integer.toString(bi.getTotal())%>"/>
        </fmt:message>
    </div>

    <%--  do the top previous and next page links --%>
    <div align="center">
        <%
            if (bi.hasPrevPage()) {
        %>
        <a class="navegacao" href="<%= prev%>"><fmt:message key="browse.full.prev"/></a>
        <%
            }
        %>

        <%
            if (bi.hasNextPage()) {
        %>
        <a class="navegacao" href="<%= next%>"><fmt:message key="browse.full.next"/></a>
        <%
            }
        %>
    </div>

    <br />

    <%-- output the results using the browselist tag --%>
    <%
        if (bix.isMetadataIndex()) {
    %>
    <dspace:browselist browseInfo="<%= bi%>" emphcolumn="<%= bix.getMetadata()%>" />
    <%
    } else if (request.getAttribute("browseWithdrawn") != null) {
    %>
    <dspace:browselist browseInfo="<%= bi%>" emphcolumn="<%= bix.getSortOption().getMetadata()%>" linkToEdit="true" disableCrossLinks="true" />
    <%
    } else {
    %>
    <dspace:browselist browseInfo="<%= bi%>" emphcolumn="<%= bix.getSortOption().getMetadata()%>" />
    <%
        }
    %>

    <%-- give us the bottom report on what we are looking at --%>
    <div align="center" class="browse_range">
        <fmt:message key="browse.full.range">
            <fmt:param value="<%= Integer.toString(bi.getStart())%>"/>
            <fmt:param value="<%= Integer.toString(bi.getFinish())%>"/>
            <fmt:param value="<%= Integer.toString(bi.getTotal())%>"/>
        </fmt:message>
    </div>

    <%--  do the bottom previous and next page links --%>
    <div align="center">
        <%
            if (bi.hasPrevPage()) {
        %>
        <a class="navegacao" href="<%= prev%>"><fmt:message key="browse.full.prev"/></a>&nbsp;
        <%
            }
        %>

        <%
            if (bi.hasNextPage()) {
        %>
        &nbsp;<a class="navegacao" href="<%= next%>"><fmt:message key="browse.full.next"/></a>
        <%
            }
        %>
    </div>

    <%-- dump the results for debug (uncomment to enable) --%>
    <%--
    <!-- <%= bi.toString() %> -->
    --%>

</dspace:layout>