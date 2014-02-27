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

<%@page import="org.dspace.utils.DSpace"%>
<%@page import="org.dspace.administer.CommunityFiliator"%>
<%@page import="org.dspace.content.Community"%>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="java.util.List"%>
<%@page import="org.dspace.app.webui.components.StatisticsBean"%>
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

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>

<dspace:layout titlekey="jsp.statistics.title">

    <%
        Boolean isItem = (Boolean) request.getAttribute("isItem");

        StatisticsBean mv = (StatisticsBean) request.getAttribute("statsMonthlyVisits");
        StatisticsBean cv = (StatisticsBean) request.getAttribute("statsCountryVisits");
        StatisticsBean cidv = (StatisticsBean) request.getAttribute("statsCityVisits");

        String[][] acessosPaises = cv.getMatrix();
        List<String> nomesPaises = cv.getColLabels();
        
        int qtdePaises = 0;
        if(nomesPaises != null){
            qtdePaises = nomesPaises.size();
        }
        boolean exibirPaises = false;
        if (qtdePaises > 0) exibirPaises = true;

        String[][] acessosCidades = cidv.getMatrix();
        List<String> nomesCidades = cidv.getColLabels();
        int qtdeCidades = 0;
        if(nomesCidades != null){
            qtdeCidades = nomesCidades.size();
        }
        boolean exibirCidades = false;
        if (qtdeCidades > 0) exibirCidades = true;
        
        List<String> periodo = mv.getColLabels();
        int numMeses = 0;
        if(periodo != null){
            numMeses = periodo.size();        
        }
        String[][] acessosMeses = mv.getMatrix();

        String handle = request.getParameter("handle");
    %>

    <!--[if IE]><script language="javascript" type="text/javascript" src="path/to/excanvas.js"></script><![endif]-->
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/base64.js"></script>
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/canvas2image.js"></script>
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/canvastext.js"></script>
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/flotr.js"></script>

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/display-statistics.css" type="text/css"/>

    <h1 align="center"><fmt:message key="jsp.statistics.title"/></h1>
    <div id="texto_dysplayEstatistics"> 
    <%if(isItem){%>
       Apresentam a quantidade de acessos por Item, ao(s) arquivo(s) do Item, acessos 
           realizados nos últimos meses, por país e por cidade.
    <% } 
      else{%>    
           Apresentam a quantidade de acessos por comunidade, subcomunidade ou coleção,
      realizados nos últimos meses, por país e por cidade.
         <% }   
                  
         %>
    </div>
    <table class="tabela">
        <tr class="tituloTabela">
            <td colspan="6"><fmt:message key="jsp.statistics.heading.visits"/></td>
        </tr>

        <tr>
            <th><fmt:message key="jsp.statistics.heading.title"/></th>
            <th><fmt:message key="jsp.statistics.heading.views"/></th>
        </tr>

        <c:forEach items="${statsVisits.matrix}" var="row" varStatus="counter">
            <c:forEach items="${row}" var="cell" varStatus="rowcounter">
                <c:choose>
                    <c:when test="${rowcounter.index % 2 == 0}">
                        <c:set var="rowClass" value="stripe" />
                    </c:when>
                </c:choose>

                <tr class="${rowClass}">
                    <td>
                        <a href="<%= request.getContextPath()%>/handle/<%= handle%>">
                            <c:out value="${statsVisits.colLabels[counter.index]}"/>
                        </a>
                    </td>
                    <td id="valores">
                        <c:out value="${cell}"/>
                    </td>

                </c:forEach>
            </tr>
        </c:forEach>
    </table>

    <% if (isItem) {%>

    <table class="tabela">
        <tr class="tituloTabela">
            <td colspan="6"><fmt:message key="jsp.statistics.heading.filedownloads"/></td>
        </tr>

        <tr>
            <th><fmt:message key="jsp.statistics.heading.name"/></th>
            <th><fmt:message key="jsp.statistics.heading.views"/></th>
        </tr>

        <c:set var="msg" value="Nenhum arquivo baixado"/>
        <c:choose>
            <c:when test="${statsFileDownloads.colLabels[0] == null }">
                <c:set var="rowClass" value="evenRowOddCol"/>
                <tr class="${rowClass}">
                    <td align="center">
                        <c:out value="${msg}"/>
                    </td>
                    <td id="valores">
                        —
                    </td>
                </tr>

            </c:when>

            <c:otherwise>

                <c:forEach items="${statsFileDownloads.matrix}" var="row" varStatus="counter">

                    <c:forEach items="${row}" var="cell" varStatus="rowcounter" >

                        <c:choose>
                            <c:when test="${rowcounter.index % 2 == 0}">
                                <c:set var="rowClass" value="stripe"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rowClass" value=""/>
                            </c:otherwise>
                        </c:choose>
                        <tr class="${rowClass}">

                            <td>
                                <c:out value="${statsFileDownloads.colLabels[rowcounter.index]}"/>
                            <td id="valores">
                                <c:out value="${cell}"/>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>

            </c:otherwise>
        </c:choose>
    </table>
    <% }%>

    <br /><br /><br />

    <%--
<table class="tabela">
    <tr class="tituloTabela">
        <td colspan="8"><fmt:message key="jsp.statistics.heading.monthlyvisits"/></td>
    </tr>
    <tr>
        <th>Título</th>
            <c:forEach items="${statsMonthlyVisits.colLabels}" var="headerlabel" varStatus="counter">
            <th>
                <c:out value="${headerlabel}"/>
            </th>
        </c:forEach>
    </tr>
    <c:forEach items="${statsMonthlyVisits.matrix}" var="row" varStatus="counter">
        <c:choose>
            <c:when test="${counter.index % 2 == 0}">
                <c:set var="rowClass" value="stripe"/>
            </c:when>
            <c:otherwise>
                <c:set var="rowClass" value=""/>
            </c:otherwise>
        </c:choose>
        <tr class="${rowClass}">
            <td>
                <c:out value="${statsMonthlyVisits.rowLabels[counter.index]}"/>
            </td>
            <c:forEach items="${row}" var="cell">
                <td id="valores">
                    <c:out value="${cell}"/>
                </td>
            </c:forEach>
        </tr>
    </c:forEach>
</table>
    --%>

    <div id="visitasMes" class="grafico"></div>
    <script type="text/javascript">
        document.observe('dom:loaded', function() {
            var month = new Array();
        <%
            for (int i = 0; i < numMeses; i++) {
        %>
            month[<%= i%>] = "<%= periodo.get(i).substring(0, periodo.get(i).indexOf(" "))%>";
        <%
            }

            String arr = "[";
            for (int i = 0; i < numMeses; i++) {
                arr += "[" + i + "," + acessosMeses[0][i] + "]";
                if (i != numMeses - 1) {
                    arr += ",";
                }
            }
            arr += "]";
        %>
            var d1 = <%= arr%>;

            /**
             * Draw the graph in the first container.
             */
            Flotr.draw(
                    $('visitasMes'),
                    [
                        {data: d1, lines: {show: true, fill: true}, points: {show: true}}
                    ],
                    {
                        title: '<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.statistics.heading.monthlyvisits")%>',
                        xaxis: {
                            noTicks: 7, // Display 7 ticks.
                            min: 0, // => part of the series is not displayed.
                            tickFormatter: function(n) {
                                return month[Math.floor(n)];
                            }
                        },
                        yaxis: {
                            min: 0,
                            tickFormatter: function(n) {
                                return parseInt(n) + "";
                            }
                        },
                        mouse: {
                            track: true,
                            lineColor: '#2E6AB1',
                            relative: true,
                            position: 'ne',
                            sensibility: 10, // => The smaller this value, the more precise you've to point
                            trackDecimals: 2,
                            trackFormatter: function(obj) {
                                return month[Math.floor(obj.x)] + ' - ' + Math.floor(obj.y);
                            }
                        },
                        spreadsheet: {show: true}
                    }
            );
        });
    </script>

    <%--
        <table class="tabela">
            <tr class="tituloTabela">
                <td colspan="6"><fmt:message key="jsp.statistics.heading.countryvisits"/></td>
            </tr>
            <tr>
                <th>País</th>
                <th><fmt:message key="jsp.statistics.heading.views"/></th>
            </tr>

        <c:set var="msg2" value="Nenhum acesso"/>

        <c:choose>
            <c:when test="${statsCountryVisits.colLabels[0] == null }">
                <c:set var="rowClass" value="evenRowOddCol"/>
                <tr class="${rowClass}">
                    <td align="center">
                        <c:out value="${msg2}"/>
                    </td>
                    <td id="valores">
                        —
                    </td>
                </tr>
            </c:when>

            <c:otherwise>
                <c:forEach items="${statsCountryVisits.matrix}" var="row" varStatus="counter">
                    <c:forEach items="${row}" var="cell" varStatus="rowcounter">
                        <c:choose>
                            <c:when test="${rowcounter.index % 2 == 0}">
                                <c:set var="rowClass" value="stripe"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rowClass" value=""/>
                            </c:otherwise>
                        </c:choose>
                        <tr class="${rowClass}">
                            <td>
                                <c:out value="${statsCountryVisits.colLabels[rowcounter.index]}"/>
                            <td id="valores">
                                <c:out value="${cell}"/>
                        </tr>

                    </c:forEach>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>
    --%>
    <div id="visitasPais" class="grafico"></div>
    <script type="text/javascript">
        document.observe('dom:loaded', function() {
        <%
            String valores = "";
            if (exibirPaises){
                for (int i = 0; i < nomesPaises.size() - 1; i++) {
                    valores += "'" + nomesPaises.get(i) + "', ";
                }
                valores += "'" + nomesPaises.get(nomesPaises.size() - 1) + "'";
            }
        %>

            var paises = [<%= valores%>];

        <%
            String series = "";
            if (exibirPaises){
                for (int i = 0; i < qtdePaises - 1; i++) {
                    if (i == 0) {
                        int margem = Integer.parseInt(acessosPaises[0][i]) + 5;
                        series += "[" + i + "," + acessosPaises[0][i] + "," + margem + "],";
                    } else {
                        series += "[" + i + "," + acessosPaises[0][i] + "],";
                    }
                }
                series += "[" + (qtdePaises - 1) + "," + acessosPaises[0][qtdePaises - 1] + "]";
            }
        %>

            var series = [{data: [<%= series%>]}];

            var options = {
                title: "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.statistics.heading.countryvisits")%>",
                "defaultType": "bars",
                xaxis: {
                    noTicks: <%= qtdePaises%>,
                    tickFormatter: function(val) {
                        return paises[parseInt(val, 10)] + '';
                    }
                },
                bars: {show: true, centered: true},
                markers: {show: true},
                mouse: {
                    track: true,
                    lineColor: "#2E6AB1",
                    position: "ne",
                    trackFormatter: function(obj) {
                        return paises[parseInt(obj.x, 10)] + ' - ' + parseInt(obj.y, 10);
                    }
                },
                grid: {verticalLines: false},
                spreadsheet: {show: true}
            };

            Flotr.draw($('visitasPais'), series, options);
        });
    </script>

    <%--
    <table class="tabela">
        <tr class="tituloTabela">
            <td colspan="6"><fmt:message key="jsp.statistics.heading.cityvisits"/></td>
        </tr>

        <tr>
            <th align="center" width="76%" >Cidade</th>
            <th><fmt:message key="jsp.statistics.heading.views"/></th>
        </tr>

        <c:choose>
            <c:when test="${statsCityVisits.colLabels[0] == null }">
                <c:set var="rowClass" value="evenRowOddCol"/>
                <tr class="${rowClass}">
                    <td align="center">
                        <c:out value="${msg2}"/>
                    </td>
                    <td id="valores">
                        —
                    </td>
                </tr>
            </c:when>

            <c:otherwise>

                <c:forEach items="${statsCityVisits.matrix}" var="row" varStatus="counter">

                    <c:forEach items="${row}" var="cell" varStatus="rowcounter">
                        <c:choose>
                            <c:when test="${rowcounter.index % 2 == 0}">
                                <c:set var="rowClass" value="evenRowOddCol"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rowClass" value="oddRowOddCol"/>
                            </c:otherwise>
                        </c:choose>
                        <tr class="${rowClass}">
                            <td>
                                <c:out value="${statsCityVisits.colLabels[rowcounter.index]}"/>
                            <td id="valores">
                                <c:out value="${cell}"/>
                            </td>
                        </tr>
                    </c:forEach>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>
    --%>

    <div id="visitasCidades" class="grafico"></div>
    <script type="text/javascript">
        document.observe('dom:loaded', function() {
        <%
            String valoresCid = "";
            if (exibirCidades){
                for (int i = 0; i < qtdeCidades - 1; i++) {
                    valoresCid += "'" + nomesCidades.get(i) + "', ";
                }
                valoresCid += "'" + nomesCidades.get(nomesCidades.size() - 1) + "'";
            }
        %>

            var paises = [<%= valoresCid%>];

        <%
            String seriesCid = "";
            if (exibirCidades){
                for (int i = 0; i < qtdeCidades - 1; i++) {
                    if (i == 0) {
                        int margem = Integer.parseInt(acessosCidades[0][i]) + 5;
                        seriesCid += "[" + i + "," + acessosCidades[0][i] + "," + margem + "],";
                    } else {
                        seriesCid += "[" + i + "," + acessosCidades[0][i] + "],";
                    }
                }
                seriesCid += "[" + (qtdeCidades - 1) + "," + acessosCidades[0][qtdeCidades - 1] + "]";
            }
        %>

            var series = [{data: [<%= seriesCid%>]}];

            var options = {
                title: "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.statistics.heading.cityvisits")%>",
                "defaultType": "bars",
                xaxis: {
                    noTicks: <%= qtdeCidades%>,
                    tickFormatter: function(val) {
                        return paises[parseInt(val, 10)] + '';
                    }
                },
                bars: {show: true, centered: true},
                markers: {show: true},
                mouse: {
                    track: true,
                    lineColor: "#2E6AB1",
                    position: "ne",
                    trackFormatter: function(obj) {
                        return paises[parseInt(obj.x, 10)] + ' - ' + parseInt(obj.y, 10);
                    }
                },
                grid: {verticalLines: false},
                spreadsheet: {show: true}
            };

            Flotr.draw($('visitasCidades'), series, options);
        });
    </script>

</dspace:layout>