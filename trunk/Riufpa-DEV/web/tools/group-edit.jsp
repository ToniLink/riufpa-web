<%--
  - group_edit.jsp
  -
  - $Id: group-edit.jsp 3705 2009-04-11 17:02:24Z mdiggory $
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
  - Show contents of a group (name, epeople)
  -
  - Attributes:
  -   group - group to be edited
  -
  - Returns:
  -   cancel - if user wants to cancel
  -   add_eperson - go to group_eperson_select.jsp to choose eperson
  -   change_name - alter name & redisplay
  -   eperson_remove - remove eperson & redisplay
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.eperson.Group"   %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.content.Collection" %>

<%
    Group group = (Group) request.getAttribute("group");
    EPerson[] epeople = (EPerson[]) request.getAttribute("members");

    Group[] groups = (Group[]) request.getAttribute("membergroups");
    request.setAttribute("LanguageSwitch", "hide");

%>

<script type="text/javascript">
    <%--Fecha a janela modal--%>
        function closeIframe() {
            //var iframe = document.getElementById('someid');
            //iframe.parentNode.removeChild(iframe);
            TINY.box.hide();
        }
</script>
<dspace:layout titlekey="jsp.tools.group-edit.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/group-edit.css" type="text/css"/>

    <h1>
        <fmt:message key="jsp.tools.group-edit.title"/> : <%=group.getName()%> (id: <%=group.getID()%>)
    </h1>

    <div class="painel">

        <form name="epersongroup" method="post" action="">

            <input size="40" hidden="hidden" name="group_name" id="tgroup_name" value="<%= Utils.addEntities(group.getName())%>"/>

            <%-- Não vamos permitir que o usuário mude o nome do grupo por questões de segurança.
            <p>
                <label for="tgroup_name">
                    <fmt:message key="jsp.tools.group-edit.name"/>
                </label>

            </p>
            --%>
            <p>
                <fmt:message key="jsp.tools.group-edit.heading"/>
            </p>

            <input type="hidden" name="group_id" value="<%=group.getID()%>"/>

            <table>
                <tr>
                    <td>
                        <strong><fmt:message key="jsp.tools.group-edit.eperson"/></strong><br/>
                        <%--Lista com os membros do grupo--%>
                        <select size="10" name="eperson_id" multiple="multiple">
                            <%
                                for (int i = 0; i < epeople.length; i++) {
                                    out.println("<option value=\"" + epeople[i].getID() + "\">" + epeople[i].getFullName() + " (" + epeople[i].getEmail() + ")</option>");
                                }
                            %>
                        </select>

                        <input type="button" class="button"
                               value="<fmt:message key='org.dspace.app.webui.jsptag.SelectEPersonTag.selectPerson'/>"
                               onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/tools/eperson-list?multiple=true', width: largura, height: altura, animate: false});" />
                        <input type="button" class="button"
                               value="<fmt:message key='org.dspace.app.webui.jsptag.SelectEPersonTag.removeSelected'/>"
                               onclick="javascript:removeSelected(window.document.epersongroup.eperson_id);" />
                    </td>

                    <td>
                        <strong><fmt:message key="jsp.tools.group-edit.group"/></strong><br/>
                        <select size="10" name="group_ids" multiple="multiple">
                            <%
                                for (int i = 0; i < groups.length; i++) {
                                    out.println("<option value=\"" + groups[i].getID() + "\">" + groups[i].getName() + " (" + groups[i].getID() + ")</option>");
                                }
                            %>
                        </select>

                        <input type="button" class="button"
                               value="<fmt:message key='org.dspace.app.webui.jsptag.SelectGroupTag.selectGroup'/>"
                               onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/tools/group-select-list?multiple=true', width: largura, height: altura, animate: false});" />
                        <input type="button" class="button"
                               value="<fmt:message key='org.dspace.app.webui.jsptag.SelectGroupTag.removeSelected'/>"
                               onclick="javascript:removeSelected(window.document.epersongroup.group_ids);" />
                    </td>
                </tr>
            </table>

            <br/>

            <p>
                <input type="submit" class="buttonGreen" name="submit_group_update" value="<fmt:message key="jsp.tools.group-edit.update.button"/>"
                       onclick="javascript:finishEPerson();
            finishGroups();"/>
            </p>
        </form>
    </div>
</dspace:layout>
