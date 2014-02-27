<%--
  - collection-home.jsp
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
  - Collection home JSP
  -
  - Attributes required:
  -    collection  - Collection to render home page for
  -    community   - Community this collection is in
  -    last.submitted.titles - String[], titles of recent submissions
  -    last.submitted.urls   - String[], corresponding URLs
  -    logged.in  - Boolean, true if a user is logged in
  -    subscribed - Boolean, true if user is subscribed to this collection
  -    admin_button - Boolean, show admin 'edit' button
  -    editor_button - Boolean, show collection editor (edit submitters, item mapping) buttons
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.ItemCounter"%>
<%@ page import="org.dspace.content.*"%>
<%@ page import="org.dspace.core.ConfigurationManager"%>
<%@ page import="org.dspace.eperson.Group"     %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>


<%
    // Retrieve attributes
    Collection collection = (Collection) request.getAttribute("collection");
    Community community = (Community) request.getAttribute("community");
    Group submitters = (Group) request.getAttribute("submitters");

    RecentSubmissions rs = (RecentSubmissions) request.getAttribute("recently.submitted");

    boolean loggedIn =
            ((Boolean) request.getAttribute("logged.in")).booleanValue();
    boolean subscribed =
            ((Boolean) request.getAttribute("subscribed")).booleanValue();
    Boolean admin_b = (Boolean) request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());

    Boolean editor_b = (Boolean) request.getAttribute("editor_button");
    boolean editor_button = (editor_b == null ? false : editor_b.booleanValue());

    Boolean submit_b = (Boolean) request.getAttribute("can_submit_button");
    boolean submit_button = (submit_b == null ? false : submit_b.booleanValue());

    // get the browse indices
    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();

    // Put the metadata values into guaranteed non-null variables
    String name = collection.getMetadata("name");
    String intro = collection.getMetadata("introductory_text");
    if (intro == null) {
        intro = "";
    }
    String copyright = collection.getMetadata("copyright_text");
    if (copyright == null) {
        copyright = "";
    }
    String sidebar = collection.getMetadata("side_bar_text");
    if (sidebar == null) {
        sidebar = "";
    }

    String communityName = community.getMetadata("name");
    String communityLink = "/handle/" + community.getHandle();

    Bitstream logo = collection.getLogo();

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled) {
        feedData = "coll:" + ConfigurationManager.getProperty("webui.feed.formats");
    }

    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout locbar="commLink" title="<%= name%>" feedData="<%= feedData%>">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/collection-home.css" type="text/css"/>

    <h1>
        <%= name%>
        <%
            if (ConfigurationManager.getBooleanProperty("webui.strengths.show")) {
        %>
        : [<%= ic.getCount(collection)%>]
        <%
            }
        %>
    </h1>

    <%  if (logo != null) {%>
    <div class="logomarca">
        <img alt="Logo" src="<%= request.getContextPath()%>/retrieve/<%= logo.getID()%>" />
    </div>
    <% }%>


    <div class="ferramentas">

        <form method="get" action="">
            <table>
                <tr>
                    <td class="info">
                        <label for="tlocation"><fmt:message key="jsp.general.location"/></label>
                    </td>
                    <td>
                        <select name="location" id="tlocation">
                            <option value="/"><fmt:message key="jsp.general.genericScope"/></option>
                            <option selected="selected" value="<%= community.getHandle()%>"><%= communityName%></option>
                            <option selected="selected" value="<%= collection.getHandle()%>"><%= name%></option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="info">
                        <label for="tquery"><fmt:message key="jsp.general.searchfor"/></label>
                    </td>
                    <td>
                        <input type="text" name="query" id="tquery"/>
                        <input type="submit" class="button" name="submit_search" value="<fmt:message key="jsp.general.go"/>" />
                    </td>
                </tr>
            </table>
        </form>

        <table>
            <tr>
                <td class="info">
                    <b><fmt:message key="collection.home.visualizar"/></b>
                </td>
                <td>
                    <%
                        for (int i = 0; i < bis.length; i++) {
                            String key = "browse.menu." + bis[i].getName();
                            if (key.contains("orientador")) {
                                continue;
                            }
                    %>
                    <form method="get" action="<%= request.getContextPath()%>/handle/<%= collection.getHandle()%>/browse">
                        <input type="hidden" name="type" value="<%= bis[i].getName()%>"/>
                        <input type="hidden" name="collection" value="<%= collection.getHandle()%>" />
                        <input type="submit" class="button" name="submit_browse" value="<fmt:message key="<%= key%>"/>"/>
                    </form>
                    <%

                        }
                    %>
                </td>
            </tr>
        </table>
    </div>

    <%
        if (intro != null && !intro.isEmpty()) {
    %>
    <div class="descricao">
        <p>
            <%= intro%>
        </p>
    </div>
    <%
        }
        Item[] items = rs.getRecentSubmissions();
        if (rs != null && items.length > 0) {
    %>

    <table class="tabela">
        <tr>
            <th colspan="3" class="tituloTabela">
                <fmt:message key="jsp.collection-home.recentsub"/>
            </th>
        </tr>
        <tr>
            <th>
                <fmt:message key="collection.home.tabela.dataPublicacao"/>
            </th>
            <th>
                <fmt:message key="collection.home.tabela.titulo"/>
            </th>
            <th>
                <fmt:message key="collection.home.tabela.autores"/>
            </th>
        </tr>
        <%
            for (int i = 0; i < items.length; i++) {
                DCValue[] dcv = items[i].getMetadata("dc", "title", null, Item.ANY);
                DCValue[] dataPublicacao = items[i].getMetadata("dc", "date", "issued", Item.ANY);
                DCValue[] autoresPublicacao = items[i].getMetadata("dc", "contributor", "author", Item.ANY);

                String displayTitle = "Untitled";
                String dataPub = "-";
                String autores = "";
                if (dcv != null) {
                    if (dcv.length > 0) {
                        displayTitle = dcv[0].value;
                    }
                }
                if (dataPublicacao != null && dataPublicacao.length > 0) {
                    dataPub = dataPublicacao[0].value;
                }
                if (autoresPublicacao != null && autoresPublicacao.length > 0) {
                    //Exemplo de link para o autor 'BELESI, Lia Marques'
                    //http://localhost:8080/jspui/browse?type=author&value=BELESI,+Lia+Marques
                    String nomeAutor = autoresPublicacao[0].value;
                    String valorPesquisa = nomeAutor.replaceAll("\\s", "+");
                    String linkPesquisa = request.getContextPath() + "/browse?type=author&value=" + valorPesquisa;
                    if (autoresPublicacao.length == 1) {
                        autores += "<a href=\"" + linkPesquisa + "\">" + autoresPublicacao[0].value + "</a><br/>";
                    } else {
                        autores += "<a href=\"" + linkPesquisa + "\">" + autoresPublicacao[0].value + "</a>, et al<br/>";
                    }
                }

                String listrar = "";
                if (i % 2 != 0) {
                    listrar = "class=\"stripe\"";
                }

        %>
        <tr <%= listrar%>>
            <td>
                <%= dataPub%>
            </td>
            <td>
                <a href="<%= request.getContextPath()%>/handle/<%= items[i].getHandle()%>"><%= displayTitle%></a>
            </td>
            <td>
                <%= autores%>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <%
    } else {
    %>
    <h3>Não há submissões recentes.</h3>
    <%    }
    %>

    <%-- Só exibe o butão 'ver todos' se a coleção tiver mais itens do que o número de submissões recentes. --%>
    <%
        if (collection.countItems() > ConfigurationManager.getIntProperty("recent.submissions.count")) {
    %>
    <div class="verTodos">
        <button type="button" class="button" onclick="javascript:window.location = document.URL + '/browse?type=title';">
            <fmt:message key="collection.home.todosItens"/>
        </button>
    </div>
    <%    }
    %>

    <p class="copyrightText"><%= copyright%></p>


    <dspace:sidebar>
        <%-- A sidebar contém apenas as ferramentas de administrador, logo só é exibida quando o usuário for um.--%>
        <%
            if (admin_button || editor_button) {
        %>
        <table class="adminFerr">
            <tr>
                <th>
                    <strong><fmt:message key="jsp.admintools"/></strong>
                </th>
            </tr>

            <% if (editor_button) {%>
            <tr>
                <td>
                    <form method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
                        <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                        <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                        <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_EDIT_COLLECTION%>" />
                        <input type="submit" class="button" value="<fmt:message key="jsp.general.edit.button"/>" />
                    </form>
                </td>
            </tr>
            <% }%>

            <% if (admin_button) {%>
            <tr>
                <td>
                    <form method="post" action="<%=request.getContextPath()%>/tools/itemmap">
                        <input type="hidden" name="cid" value="<%= collection.getID()%>" />
                        <input type="submit" class="button" value="<fmt:message key="jsp.collection-home.item.button"/>" />
                    </form>
                </td>
            </tr>
            <% if (submitters != null) {%>
            <tr>
                <td>
                    <form method="get" action="<%=request.getContextPath()%>/tools/group-edit">
                        <input type="hidden" name="group_id" value="<%=submitters.getID()%>" />
                        <input type="submit" class="button" name="submit_edit" value="<fmt:message key="jsp.collection-home.editsub.button"/>" />
                    </form>
                </td>
            </tr>
            <% }%>
            <% if (editor_button || admin_button) {%>
            <tr>
                <td>
                    <form method="post" action="<%=request.getContextPath()%>/mydspace">
                        <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE%>" />
                        <input type="submit" class="button" value="<fmt:message key="jsp.mydspace.request.export.collection"/>" />
                    </form>
                </td>
            </tr>
            <tr>
                <td>
                    <form method="post" action="<%=request.getContextPath()%>/mydspace">
                        <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE%>" />
                        <input type="submit" class="button" value="<fmt:message key="jsp.mydspace.request.export.migratecollection"/>" />
                    </form>
                </td>
            </tr>
            <tr>
                <td>
                    <form method="post" action="<%=request.getContextPath()%>/dspace-admin/metadataexport">
                        <input type="hidden" name="handle" value="<%= collection.getHandle()%>" />
                        <input type="submit" class="button" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
        <%
            }
        %>

        <div class="opcoesSidebar">
            <%--Iniciar uma nova submissão para esta coleção--%>
            <%
                if (submit_button) {
            %>
            <form action="<%= request.getContextPath()%>/submit" method="post">
                <input type="hidden" name="collection" value="<%= collection.getID()%>" />
                <input type="submit" name="submit" id="botao" value="<fmt:message key="jsp.collection-home.submit.button"/>"/>
            </form>
            <%  }%>

            <%--Se inscrever/desinscrever da coleção--%>
            <form method="get" action="">
                <%  if (loggedIn && subscribed) {%>
                <%--
                <fmt:message key="jsp.collection-home.subscribed"/>
                <a href="<%= request.getContextPath()%>/subscribe">
                    <fmt:message key="jsp.collection-home.info"/>
                </a>
                --%>
                <input type="submit" id="botao" name="submit_unsubscribe" value="<fmt:message key="jsp.collection-home.unsub"/>" />
                <%  } else {%>
                <input type="submit" id="botao" name="submit_subscribe" value="<fmt:message key="jsp.collection-home.subscribe"/>"
                       onmouseover="javascript:Tips.add(this, event, '<fmt:message key="jsp.collection-home.subscribe.msg"/>', {style: 'rounded', stem: true, tipJoint: ['left', 'middle'], target: true});"/>
                <%  }%>
            </form>

            <%--Mostrar estatísticas--%>
            <form method="get" action="<%= request.getContextPath()%>/displaystats">
                <input type="hidden" name="handle" value="<%= collection.getHandle()%>"/>
                <input type="submit" id="botao" name="submit_simple" value="<fmt:message key="jsp.collection-home.display-statistics"/>"/>
            </form>
        </div>

        <%-- texto da coleção que fica na sidebar.--%>
        <%
            if (sidebar != null && !sidebar.isEmpty()) {

        %>
        <div class="descricao">
            <p>
                <%= sidebar%>
            </p>
        </div>
        <%
            }
        %>

    </dspace:sidebar>


</dspace:layout>

