<%--
 - itemmap-browse.jsp
 -
 - Version: $ $
 -
 - Date: $ $
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
  - Display the results of an item browse
  -
  - Attributes to pass in:
  -
  -   items          - sorted Map of Items to display
  -   collection     - Collection we're managing
  -   collections    - Map of Collections, keyed by collection_id
  -   browsetext     - text to display at the top
  -   browsetype     - "Add" or "Remove"
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="java.net.URLEncoder"            %>
<%@ page import="java.util.Iterator"             %>
<%@ page import="java.util.Map"                  %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.DCValue"    %>
<%@ page import="org.dspace.content.Item"        %>

<%
    Collection collection = (Collection) request.getAttribute("collection");
    Map items = (Map) request.getAttribute("items");
    Map collections = (Map) request.getAttribute("collections");
    String browsetext = (String) request.getAttribute("browsetext");
    Boolean showcollection = new Boolean(false);
    String browsetype = (String) request.getAttribute("browsetype");    // Only "Add" and "Remove" are handled properly
    Iterator i = items.keySet().iterator();
%>

<dspace:layout titlekey="jsp.tools.itemmap-browse.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css" />
       
    <h1>
        <% if (browsetype.equals("Add")) {%>
        <fmt:message key="jsp.tools.itemmap-browse.heading-authors">
            <fmt:param><%= browsetext%></fmt:param>
        </fmt:message>
        <% } else if (browsetype.equals("Remove")) {%>
        <fmt:message key="jsp.tools.itemmap-browse.heading-collection">
            <fmt:param><%= browsetext%></fmt:param>
        </fmt:message>
        <% }%>
    </h1>

    <%--
    <p>
    <% if (browsetype.equals("Add")){ %>
        <fmt:message key="jsp.tools.itemmap-browse.add"/>
    <% } else if (browsetype.equals("Remove")){ %>
        <fmt:message key="jsp.tools.itemmap-browse.remove"/>
    <% } %>
    </p>
    --%>

    <%-- %>p><fmt:message key="jsp.tools.itemmap-browse.infomsg"/></p--%>


    <% if (!i.hasNext()) {%> <%-- Exibe um aviso de que não há resultados.--%>

    <div class="painel">
        <p class="centralizar">
            <fmt:message key="jsp.tools.itemmap-browse.item.notfound"/>
        </p>

        <form method="post" action="<%= request.getContextPath()%>/tools/itemmap">
            <input type="hidden" name="cid" value="<%=collection.getID()%>" />
            <input type="hidden" name="action" value="<%=browsetype%>" />
            <div class="controles">
                <input type="submit" class="button" name="cancel" value="<fmt:message key="jsp.tools.general.cancel"/>" />
            </div>
        </form>
    </div>

    <% } else {%> <%-- Exibe a tabela com os resultados encontrados. --%>

    <form method="post" action="<%= request.getContextPath()%>/tools/itemmap">

        <input type="hidden" name="cid" value="<%=collection.getID()%>" />
        <input type="hidden" name="action" value="<%=browsetype%>" />

        <table class="tabela">
            <tr class="tituloTabela">
                <td colspan="4">
                    <% if (browsetype.equals("Add")) {%>
                    <fmt:message key="jsp.tools.itemmap-browse.item.found"/>
                    <% } else if (browsetype.equals("Remove")) {%>
                    <fmt:message key="jsp.tools.itemmap-browse.item.mapped"/>
                    <% }%>
                </td>
            </tr>
            <tr>
                <th>
                    <fmt:message key="jsp.tools.itemmap-browse.th.date"/>
                   
                </th>
                <th>
                    <fmt:message key="jsp.tools.itemmap-browse.th.author"/>
                </th>
                <th colspan="2">
                    <fmt:message key="jsp.tools.itemmap-browse.th.title"/>
                </th>

                <%--
                <% if(showcollection.booleanValue()) { %>
                    <th>
                        <fmt:message key="jsp.tools.itemmap-browse.th.action"/>
                    </th>
                    <th>
                        <fmt:message key="jsp.tools.itemmap-browse.th.remove"/>
                    </th>
                <% } else { %>
                    <th>
                    <% if (browsetype.equals("Add")) { %>
                            <input type="submit" value="<fmt:message key="jsp.tools.general.add"/>" />
                    <% } else if (browsetype.equals("Remove")) { %>
                            <input type="submit" value="<fmt:message key="jsp.tools.general.remove"/>" />
                    <% } %>
                    </th>
                <% } %>
                --%>
            </tr>
            <%
                int cont = 0;
                while (i.hasNext()) {
                    Item item = (Item) items.get(i.next());
                    // get the metadata or placeholders to display for date, contributor and title
                    String date = LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.without-date");
                    DCValue[] dates = item.getMetadata("dc", "date", "issued", Item.ANY);
                    if (dates.length >= 1) {
                        date = dates[0].value;
                    } else {
                        // do nothing the date is allready set to "without date"
                    }
                    String contributor = LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.without-contributor");
                    DCValue[] contributors = item.getMetadata("dc", "contributor", Item.ANY, Item.ANY);
                    if (contributors.length >= 1) {
                        contributor = contributors[0].value;

                    } else {
                        // do nothing the contributor is allready set to anonymous
                    }
                    String title = LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.untitled");
                    DCValue[] titles = item.getMetadata("dc", "title", null, Item.ANY);
                    if (titles.length >= 1) {
                        title = titles[0].value;
                    }
                    if (cont % 2 == 0) {
            %>
            <tr class="stripe">
                <%
                    } else {
                 %>
            <tr>
                <%
                    }
                    cont++;
                %>
                <td>
                    <%= date %>
                </td>
                <td>
                    <%= contributor%>
                </td>
                <td>
                    <%= title%>
                </td>

                <% if (showcollection.booleanValue()) {%>
                <%-- not currently implemented --%>
                <td>
                    <%= collection.getID()%>
                </td>
                <td>
                    <%= title%>
                </td>
                <% } else {%>
                <td>
                    <input type="checkbox" name="item_ids" value="<%=item.getID()%>" />
                </td>
                <% }
                %>
            </tr>
            <% }%>

        </table>

        <div class="controles">
            <% if (browsetype.equals("Add")) {%>
            <input type="submit" class="button" value="<fmt:message key="jsp.tools.itemmap-browse.map.selected"/>" />
            <% } else if (browsetype.equals("Remove")) {%>
            <input type="submit" class="buttonRed" value="<fmt:message key="jsp.tools.itemmap-browse.unmap.selected"/>" />
            <% }%>
            <input type="submit" class="button" name="cancel" value="<fmt:message key="jsp.tools.general.cancel"/>" />
        </div>

    </form>
    <%
        }
    %>

</dspace:layout>
