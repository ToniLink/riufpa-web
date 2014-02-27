<%--
    Document   : componente-paginacao
    Created on : 17/10/2012, 09:45:23
    Author     : portal
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@page import="org.dspace.search.QueryResults"%>
<%@page import="org.dspace.sort.SortOption"%>
<%@page import="java.net.URLEncoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String searchScope = request.getParameter("searchScope");
    String queryOriginal = request.getParameter("queryOriginal");
    String order = request.getParameter("order");
    String rpp = request.getParameter("rpp");
    String etAl = request.getParameter("etAl");

    int pageTotal = ((Integer) request.getAttribute("pagetotal")).intValue();
    int pageCurrent = ((Integer) request.getAttribute("pagecurrent")).intValue();
    int pageLast = ((Integer) request.getAttribute("pagelast")).intValue();
    int pageFirst = ((Integer) request.getAttribute("pagefirst")).intValue();

    SortOption so = (SortOption) request.getAttribute("so");

    QueryResults qResults = (QueryResults) request.getAttribute("queryresults");

%>

<%-- Paginação dos resultados --%>
<table style="margin: 0 auto;">
    <tr>
        <td>
            <ul class="paginacao">
                <%
                    // create the URLs accessing the previous and next search result pages
                    String prevURL = request.getContextPath()
                            + searchScope
                            + "/simple-search?query="
                            + URLEncoder.encode(queryOriginal, "UTF-8")
                            + "&amp;sort_by=" + (so != null ? so.getNumber() : 0)
                            + "&amp;order=" + order
                            + "&amp;rpp=" + rpp
                            + "&amp;etal=" + etAl
                            + "&amp;start=";

                    String nextURL = prevURL;

                    prevURL = prevURL + (pageCurrent - 2) * qResults.getPageSize();

                    nextURL = nextURL + (pageCurrent) * qResults.getPageSize();


                    if (pageFirst != pageCurrent) {
                %>
                <li><a class="anteriorProx" href="<%= prevURL%>"><fmt:message key="jsp.search.general.previous" /></a></li>
                    <%
                        };

                        for (int q = pageFirst; q <= pageLast; q++) {
                            String myLink = "<a href=\""
                                    + request.getContextPath()
                                    + searchScope
                                    + "/simple-search?query="
                                    + URLEncoder.encode(queryOriginal, "UTF-8")
                                    + "&amp;sort_by=" + (so != null ? so.getNumber() : 0)
                                    + "&amp;order=" + order
                                    + "&amp;rpp=" + rpp
                                    + "&amp;etal=" + etAl
                                    + "&amp;start=";


                            if (q == pageCurrent) {
                                myLink = "<a class=\"atual\">" + q + "</a>";
                            } else {
                                myLink = myLink
                                        + (q - 1) * qResults.getPageSize()
                                        + "\">"
                                        + q
                                        + "</a>";
                            }
                    %>

                <li><%= myLink%></li>

                <%
                    }

                    if (pageTotal > pageCurrent) {
                %>
                <a class="anteriorProx" href="<%= nextURL%>"><fmt:message key="jsp.search.general.next" /></a>
                <%
                    }
                %>
            </ul>
        </td>
    </tr>

    <tr>
        <td style="text-align: center;">
            <fmt:message key="jsp.search.results.results">
                <fmt:param><%=qResults.getStart() + 1%></fmt:param>
                <fmt:param><%=qResults.getStart() + qResults.getHitHandles().size()%></fmt:param>
                <fmt:param><%=qResults.getHitCount()%></fmt:param>
            </fmt:message>
        </td>
    </tr>
</table>