<%--
  - community-list.jsp
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


<%--
  - Display hierarchical list of communities and collections
  -
  - Attributes to be passed in:
  -    communities         - array of communities
  -    collections.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of collections in that community
  -    subcommunities.map  - Map where a keys is a community IDs (Integers) and
  -                      the value is the array of subcommunities in that community
  -    admin_button - Boolean, show admin 'Create Top-Level Community' button
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.ItemCountException" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    Community[] communities = (Community[]) request.getAttribute("communities");
    Map collectionMap = (Map) request.getAttribute("collections.map");
    Map subcommunityMap = (Map) request.getAttribute("subcommunities.map");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    boolean showAll = true;
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<%-- Script para o toggle das comunidades e coleções --%>
<script type="text/javascript" src="<%= request.getContextPath() %>/static/js/riufpa/expandir-encolher.js"></script>

<%!
    JspWriter out = null;
    HttpServletRequest request = null;
    boolean impar = false;

    void setContext(JspWriter out, HttpServletRequest request)
    {
        this.out = out;
        this.request = request;
    }

    void showCommunity(Community c, int id) throws ItemCountException, IOException, SQLException
    {
        boolean temPai = false;
    	ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
        int qtde = c.getAllParents().length; //obtemos todas as comunidades-pai

        if(qtde == 0){
            if(!impar)
                out.println( "<li class=\"communityLink\">" );
            else
                out.println( "<li class=\"communityLink2\">" );
            impar = !impar;
        } else{
            out.println( "<li>" );
        }


        if(qtde == 0) //se não tiver nenhum pai, logo será o primeiro da lista, logo deve ter o link de expandir.
            out.println("<a title=\"Expandir\" href=\"javascript:void(0);\" onclick=\"mostrarSubComu('" + c.getMetadata("name") + "'," + id + ")\">"
                    + "<img name=\"botao\" id=\"expandir" + id + "\" src=\"" + request.getContextPath() + "/image/expandir.png\">"
                    + "</a>&nbsp;&nbsp;"
                    + "<a href=\"" + request.getContextPath() + "/handle/" + c.getHandle() + "\">" + c.getMetadata("name") + "</a>");
        else { //as sub-comunidades devem estar em negrito
            out.println("<b><a href=\"" + request.getContextPath() + "/handle/" + c.getHandle() + "\">" + c.getMetadata("name") + "</a></b>");
            temPai = true;
       }


        if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
            out.println(" <span class=\"communityStrength\">[" + ic.getCount(c) + "]</span>");
        }

        // Get the collections in this community
        Collection[] cols = c.getCollections();
        if (cols.length > 0)
        {
            if(!temPai) //se não tem pai, oculta as coleções.
                out.println("<div style=\"display: none\" id=\""+c.getMetadata("name")+"=a\"><ul>");
            else //se tem pai, exibe as coleções, pois é uma sub-comunidade (não queremos clicar nelas também para exibir as coleções).
                out.println("<div><ul>");
            for (int j = 0; j < cols.length; j++)
            {
                out.println("<li class=\"collectionListItem\">");
                out.println("<a href=\"" + request.getContextPath() + "/handle/" + cols[j].getHandle() + "\">" + cols[j].getMetadata("name") +"</a>");
                if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
                    out.println(" [" + ic.getCount(cols[j]) + "]");
                }

                out.println("</li>");
            }
            out.println("</ul></div>");
        }

        // Get the sub-communities in this community
        Community[] comms = c.getSubcommunities();
        if (comms.length > 0)
        {
            //as sub-comunidades são escondidas por padrão.
            out.println("<div style=\"display: none\" id=\""+c.getMetadata("name") +"=b\"><ul>");
            for (int k = 0; k < comms.length; k++)
            {
               showCommunity(comms[k], k);
            }
            out.println("</ul></div>");
        }
        //out.println("<br /><br /><br />");
        out.println("</li>");
    }
%>

<dspace:layout titlekey="jsp.community-list.title">

<%
    if (admin_button)
    {
%>

<div style="margin-bottom: 20px;">
<p align="center" style="color: #0332B2; font-size: 18px; display: inline">
    <b><fmt:message key="jsp.community-list.title"/></b>
</p>

<div style="text-align: right;width:40%;float:right">
    <form method="post" action="<%=request.getContextPath()%>/dspace-admin/edit-communities">
        <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
        <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.community-list.create.button"/>" />
    </form>
</div>
</div>


<%
    }
    else
    {
%>
	<h1><fmt:message key="jsp.community-list.title"/></h1>
	<p style="display:none;"><fmt:message key="jsp.community-list.text1"/></p>
<%
    }
%>
<% if (communities.length != 0)
{
%>

<style type="text/css">
    <%--Removemos o marcador das listas (aquela bolinha preta :)
    Note que os subitens NÃO serão afetados, eles ainda terão seus marcadores (Bolinhas, quadrados, etc).
    --%>
    ul.listaDeComunidades {list-style-type:none; font-weight: normal; line-height: 30px;}
    ul.listaDeComunidades img{border: 0px;}
    ul.listaDeComunidades li:hover{background-color: #D6E1FF !important;} <%--Hover para as linhas da lista.--%>
</style>
<ul class="listaDeComunidades">
<%
    if (showAll)
    {
        setContext(out, request);
        for (int i = 0; i < communities.length; i++)
        {
            showCommunity(communities[i], i);
        }
        //RESETA AS POSIÇÕES DAS LISTRAS DA TABELA! Senão, no primeiro acesso, a tabela começa com a cor 1
        //e no segundo com a cor 2, e assim sucessivamente. Resetando, a tabela começa sempre com uma cor.
        impar = false;
     }
     else
     {
        for (int i = 0; i < communities.length; i++)
        {
%>
            <li class="communityLink">
            <%-- HACK: <strong> tags here for broken Netscape 4.x CSS support --%>
            <strong><a href="<%= request.getContextPath() %>/handle/<%= communities[i].getHandle() %>"><%= communities[i].getMetadata("name") %></a></strong>
	    <ul>
<%
            // Get the collections in this community from the map
            Collection[] cols = (Collection[]) collectionMap.get(new Integer(communities[i].getID()));

            for (int j = 0; j < cols.length; j++)
            {
%>
                <li class="collectionListItem">
                    <a href="<%= request.getContextPath() %>/handle/<%= cols[j].getHandle() %>"><%= cols[j].getMetadata("name") %></a>
<%
                if (ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
%>
                    [<%= ic.getCount(cols[j]) %>]
<%
                }
%>
                </li>
<%
            }
%>
            </ul>
	    <ul>
<%
            // Get the sub-communities in this community from the map
            Community[] comms = (Community[]) subcommunityMap.get(
                new Integer(communities[i].getID()));

            for (int k = 0; k < comms.length; k++)
            {
%>
                <li class="communityLink">
                <a href="<%= request.getContextPath() %>/handle/<%= comms[k].getHandle() %>"><%= comms[k].getMetadata("name") %></a>
<%
                if (ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
%>
                    [<%= ic.getCount(comms[k]) %>]
<%
                }
%>
				</li>
<%
            }
%>
            </ul>
            <br />
        </li>
<%
        }
    }
%>
    </ul>

<% }
%>
</dspace:layout>
