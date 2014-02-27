<%--
  - group-select-list.jsp
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
  - Display list of Groups, with pagination
  -
  - Attributes:
  -
  -   groups     - Group[] - all groups to browse
  -   sortby     - Integer - field to sort by (constant from Group.java)
  -   first      - Integer - index of first group to display
  -   multiple   - if non-null, this is for selecting multiple groups
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.eperson.Group" %>

<%@ page import="org.dspace.core.Utils" %>

<%
    int PAGESIZE = 50;

    Group[] groups =
            (Group[]) request.getAttribute("groups");
    int sortBy = ((Integer) request.getAttribute("sortby")).intValue();
    int first = ((Integer) request.getAttribute("first")).intValue();
    boolean multiple = (request.getAttribute("multiple") != null);

    // Make sure we won't run over end of list
    int last = first + PAGESIZE;
    if (last >= groups.length) {
        last = groups.length - 1;
    }

    // Index of first group on last page
    int jumpEnd = ((groups.length - 1) / PAGESIZE) * PAGESIZE;

    // Now work out values for next/prev page buttons
    int jumpFiveBack = first - PAGESIZE * 5;
    if (jumpFiveBack < 0) {
        jumpFiveBack = 0;
    }

    int jumpOneBack = first - PAGESIZE;
    if (jumpOneBack < 0) {
        jumpOneBack = 0;
    }

    int jumpOneForward = first + PAGESIZE;
    if (jumpOneForward > groups.length) {
        jumpOneForward = first;
    }

    int jumpFiveForward = first + PAGESIZE * 5;
    if (jumpFiveForward > groups.length) {
        jumpFiveForward = jumpEnd;
    }

    // What's the link?
    String sortByParam = "name";
    if (sortBy == Group.ID) {
        sortByParam = "id";
    }

    String jumpLink = request.getContextPath() + "/tools/group-select-list?multiple=" + multiple + "&sortby=" + sortByParam + "&first=";
    String sortLink = request.getContextPath() + "/tools/group-select-list?multiple=" + multiple + "&first=" + first + "&sortby=";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title><fmt:message key="jsp.tools.group-select-list.title"/></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/styles.css.jsp" type="text/css"/>
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/favicon.ico" type="image/x-icon"/>

        <script type="text/javascript" src="<%= request.getContextPath()%>/utils.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/prototype.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/effects.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/builder.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/controls.js"></script>

        <%-- Biblioteca para os Tooltips --%>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/opentip/opentip.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/js/opentip/opentip.css" type="text/css"/>
        <!--[if lt IE 9]><script src="<%= request.getContextPath()%>/static/js/opentip/excanvas.js"></script><![endif]-->

        <%-- Botões --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/botoes.css" type="text/css"/>

        <%-- Paginação --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/paginacao.css" type="text/css"/>

        <%-- Estilos --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/lista-grupo-eperson.css" type="text/css"/>

        <script type="text/javascript">
            <!-- Begin

            // Add the selected items to main group list by calling method of parent
            function addGroup(id, name)
            {
                parent.addGroup(id, name);
            }

            // Clear selected items from main group list
            function clearGroups()
            {
                var list = parent.document.epersongroup.group_ids;
                while (list.options.length > 0)
                {
                    list.options[0] = null;
                }
            }

            // End -->
        </script>

    </head>
    <body>

        <div style="text-align: center; padding: 3px;">
            <%
                if (multiple) {
            %>
            <p style="font-weight: bold;">
                <fmt:message key="jsp.tools.group-select-list.info1"/>
            </p>
            <%    }
            %>

            <%-- Controls for jumping around list--%>
            <div style="text-align: center;">
                <ul class="paginacao">
                    <li><a href="<%= jumpLink%>0"><fmt:message key="jsp.tools.group-select-list.jump.first"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpFiveBack%>"><fmt:message key="jsp.tools.group-select-list.jump.five-back"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpOneBack%>"><fmt:message key="jsp.tools.group-select-list.jump.one-back"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpOneForward%>"><fmt:message key="jsp.tools.group-select-list.jump.one-forward"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpFiveForward%>"><fmt:message key="jsp.tools.group-select-list.jump.five-forward"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpEnd%>"><fmt:message key="jsp.tools.group-select-list.jump.last"/></a></li>
                </ul>
            </div>
        </div>



        <form method="get" action="">

            <table class="tabela">
                <tr id="tituloTabela">
                    <td colspan="3">
                        <fmt:message key="jsp.tools.group-select-list.heading">
                            <fmt:param><%= first + 1%></fmt:param>
                            <fmt:param><%= last + 1%></fmt:param>
                            <fmt:param><%= groups.length%></fmt:param>
                        </fmt:message>
                    </td>
                </tr>
                <tr>
                    <th id="t1"><fmt:message key="jsp.tools.eperson-list.action"/></th>
                    <th id="t2">
                        <%
                            if (sortBy == Group.ID) {
                        %>
                        <strong><fmt:message key="jsp.tools.group-select-list.th.id.sortedby" /></strong>
                        <%                    } else {
                        %>
                        <a href="<%= sortLink%>id"><fmt:message key="jsp.tools.group-select-list.th.id" /></a>
                        <%
                            }
                        %>
                    </th>
                    <th id="t3">
                        <%
                            if (sortBy == Group.NAME) {
                        %>
                        <strong><fmt:message key="jsp.tools.group-select-list.th.name.sortedby" /></strong>
                        <%                    } else {
                        %>
                        <a href="<%= sortLink%>name"><fmt:message key="jsp.tools.group-select-list.th.name" /></a>
                        <%
                            }
                        %></th>
                </tr>

                <%
                    // If this is a dialogue to select a *single* group, we want
                    // to clear any existing entry in the group list, and
                    // to close this window when a 'select' button is clicked
                    String clearList = (multiple ? "" : "clearGroups();");
                    String closeWindow = (multiple ? "" : "parent.closeIframe();");

                    String tooltipmsg = LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.eperson-list.added");
                    for (int i = first; i <= last; i++) {
                        Group g = groups[i];
                        // Make sure no quotes in full name will mess up our Javascript
                        String fullname = g.getName().replace('\'', ' ');
                        if (i % 2 == 0) {
                %>
                <tr>
                    <%            } else {
                    %>
                <tr id="impar">
                    <%                }
                    %>
                    <td headers="t1">
                        <input type="button" class="button" value="<%
                            if (multiple) {%><fmt:message key="jsp.tools.general.add"/><% } else {%><fmt:message key="jsp.tools.general.select"/><% }%>" onclick="javascript:<%= clearList%>addGroup('<%= g.getID()%>', '<%= Utils.addEntities(fullname)%>');<%= closeWindow%> Tips.add(this, event, '<%= tooltipmsg %>', { style: 'standard', stem: true, tipJoint: [ 'left', 'middle' ], targetJoint: [ 'right', 'middle' ], target: true });"/>
                    </td>
                    <td headers="t2"><%= g.getID()%></td>
                    <td headers="t3"> <%= g.getName()%></td>
                </tr>
                <%

                    }
                %>
            </table>

            <br/>

            <%-- Controls for jumping around list--%>
            <div style="text-align: center;">
                <ul class="paginacao">
                    <li><a href="<%= jumpLink%>0"><fmt:message key="jsp.tools.group-select-list.jump.first"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpFiveBack%>"><fmt:message key="jsp.tools.group-select-list.jump.five-back"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpOneBack%>"><fmt:message key="jsp.tools.group-select-list.jump.one-back"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpOneForward%>"><fmt:message key="jsp.tools.group-select-list.jump.one-forward"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpFiveForward%>"><fmt:message key="jsp.tools.group-select-list.jump.five-forward"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpEnd%>"><fmt:message key="jsp.tools.group-select-list.jump.last"/></a></li>
                </ul>
            </div>

            <%--
            <p align="center"><input type="button" value="<fmt:message key="jsp.tools.group-select-list.close.button"/>" onclick="window.close();"/></p>
            --%>
        </form>

    </body>
</html>
