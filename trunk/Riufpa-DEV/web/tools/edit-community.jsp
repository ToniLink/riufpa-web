<%--
  - edit-community.jsp
  -
  - Version: $Revision: 4309 $
  -
  - Date: $Date: 2009-09-30 19:20:07 +0000 (Wed, 30 Sep 2009) $
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
  - Show form allowing edit of community metadata
  -
  - Attributes:
  -    community   - community to edit, if editing an existing one.  If this
  -                  is null, we are creating one.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.content.Bitstream" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.Group" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.Utils" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    Community community = (Community) request.getAttribute("community");
    int parentID = UIUtil.getIntParameter(request, "parent_community_id");
    // Is the logged in user a sys admin
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    Boolean adminCreateGroup = (Boolean) request.getAttribute("admin_create_button");
    boolean bAdminCreateGroup = (adminCreateGroup == null ? false : adminCreateGroup.booleanValue());

    Boolean adminRemoveGroup = (Boolean) request.getAttribute("admin_remove_button");
    boolean bAdminRemoveGroup = (adminRemoveGroup == null ? false : adminRemoveGroup.booleanValue());

    Boolean policy = (Boolean) request.getAttribute("policy_button");
    boolean bPolicy = (policy == null ? false : policy.booleanValue());

    Boolean delete = (Boolean) request.getAttribute("delete_button");
    boolean bDelete = (delete == null ? false : delete.booleanValue());

    String name = "";
    String shortDesc = "";
    String intro = "";
    String copy = "";
    String side = "";
    Group admins = null;

    Bitstream logo = null;

    if (community != null) {
        name = community.getMetadata("name");
        shortDesc = community.getMetadata("short_description");
        intro = community.getMetadata("introductory_text");
        copy = community.getMetadata("copyright_text");
        side = community.getMetadata("side_bar_text");
        logo = community.getLogo();
        admins = community.getAdministrators();
    }

    //o padrão é o endereço da lista de comunidades.
    String titulo = "jsp.community-list.title";
    String linkTit = "/community-list";
    if (community != null) {
        titulo = community.getName(); //nome da comunidade
        linkTit = "/handle/" + community.getHandle(); //handle (endereço) da comunidade
    }
%>

<dspace:layout titlekey="jsp.tools.edit-community.title"
                parentlink="<%= linkTit%>"
                parenttitlekey="<%=titulo%>"
                navbar="admin"
                locbar="link"
                nocache="false">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/edit-col-com.css" type="text/css"/>


    <table width="95%">
        <tr>
            <td align="left">
                <%
                    if (community == null) {
                %>
                <h1><fmt:message key="jsp.tools.edit-community.heading1"/></h1>
                <%} else {
                %>
                <h1><fmt:message key="jsp.tools.edit-community.heading2">
                        <fmt:param><%= community.getHandle()%></fmt:param>
                    </fmt:message>
                </h1>

                <%
                    }
                %>
            </td>
        </tr>
    </table>

    <form method="post" action="">
        <div class="fundo">
            <table class="metadados">
                <tr>
                    <th colspan="2"><fmt:message key="jsp.tools.edit-community.heading3"/></th>
                </tr>
                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label1"/></td>
                    <td><input type="text" name="name" value="<%= Utils.addEntities(name)%>" size="50" /></td>
                </tr>
                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label2"/></td>
                    <td>
                        <input type="text" name="short_description" value="<%= Utils.addEntities(shortDesc)%>" size="50" />
                    </td>
                </tr>
                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label3"/></td>
                    <td>
                        <textarea name="introductory_text" rows="6" cols="50"><%= Utils.addEntities(intro)%></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label4"/></td>
                    <td>
                        <textarea name="copyright_text" rows="6" cols="50"><%= Utils.addEntities(copy)%></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label5"/></td>
                    <td>
                        <textarea name="side_bar_text" rows="6" cols="50"><%= Utils.addEntities(side)%></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="submitFormLabel">
                        <fmt:message key="jsp.tools.edit-community.form.label6"/>
                    </td>
                    <td>
                        <div id="logomarca">
                            <%  if (logo != null) {%>
                            <img src="<%= request.getContextPath()%>/retrieve/<%= logo.getID()%>" alt="logo" />
                            <input type="submit" class="button" name="submit_set_logo" value="<fmt:message key="jsp.tools.edit-community.form.button.add-logo"/>" />
                            <input type="submit" class="buttonRed" name="submit_delete_logo" value="<fmt:message key="jsp.tools.edit-community.form.button.delete-logo"/>" />

                            <%  } else {%>
                            <input type="submit" class="button" name="submit_set_logo" value="<fmt:message key="jsp.tools.edit-community.form.button.set-logo"/>" />
                            <%  }%>
                        </div>
                    </td>
                </tr>


                <% if (bAdminCreateGroup || (admins != null && bAdminRemoveGroup)) {%>
                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label8"/></td>
                    <td>
                        <%  if (admins == null) {
                                if (bAdminCreateGroup) {
                        %>
                        <input class="button" type="submit" name="submit_admins_create" value="<fmt:message key="jsp.tools.edit-community.form.button.create"/>" />
                        <%  	}
                        } else {
                            if (bAdminCreateGroup) {%>
                        <input class="button" type="submit" name="submit_admins_edit" value="<fmt:message key="jsp.tools.edit-community.form.button.edit"/>" />
                        <%  }
                                    if (bAdminRemoveGroup) {%>
                        <input class="buttonRed" type="submit" name="submit_admins_remove" value="<fmt:message key="jsp.tools.edit-community.form.button.remove"/>" />
                        <%  	}
                            }
                        %>
                    </td>
                </tr>

                <% }

                    if (bPolicy) {

                %>

                <tr>
                    <td class="submitFormLabel"><fmt:message key="jsp.tools.edit-community.form.label7"/></td>
                    <td>
                        <input type="submit" class="button" name="submit_authorization_edit" value="<fmt:message key="jsp.tools.edit-community.form.button.edit"/>" />
                    </td>
                </tr>
                <% }%>
            </table>
        </div>


        <div class="esquerda">
            <%
                if (community == null) {
            %>
            <input type="hidden" name="parent_community_id" value="<%= parentID%>" />
            <input type="hidden" name="create" value="true" />
            <input type="submit" class="buttonGreen" name="submit" value="<fmt:message key="jsp.tools.edit-community.form.button.create"/>" />

            <input type="hidden" name="parent_community_id" value="<%= parentID%>" />
            <input type="hidden" name="action" value="<%= EditCommunitiesServlet.CONFIRM_EDIT_COMMUNITY%>" />
            <input type="submit" class="button" name="submit_cancel" value="<fmt:message key="jsp.tools.edit-community.form.button.cancel"/>" />
            <%
            } else {
            %>
            <input type="hidden" name="community_id" value="<%= community.getID()%>" />
            <input type="hidden" name="create" value="false" />
            <input type="submit" class="buttonGreen" name="submit" value="<fmt:message key="jsp.tools.edit-community.form.button.update"/>" />

            <input type="hidden" name="community_id" value="<%= community.getID()%>" />
            <input type="hidden" name="action" value="<%= EditCommunitiesServlet.CONFIRM_EDIT_COMMUNITY%>" />
            <input type="submit" class="button" name="submit_cancel" value="<fmt:message key="jsp.tools.edit-community.form.button.cancel"/>" />
            <%
                }
            %>
        </div>

    </form>


    <div id="controles">
        <div class="direita">
            <% if (bDelete) {%>
            <form method="post" action="">
                <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_DELETE_COMMUNITY%>" />
                <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                <input type="submit" class="buttonRed" name="submit" value="<fmt:message key="jsp.tools.edit-community.button.delete"/>" />

                <% }%>
        </div>
    </div>

</dspace:layout>