<%--
  - single.jsp
  -
  - Version: $Revision: 4365 $
  -
  - Date: $Date: 2009-10-05 23:52:42 +0000 (Mon, 05 Oct 2009) $
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
    Exibe as listagens de AUTORES ou ASSUNTO, ou qualquer outra coisa que não precise ser listada com muitos detalhes.
    Como essa é uma listagem simples, a classe se chama single.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    //First, get the browse info object
    BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
    BrowseIndex bix = bi.getBrowseIndex();

    //values used by the header
    String scope = "";
    String type = "";

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

    //FIXME: so this can probably be placed into the Messages.properties file at some point
    // String header = "Browsing " + scope + " by " + type;

    // get the values together for reporting on the browse values
    // String range = "Showing results " + bi.getStart() + " to " + bi.getFinish() + " of " + bi.getTotal();

    // prepare the next and previous links
    String linkBase = request.getContextPath() + "/";
    if (collection != null) {
        linkBase = linkBase + "handle/" + collection.getHandle() + "/";
    }
    if (community != null) {
        linkBase = linkBase + "handle/" + community.getHandle() + "/";
    }

    String direction = (bi.isAscending() ? "ASC" : "DESC");
    String sharedLink = linkBase + "browse?type=" + URLEncoder.encode(bix.getName())
            + "&amp;order=" + URLEncoder.encode(direction)
            + "&amp;rpp=" + URLEncoder.encode(Integer.toString(bi.getResultsPerPage()));

    // prepare the next and previous links
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
    formaction = formaction + "browse";

    String ascSelected = (bi.isAscending() ? "selected=\"selected\"" : "");
    String descSelected = (bi.isAscending() ? "" : "selected=\"selected\"");
    int rpp = bi.getResultsPerPage();

//	 the message key for the type
    String typeKey = "browse.type.metadata." + bix.getName();

    String letraAtual = request.getParameter("starts_with");
    if (letraAtual == null) {
        letraAtual = "";
    }
%>

<dspace:layout titlekey="browse.page-title">

    <%-- Estilos de paginação --%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/browse-single-full.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css" />
    
    <%-- Build the header (careful use of spacing) --%>
    <h1>
        <fmt:message key="browse.single.header">
            <fmt:param value="<%= scope%>"/>
        </fmt:message>
        <fmt:message key="<%= typeKey%>"/>
    </h1>

    <%-- Include the main navigation for all the browse pages --%>
    <%-- This first part is where we render the standard bits required by both possibly navigations --%>
    <div class="browseBar" id="browse_navigation">
        <div>
            <form method="get" action="<%= formaction%>">
                <input type="hidden" name="type" value="<%= bix.getName()%>"/>
                <input type="hidden" name="order" value="<%= direction%>"/>
                <input type="hidden" name="rpp" value="<%= rpp%>"/>

                <%-- If we are browsing by a date, or sorting by a date, render the date selection header --%>
                <%
                    if (bix.isDate()) {
                %>
                <span class="browseBarLabel"><fmt:message key="browse.nav.date.jump"/> </span>
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

                <input type="submit" value="<fmt:message key="browse.nav.go"/>" />

                <span class="browseBarLabel"><fmt:message key="browse.nav.type-year"/></span>
                <input type="text" name="starts_with" size="4" maxlength="4"/>

                <%
                } // If we are not browsing by a date, render the string selection header //
                else {
                %>
                <%-- Estilos de paginação --%>
                <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/paginacao.css" type="text/css" />

                <span class="browseBarLabel"><fmt:message key="browse.nav.jump"/></span>

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
        </div>

        <hr/>

        <script type="text/javascript">
            //Quando algum componente de ordenação for alterado, submete os dados
            //para que o usuário não precise clicar em "Atualizar".
            function submeter(){
                document.getElementById('ordenacao').submit();
            }

        </script>


        <%



         String tipo = request.getParameter("tipo");

         String orien_coorien="";
         String orien="";
         String coorien="";

         String selecionado = request.getParameter("type").toString();

         if(selecionado != null){  %>

             <%--Deixa selecionado a ultima opção escolhida --%>
             <%
             orien_coorien = (selecionado.equalsIgnoreCase("orientadorEcoorientador") ? "selected=\"selected\"" : "");
             orien = (selecionado.equalsIgnoreCase("orientador") ? "selected=\"selected\"" : "");
             coorien = (selecionado.equalsIgnoreCase("coorientador") ? "selected=\"selected\"" : "");
         }

        if(tipo != null  ){


        if(tipo.equalsIgnoreCase("orientador") && (!selecionado.equalsIgnoreCase(tipo)) ){ %>
        <script type="text/javascript">
            document.location.href="<%= request.getContextPath() %>/browse?type=orientador";
        </script>

        <% }


        if(tipo.equalsIgnoreCase("coorientador") && (!selecionado.equalsIgnoreCase(tipo))){ %>
        <script type="text/javascript">
            document.location.href="<%= request.getContextPath() %>/browse?type=coorientador";
        </script>

        <%  }
         if(tipo.equalsIgnoreCase("orientadorEcoorientador")&& (!selecionado.equalsIgnoreCase(tipo))  ){ %>
        <script type="text/javascript">
            document.location.href="<%= request.getContextPath() %>/browse?type=orientadorEcoorientador";
        </script>
         <%}
           }   %>


           <%--Formulário para alterar a ordenação dos resultados. --%>
        <div>
            <form method="get" action="<%= formaction%>" id="ordenacao">
                <input type="hidden" name="type" value="<%= bix.getName()%>"/>

                <table class="tabelaNavegacao">
                    <tr>

                <%if(bix.getName().equalsIgnoreCase("orientadorEcoorientador") ||
                 bix.getName().equalsIgnoreCase("orientador") ||
                 bix.getName().equalsIgnoreCase("coorientador")){ %>
                 <td class="sel">
                 <select name="tipo" onchange="submeter();" id="t" >
                    <option value="orientadorEcoorientador" <%=orien_coorien%> >Orientador/Corientador</option>
                    <option value="orientador" <%=orien%> >Orientador</option>
                    <option value="coorientador"<%=coorien%> >Co-orientador</option>
                </select>
                 </td>
                    <%} %>

                    <td>
                <fmt:message key="browse.single.order"/>
                    </td>
                    <td class="sel">
                <select name="order" onchange="submeter();">
                    <option value="ASC" <%= ascSelected%>><fmt:message key="browse.order.asc" /></option>
                    <option value="DESC" <%= descSelected%>><fmt:message key="browse.order.desc" /></option>
                </select>
                    </td>
                    <td>
                <fmt:message key="browse.single.rpp"/>
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

                <%-- Exibe o botão de atualizar apenas se o Javascript não estiver ativado.--%>
                <noscript>
                <td class="sel">
                <input type="submit" name="submit_browse" class="button" value="<fmt:message key="jsp.general.update"/>"/>
                </td>
                </noscript>
                </tr>
                </table>
            </form>
        </div>
    </div>
    <%-- End of Navigation Headers --%>

    <%-- give us the top report on what we are looking at --%>
    <div align="center" class="browse_range">
        <fmt:message key="browse.single.range">
            <fmt:param value="<%= Integer.toString(bi.getStart())%>"/>
            <fmt:param value="<%= Integer.toString(bi.getFinish())%>"/>
            <fmt:param value="<%= Integer.toString(bi.getTotal())%>"/>
        </fmt:message>
    </div>

    <%--  do the top previous and next page links«» --%>
    <div align="center">
        <%
            if (bi.hasPrevPage()) {
        %>
        <a class="navegacao" href="<%= prev%>"><fmt:message key="browse.single.prev"/></a>
        <%
            }
        %>

        <%
            if (bi.hasNextPage()) {
        %>
        <a class="navegacao" href="<%= next%>"><fmt:message key="browse.single.next"/></a>
        <%
            }
        %>
    </div>


    <%-- THE RESULTS --%>
    <table class="tabela tabelaSingle">
        <tr class="tituloTabela">
            <td><fmt:message key="<%= typeKey%>"/></td>
        </tr>
        <%
            String[][] results = bi.getStringResults();
            for (int i = 0; i < results.length; i++) {
                if(i % 2 == 0){
        %>
        <tr class="stripe">
            <%
                       } else{%>
        <tr>
            <%
                       }
                %>
            <td>
                <a href="<%= sharedLink%><% if (results[i][1] != null) {%>&amp;authority=<%= URLEncoder.encode(results[i][1], "UTF-8")%>" class="authority <%= bix.getName()%>"><%= Utils.addEntities(results[i][0])%></a><% } else {%>&amp;value=<%= URLEncoder.encode(results[i][0], "UTF-8")%>"><%= Utils.addEntities(results[i][0])%></a> <% }%>
            </td>

        </tr>
        <%
            }
        %>
    </table>

    <br />
    <%-- give us the bottom report on what we are looking at --%>
    <div align="center" class="browse_range">
        <fmt:message key="browse.single.range">
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
        <a class="navegacao" href="<%= prev%>"><fmt:message key="browse.single.prev"/></a>
        <%
            }
        %>

        <%
            if (bi.hasNextPage()) {
        %>
        <a class="navegacao" href="<%= next%>"><fmt:message key="browse.single.next"/></a>
        <%
            }
        %>
    </div>

    <%-- dump the results for debug (uncomment to enable) --%>
    <%--
    <!-- <%= bi.toString() %> -->
    --%>

</dspace:layout>
