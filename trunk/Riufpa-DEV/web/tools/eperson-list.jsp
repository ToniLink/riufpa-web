<%--
  - eperson-list.jsp
  -
  - Version: $Revision: 4452 $
  -
  - Date: $Date: 2009-10-15 12:31:36 +0000 (Thu, 15 Oct 2009) $
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
  - Display list of E-people, with pagination
  -
  - Attributes:
  -
  -   epeople    - EPerson[] - all epeople to browse
  -   sortby     - Integer - field to sort by (constant from EPerson.java) (when show all)
  -   first      - Integer - index of first eperson to display (when show all)
  -   multiple   - if non-null, this is for selecting multiple epeople
  -   search     - String - query string for search eperson
  -   offset     - Integer - offset in a search result set
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.Utils" %>

<%
    int PAGESIZE = 50;

    EPerson[] epeople = (EPerson[]) request.getAttribute("epeople");
    int sortBy = ((Integer) request.getAttribute("sortby")).intValue();
    int first = ((Integer) request.getAttribute("first")).intValue();
    boolean multiple = (request.getAttribute("multiple") != null);
    String search = (String) request.getAttribute("search");
    if (search == null) {
        search = "";
    }
    int offset = ((Integer) request.getAttribute("offset")).intValue();

    // Make sure we won't run over end of list
    int last;
    if (search != null && !search.equals("")) {
        last = offset + PAGESIZE;
    } else {
        last = first + PAGESIZE;
    }
    if (last >= epeople.length) {
        last = epeople.length - 1;
    }

    // Index of first eperson on last page
    int jumpEnd = ((epeople.length - 1) / PAGESIZE) * PAGESIZE;

    // Now work out values for next/prev page buttons
    int jumpFiveBack;
    if (search != null && !search.equals("")) {
        jumpFiveBack = offset - PAGESIZE * 5;
    } else {
        jumpFiveBack = first - PAGESIZE * 5;
    }
    if (jumpFiveBack < 0) {
        jumpFiveBack = 0;
    }

    int jumpOneBack;
    if (search != null && !search.equals("")) {
        jumpOneBack = offset - PAGESIZE;
    } else {
        jumpOneBack = first - PAGESIZE;
    }
    if (jumpOneBack < 0) {
        jumpOneBack = 0;
    }

    int jumpOneForward;
    if (search != null && !search.equals("")) {
        jumpOneForward = offset + PAGESIZE;
    } else {
        jumpOneForward = first + PAGESIZE;
    }
    if (jumpOneForward > epeople.length) {
        jumpOneForward = jumpEnd;
    }

    int jumpFiveForward;
    if (search != null && !search.trim().equals("")) {
        jumpFiveForward = offset + PAGESIZE * 5;
    } else {
        jumpFiveForward = first + PAGESIZE * 5;
    }
    if (jumpFiveForward > epeople.length) {
        jumpFiveForward = jumpEnd;
    }

    // What's the link?
    String sortByParam = "lastname";
    if (sortBy == EPerson.EMAIL) {
        sortByParam = "email";
    }
    if (sortBy == EPerson.ID) {
        sortByParam = "id";
    }
    if (sortBy == EPerson.LANGUAGE) {
        sortByParam = "language";
    }

    String jumpLink;
    if (search != null && !search.equals("")) {
        jumpLink = request.getContextPath() + "/tools/eperson-list?multiple=" + multiple + "&sortby=" + sortByParam + "&first=" + first + "&search=" + search + "&offset=";
    } else {
        jumpLink = request.getContextPath() + "/tools/eperson-list?multiple=" + multiple + "&sortby=" + sortByParam + "&first=";
    }
    String sortLink = request.getContextPath() + "/tools/eperson-list?multiple=" + multiple + "&first=" + first + "&sortby=";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <title><fmt:message key="jsp.tools.eperson-list.title"/></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/styles.css.jsp" type="text/css"/>
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/favicon.ico" type="image/x-icon"/>

        <script type="text/javascript" src="<%= request.getContextPath()%>/utils.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/prototype.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/effects.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/builder.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/controls.js"></script>

        <%-- Botões --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/botoes.css" type="text/css"/>

        <%-- Biblioteca para os Tooltips --%>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/opentip/opentip.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/js/opentip/opentip.css" type="text/css"/>
        <!--[if lt IE 9]><script src="<%= request.getContextPath()%>/static/js/opentip/excanvas.js"></script><![endif]-->

        <%-- Paginação --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/paginacao.css" type="text/css"/>

        <%-- Estilos --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/lista-grupo-eperson.css" type="text/css"/>


        <script type="text/javascript">
            <!-- Begin

            // Add the selected items to main e-people list by calling method of parent
            function addEPerson(id, email, name){
                parent.addEPerson(id, email, name);
                //parent.closeIframe();
            }

            // Clear selected items from main e-people list
            function clearEPeople(){
                var list = parent.document.epersongroup.eperson_id;
                while (list.options.length > 0) {
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
                <fmt:message key="jsp.tools.eperson-list.info1"/>
            </p>
            <%    }
            %>
            <form method="get" class="formulariodemo cf">
                <input type="hidden" name="first" value="<%= first%>" />
                <input type="hidden" name="sortby" value="<%= sortBy%>" />
                <input type="hidden" name="multiple" value="<%= multiple%>" />
                <input type="text" name="search" value="<%= search%>" placeholder="<fmt:message key="jsp.tools.eperson-list.search.query" />" required/>
                <button type="submit"><fmt:message key="jsp.tools.eperson-list.search.submit" /></button>
                <%
                    if (search != null && !search.equals("")) {
                %>
                <br/>
                <a href="<%= request.getContextPath() + "/tools/eperson-list?multiple=" + multiple + "&sortby=" + sortByParam + "&first=" + first%>">
                    <fmt:message key="jsp.tools.eperson-list.search.return-browse" />
                </a>
                <%
                    }
                %>
            </form>
        </div>

        <%-- Controls for jumping around list--%>
        <div style="text-align: center;">
            <ul class="paginacao">
                <li><a href="<%= jumpLink%>0"><fmt:message key="jsp.tools.eperson-list.jump.first"/></a></li>
                <li><a href="<%= jumpLink%><%= jumpFiveBack%>"><fmt:message key="jsp.tools.eperson-list.jump.five-back"/></a></li>
                <li><a href="<%= jumpLink%><%= jumpOneBack%>"><fmt:message key="jsp.tools.eperson-list.jump.one-back"/></a></li>
                <li><a href="<%= jumpLink%><%= jumpOneForward%>"><fmt:message key="jsp.tools.eperson-list.jump.one-forward"/></a></li>
                <li><a href="<%= jumpLink%><%= jumpFiveForward%>"><fmt:message key="jsp.tools.eperson-list.jump.five-forward"/></a></li>
                <li><a href="<%= jumpLink%><%= jumpEnd%>"><fmt:message key="jsp.tools.eperson-list.jump.last"/></a></li>
            </ul>
        </div>

        <form method="get" action=""> <%-- Will never actually be posted, it's just so buttons will appear --%>

            <table class="tabela">
                <tr id="tituloTabela">
                    <td colspan="6">
                        <fmt:message key="jsp.tools.eperson-list.heading">
                            <fmt:param><%= ((search != null && !search.equals("")) ? offset : first) + 1%></fmt:param>
                            <fmt:param><%= last + 1%></fmt:param>
                            <fmt:param><%= epeople.length%></fmt:param>
                        </fmt:message>
                    </td>
                </tr>
                <%
                    if (search != null && !search.equals("")) {
                %>
                <tr>
                    <th><fmt:message key="jsp.tools.eperson-list.action"/></th>
                    <th><fmt:message key="jsp.tools.eperson-list.th.id" /></th>
                    <th><fmt:message key="jsp.tools.eperson-list.th.email" /></th>
                    <th><fmt:message key="jsp.tools.eperson-list.th.lastname" /></th>
                    <th><fmt:message key="jsp.tools.eperson-list.th.lastname" /></th>
                </tr>
                <%} else {
                %>
                <tr>
                    <th id="t1"><fmt:message key="jsp.tools.eperson-list.action"/></th>
                    <th id="t2">
                        <%
                            if (sortBy == EPerson.ID) {
                        %>
                        <strong><fmt:message key="jsp.tools.eperson-list.th.id.sortedby" /></strong>
                        <%} else {
                        %>
                        <a href="<%= sortLink%>id"><fmt:message key="jsp.tools.eperson-list.th.id" /></a>
                        <%
                            }
                        %>
                    </th>
                    <th id="t3">
                        <%
                            if (sortBy == EPerson.EMAIL) {
                        %>
                        <strong><fmt:message key="jsp.tools.eperson-list.th.email.sortedby" /></strong><%                    } else {
                        %>
                        <a href="<%= sortLink%>email"><fmt:message key="jsp.tools.eperson-list.th.email" /></a><%
                            }
                        %>
                    </th>
                    <%-- <th><%= sortBy == EPerson.LASTNAME ? "<strong>Last Name &uarr;</strong>" : "<a href=\"" + sortLink + "lastname\">Last Name</a>" %></th> --%>
                    <th id="t4">
                        <%
                            if (sortBy == EPerson.LASTNAME) {
                        %>
                        <fmt:message key="jsp.tools.eperson-list.th.lastname.sortedby" /><%                    } else {
                        %>
                        <a href="<%= sortLink%>lastname"><fmt:message key="jsp.tools.eperson-list.th.lastname" /></a><%
                            }
                        %>
                    </th>

                    <th id="t5">
                        <fmt:message key="jsp.tools.eperson-list.th.firstname"/>
                    </th>

                    <th id="t6">
                        <%
                            if (sortBy == EPerson.LANGUAGE) {
                        %>
                        <fmt:message key="jsp.tools.eperson-list.th.language.sortedby" /><%                    } else {
                        %>
                        <a href="<%= sortLink%>language"><fmt:message key="jsp.tools.eperson-list.th.language" /></a><%
                            }
                        %>
                    </th>
                </tr>
                <%
                    }

                    // If this is a dialogue to select a *single* e-person, we want
                    // to clear any existing entry in the e-person list, and
                    // to close this window when a 'select' button is clicked
                    String clearList = (multiple ? "" : "clearEPeople();");
                    String closeWindow = (multiple ? "" : "parent.closeIframe();");
                    //se não for múltiplo, fecha a janela modal assim que o usuário selecionar um eperson.
                    //caso contrário, não a fecha e exibe uma tooltip dizendo que eperson foi anexado à lista.

                    String tooltipmsg = LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.eperson-list.added");
                    for (int i = (search != null && !search.equals("")) ? offset : first; i <= last; i++) {
                        EPerson e = epeople[i];
                        // Make sure no quotes in full name will mess up our Javascript
                        String fullname = e.getFullName().replace('\'', ' ');
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
                    if (multiple) {%><fmt:message key="jsp.tools.general.add"/><% } else {%><fmt:message key="jsp.tools.general.select"/><% }%>"
                                   onclick="javascript:<%= clearList%>addEPerson(<%= e.getID()%>, '<%= e.getEmail().replaceAll("'", "\\\\'")%>', '<%= Utils.addEntities(fullname)%>'); <%= closeWindow%> Tips.add(this, event, '<%= tooltipmsg %>', { style: 'standard', stem: true, tipJoint: [ 'left', 'middle' ], targetJoint: [ 'right', 'middle' ], target: true });"/>
                        </td>
                        <td headers="t2"><%= e.getID()%></td>
                        <td headers="t3"><%= e.getEmail()%></td>
                        <td headers="t4">
                            <%= (e.getLastName() == null ? "" : e.getLastName())%>
                        </td>
                        <td headers="t5">
                            <%= (e.getFirstName() == null ? "" : e.getFirstName())%>
                        </td>
                        <td headers="t6">
                            <%= (e.getLanguage() == null ? "" : e.getLanguage())%>
                        </td>
                    </tr>
                    <%
                        }
                    %>
            </table>

            <br/>

            <%-- Controls for jumping around list--%>
            <div style="text-align: center;">
                <ul class="paginacao">
                    <li><a href="<%= jumpLink%>0"><fmt:message key="jsp.tools.eperson-list.jump.first"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpFiveBack%>"><fmt:message key="jsp.tools.eperson-list.jump.five-back"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpOneBack%>"><fmt:message key="jsp.tools.eperson-list.jump.one-back"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpOneForward%>"><fmt:message key="jsp.tools.eperson-list.jump.one-forward"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpFiveForward%>"><fmt:message key="jsp.tools.eperson-list.jump.five-forward"/></a></li>
                    <li><a href="<%= jumpLink%><%= jumpEnd%>"><fmt:message key="jsp.tools.eperson-list.jump.last"/></a></li>
                </ul>
            </div>

        </form>

    </body>
</html>
