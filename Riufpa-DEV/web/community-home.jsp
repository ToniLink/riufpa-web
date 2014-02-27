<%--
  - community-home.jsp
  -
  - Version: $Revision: 4603 $
  -
  - Date: $Date: 2009-12-03 08:17:54 +0000 (Thu, 03 Dec 2009) $
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
  - Community home JSP
  -
  - Attributes required:
  -    community             - Community to render home page for
  -    collections           - array of Collections in this community
  -    subcommunities        - array of Sub-communities in this community
  -    last.submitted.titles - String[] of titles of recently submitted items
  -    last.submitted.urls   - String[] of URLs of recently submitted items
  -    admin_button - Boolean, show admin 'edit' button
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.*" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>


<%
    // Retrieve attributes
    Community community = (Community) request.getAttribute("community");
    Collection[] collections = (Collection[]) request.getAttribute("collections");
    Community[] subcommunities = (Community[]) request.getAttribute("subcommunities");

    RecentSubmissions rs = (RecentSubmissions) request.getAttribute("recently.submitted");

    Boolean editor_b = (Boolean) request.getAttribute("editor_button");
    boolean editor_button = (editor_b == null ? false : editor_b.booleanValue());
    Boolean add_b = (Boolean) request.getAttribute("add_button");
    boolean add_button = (add_b == null ? false : add_b.booleanValue());
    Boolean remove_b = (Boolean) request.getAttribute("remove_button");
    boolean remove_button = (remove_b == null ? false : remove_b.booleanValue());

    // get the browse indices
    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();

    // Put the metadata values into guaranteed non-null variables
    String name = community.getMetadata("name");
    String intro = community.getMetadata("introductory_text");
    String copyright = community.getMetadata("copyright_text");
    String sidebar = community.getMetadata("side_bar_text");
    Bitstream logo = community.getLogo();

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled) {
        feedData = "comm:" + ConfigurationManager.getProperty("webui.feed.formats");
    }

    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    //Se for uma comunidade, então o menu de navegação deve indicar o caminho da Lista de Comunidades.
    //Se for um sub-comunidade, então o menu deve apontar para a sua comunidade-pai.
    String titulo = "jsp.community-list.title";
    String linkTit = "/community-list";
    if (community.getParentCommunity() != null) { //Se for uma sub-comunidade
        titulo = community.getParentCommunity().getName(); //nome da comunidade-pai
        linkTit = "/handle/" + community.getParentCommunity().getHandle(); //handle (endereço) da comunidade-pai
    }
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout nocache="true" parentlink="<%= linkTit%>" parenttitlekey="<%=titulo%>" locbar="link">

    <style type="text/css">
        .button{
            margin: 0px !important;
        }
    </style>

    <table border="0" cellpadding="5" width="100%">
        <tr>
            <td width="100%">
                <h1><%= name%>
                    <%
                        if (ConfigurationManager.getBooleanProperty("webui.strengths.show")) {
                    %>
                    : [<%= ic.getCount(community)%>]
                    <%
                        }
                    %>
                </h1>
            </td>
            <td valign="top">
                <%  if (logo != null) {%>
                <img alt="Logo" src="<%= request.getContextPath()%>/retrieve/<%= logo.getID()%>" />
                <% }%>
            </td>
        </tr>
    </table>


    <%-- Pesquisa e visualização --%>
    <div class="painel">
    <form method="get" action="">
    <table>
        <tr>
            <td class="right">
                <label for="tlocation">
                    <strong><fmt:message key="jsp.general.location"/></strong>
                </label>
            </td>
            <td>
                <select name="location" id="tlocation">
                    <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                    <option selected="selected" value="<%= community.getHandle()%>"><%= name%></option>
                    <%
                        for (int i = 0; i < collections.length; i++) {
                    %>
                    <option value="<%= collections[i].getHandle()%>"><%= collections[i].getMetadata("name")%></option>
                    <%
                        }
                    %>
                    <%
                        for (int j = 0; j < subcommunities.length; j++) {
                    %>
                    <option value="<%= subcommunities[j].getHandle()%>"><%= subcommunities[j].getMetadata("name")%></option>
                    <%
                        }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td class="right">
                <label for="tquery">
                    <strong><fmt:message key="jsp.general.searchfor"/></strong>
                </label>
            </td>
            <td>
                <input type="text" style="width: 68%" name="query" id="tquery" />
                <input type="submit" class="button" name="submit_search" value="<fmt:message key="jsp.general.go"/>" />
            </td>
        </tr>
    </table>
    </form>

            <table>
        <tr>
            <td class="right">
                <b><fmt:message key="community.home.visualizar"/></b>
            </td>
            <td>
                <%-- Insert the dynamic list of browse options --%>

                <%

                    for (int i = 0; i < bis.length - 2; i++) {
                        if (!(bis[i].getName().equalsIgnoreCase("orientadorEcoorientador"))) {
                            String Key = "browse.menu." + bis[i].getName();

                %>
                <form style="display: inline" method="get" action="<%= request.getContextPath()%>/handle/<%= community.getHandle()%>/browse">
                    <input type="hidden" name="type" value="<%= bis[i].getName()%>"/>
                    <%-- <input type="hidden" name="community" value="<%= community.getHandle() %>" /> --%>
                    <input type="submit" class="button" name="submit_browse" value="<fmt:message key="<%= Key%>"/>"/>
                </form>
                <%
                        }
                    }
                %>
            </td>
        </tr>
    </table>
    </div>


    <%
        if (collections.length != 0) {
    %>

    <%-- <h2>Collections in this community</h2> --%>
    <h2><fmt:message key="jsp.community-home.heading2"/></h2>
    <ul class="collectionListItem">
        <%
            for (int i = 0; i < collections.length; i++) {
        %>
        <li>
            <a href="<%= request.getContextPath()%>/handle/<%= collections[i].getHandle()%>"><%= collections[i].getMetadata("name")%></a>
            <%
                if (ConfigurationManager.getBooleanProperty("webui.strengths.show")) {
            %>
            [<%= ic.getCount(collections[i])%>]
            <%
                }
            %>
            <%
                if (remove_button) {
            %>
            <form method="post" style="display: inline;" action="<%=request.getContextPath()%>/tools/edit-communities">
                <input type="hidden" name="parent_community_id" value="<%= community.getID()%>" />
                <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                <input type="hidden" name="collection_id" value="<%= collections[i].getID()%>" />
                <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_DELETE_COLLECTION%>" />
                <input type="image" title="Remover Coleção" src="<%= request.getContextPath()%>/image/remove.gif" />
            </form>
            <% }%>
            <p class="collectionDescription"><%= collections[i].getMetadata("short_description")%></p>
        </li>
        <%
            }
        %>
    </ul>
    <%
        }
    %>

    <%
        if (subcommunities.length != 0) {
    %>
    <%--<h2>Sub-communities within this community</h2>--%>
    <h2><fmt:message key="jsp.community-home.heading3"/></h2>

    <ul class="collectionListItem">
        <%
            for (int j = 0; j < subcommunities.length; j++) {
        %>
        <li>
            <a href="<%= request.getContextPath()%>/handle/<%= subcommunities[j].getHandle()%>">
                <%= subcommunities[j].getMetadata("name")%></a>
                <%
                    if (ConfigurationManager.getBooleanProperty("webui.strengths.show")) {
                %>
            [<%= ic.getCount(subcommunities[j])%>]
            <%
                }
                if (remove_button) {
            %>
            <form method="post" style="display:inline" action="<%=request.getContextPath()%>/tools/edit-communities">
                <input type="hidden" name="parent_community_id" value="<%= community.getID()%>" />
                <input type="hidden" name="community_id" value="<%= subcommunities[j].getID()%>" />
                <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_DELETE_COMMUNITY%>" />
                <input type="image" title="Remover Comunidade" src="<%= request.getContextPath()%>/image/remove.gif" />
            </form>
            <%
                }
            %>
            <p class="collectionDescription"><%= subcommunities[j].getMetadata("short_description")%></p>
        </li>
        <%
            }
        %>
    </ul>
    <%
        }
    %>

    <p class="copyrightText"><%= copyright%></p>

    <dspace:sidebar>
        <% if (editor_button || add_button) // edit button(s)
            {
        %>
        <table class="adminFerr" >
            <tr>
                <td class="evenRowEvenCol" colspan="2">
                    <table>
                        <tr>
                            <th id="t1" class="standard">
                                <strong><fmt:message key="jsp.admintools"/></strong>
                            </th>
                        </tr>
                        <tr>
                            <td headers="t1" class="standard" align="center">
                                <% if (editor_button) {%>
                                <form method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
                                    <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                                    <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_EDIT_COMMUNITY%>" />
                                    <%--<input type="submit" value="Edit..." />--%>
                                    <input class="button" type="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                                </form>
                            </td>
                        </tr>
                        <% }%>
                        <% if (add_button) {%>
                        <tr>
                            <td>
                                <form method="post" action="<%=request.getContextPath()%>/tools/collection-wizard">
                                    <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                                    <input class="button" type="submit" value="<fmt:message key="jsp.community-home.create1.button"/>" />
                                </form>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <form method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
                                    <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
                                    <input type="hidden" name="parent_community_id" value="<%= community.getID()%>" />
                                    <%--<input type="submit" name="submit" value="Create Sub-community" />--%>
                                    <input class="button" type="submit" name="submit" value="<fmt:message key="jsp.community-home.create2.button"/>" />
                                </form>
                            </td>
                        </tr>
                        <% }%>

                        <% if (editor_button) {%>
                        <tr>
                            <td headers="t1" class="standard" align="center">
                                <form method="post" action="<%=request.getContextPath()%>/mydspace">
                                    <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE%>" />
                                    <input class="button" type="submit" value="<fmt:message key="jsp.mydspace.request.export.community"/>" />
                                </form>
                            </td>
                        </tr>

                        <tr>
                            <td headers="t1" class="standard" align="center">
                                <form method="post" action="<%=request.getContextPath()%>/mydspace">
                                    <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE%>" />
                                    <input class="button" type="submit" value="<fmt:message key="jsp.mydspace.request.export.migratecommunity"/>" />
                                </form>
                            </td>
                        </tr>

                        <tr>
                            <td headers="t1" class="standard" align="center">
                                <form method="post" action="<%=request.getContextPath()%>/dspace-admin/metadataexport">
                                    <input type="hidden" name="handle" value="<%= community.getHandle()%>" />
                                    <input class="button" type="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                                </form>
                            </td>
                        </tr>

                        <% }%>
                    </table>
                </td>
            </tr>
        </table>

        <%
            }
        %>


        <%
            if (rs != null && rs.getRecentSubmissions().length > 0) {
        %>
        <div class="opcoesSidebar">
            <%-- Submissões recentes --%>
            <h3><fmt:message key="jsp.community-home.recentsub"/></h3>
            <%
                Item[] items = rs.getRecentSubmissions();
                for (int i = 0; i < items.length; i++) {
                    DCValue[] dcv = items[i].getMetadata("dc", "title", null, Item.ANY);
                    String displayTitle = "Untitled";
                    if (dcv != null) {
                        if (dcv.length > 0) {
                            displayTitle = dcv[0].value;
                        }
                    }
            %>
            <p>
                <a href="<%= request.getContextPath()%>/handle/<%= items[i].getHandle()%>"><%= displayTitle%></a>
            </p>
            <%
                }
            %>
        </div>
        <%
            }
        %>

        <%-- Texto da comunidade que aparece na sidebar
            <%= sidebar %>
        --%>
    </dspace:sidebar>

    <div align="center">
        <form method="get" action="<%= request.getContextPath()%>/displaystats">
            <input type="hidden" name="handle" value="<%= community.getHandle()%>"/>
            <input type="submit" class="button" name="submit_simple" value="<fmt:message key="jsp.community-home.display-statistics"/>" />
        </form>
    </div>


</dspace:layout>

