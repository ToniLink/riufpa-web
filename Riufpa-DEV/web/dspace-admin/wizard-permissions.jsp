<%--
  - wizard-permissions.jsp
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
  - set up a group with particular permissions
  -
  - attributes:
  -    collection - collection we're creating
  -    permission - one of the constants starting PERM_ at the top of
  -                 org.dspace.app.webui.servlet.admin.CollectionWizardServlet
--%>



<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.app.webui.servlet.admin.CollectionWizardServlet" %>
<%@ page import="org.dspace.content.Collection" %>

<%
    Collection collection = (Collection) request.getAttribute("collection");
    int perm = ((Integer) request.getAttribute("permission")).intValue();
    boolean mitGroup = (request.getAttribute("mitgroup") != null);
%>

<dspace:layout locbar="off"
               navbar="off"
               titlekey="jsp.dspace-admin.wizard-permissions.title"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/group-edit.css" type="text/css"/>

<div class="painel">
    <%
        switch (perm) {
            case CollectionWizardServlet.PERM_READ:
    %>
    <%-- <h1>Authorization to Read</h1> --%>
    <h2><fmt:message key="jsp.dspace-admin.wizard-permissions.heading1"/></h2>

    <%-- <p>Who has (by default) permission to read new items submitted to this collection? --%>
    <div class="msg">
        <fmt:message key="jsp.dspace-admin.wizard-permissions.text1"/>
    </div>
    <%
            break;

        case CollectionWizardServlet.PERM_SUBMIT:
    %>
    <%-- <h1>Authorization to Submit</h1> --%>
    <h2><fmt:message key="jsp.dspace-admin.wizard-permissions.heading2"/></h2>

    <%-- <p>Who has permission to submit new items to this collection? --%>
    <div class="msg">
        <fmt:message key="jsp.dspace-admin.wizard-permissions.text2"/>
    </div>
    <%
            break;

        case CollectionWizardServlet.PERM_WF1:
    %>
    <%-- <h1>Submission Workflow Accept/Reject Step</h1> --%>
    <h2><fmt:message key="jsp.dspace-admin.wizard-permissions.heading3"/></h2>

    <%-- <p>Who is responsible for performing the <strong>accept/reject</strong> step?
    They will be able to accept or reject incoming submissions.  They will not be
    able to edit the submission's metadata, however.  Only one of the group need perform the step
    for each submission. --%>
    <div class="msg">
        <fmt:message key="jsp.dspace-admin.wizard-permissions.text3"/>
    </div>
    <%
            break;

        case CollectionWizardServlet.PERM_WF2:
    %>
    <%-- <h1>Submission Workflow Accept/Reject/Edit Metadata Step</h1> --%>
    <h2><fmt:message key="jsp.dspace-admin.wizard-permissions.heading4"/></h2>

    <%-- <p>Who is responsible for performing the <strong>accept/reject/edit metadata</strong> step?
            They will be able to edit the metadata of incoming submissions, and then accept
            or reject them.  Only one of the group need perform the step for each submission. --%>
    <div class="msg">
        <fmt:message key="jsp.dspace-admin.wizard-permissions.text4"/>
    </div>
    <%
            break;

        case CollectionWizardServlet.PERM_WF3:
    %>
    <%-- <h1>Submission Workflow Edit Metadata Step</h1> --%>
    <h2><fmt:message key="jsp.dspace-admin.wizard-permissions.heading5"/></h2>

    <%-- <p>Who is responsible for performing the <strong>edit metadata</strong> step?
    They will be able to edit the metadata of incoming submissions, but will not
    be able to reject them.</p>--%>
    <div class="msg">
        <fmt:message key="jsp.dspace-admin.wizard-permissions.text5"/>
    </div>
        <%
                break;

            case CollectionWizardServlet.PERM_ADMIN:
        %>
        <%-- <h1>Delegated Collection Administrators</h1> --%>
    <h2><fmt:message key="jsp.dspace-admin.wizard-permissions.heading6"/></h2>

    <%-- <p>Who are the collection administrators for this collection?  They will be able to decide who can submit items
to the collection, withdraw items, edit item metadata (after submission), and add (map) existing items from
other collections to this collection (subject to authorization from that collection).</p>--%>
    <div class="msg">
        <fmt:message key="jsp.dspace-admin.wizard-permissions.text6"/>
    </div>
    <%
                break;
        }
    %>

        <div class="msg-mini">
            <fmt:message key="jsp.dspace-admin.wizard-permissions.change"/>
        </div>

    <form name="epersongroup" action="<%= request.getContextPath()%>/tools/collection-wizard" method="post">
            <table>
                <%
                    // MIT group checkbox - only if there's an MIT group and on the READ and SUBMIT pages
                    // (Sorry, everyone who isn't running DSpace at MIT, I know this isn't very elegant!)

                    if (mitGroup
                            && (perm == CollectionWizardServlet.PERM_READ || perm == CollectionWizardServlet.PERM_SUBMIT)) {
                %>
                <tr>
                    <td></td>
                    <%-- 	<td><input type="checkbox" name="mitgroup" value="true" />&nbsp;<span class="submitFormLabel">All MIT users</span> --%>
                    <td><input type="checkbox" name="mitgroup" value="true"/>&nbsp;<span class="submitFormLabel"><fmt:message key="jsp.dspace-admin.wizard-permissions.mit"/></span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <%-- <td colspan="2" class="submitFormHelp"><strong>OR</strong></td> --%>
                    <td colspan="2" class="submitFormHelp"><strong><fmt:message key="jsp.dspace-admin.wizard-permissions.or"/></strong></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <%    }
                %>

                <tr>
                    <td colspan="2">
                        <table>
                            <tr>
                                <td>
                                    <%--<dspace:selecteperson multiple="true" />--%>
                                    <%--Lista com os membros do grupo--%>
                                    <select size="10" name="eperson_id" multiple="multiple"></select>

                                    <input type="button" class="button"
                                           value="<fmt:message key='org.dspace.app.webui.jsptag.SelectEPersonTag.selectPerson'/>"
                                           onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/tools/eperson-list?multiple=true', width: largura, height: altura, animate: false});" />
                                    <input type="button" class="button"
                                           value="<fmt:message key='org.dspace.app.webui.jsptag.SelectEPersonTag.removeSelected'/>"
                                           onclick="javascript:removeSelected(window.document.epersongroup.eperson_id);" />
                                </td>

                                <td>
                                    <%--<dspace:selectgroup multiple="true" />--%>
                                    <select size="10" name="group_ids" multiple="multiple"></select>
                                    <input type="button" class="button"
                                            value="<fmt:message key='org.dspace.app.webui.jsptag.SelectGroupTag.selectGroup'/>"
                                            onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/tools/group-select-list?multiple=true', width: largura, height: altura, animate: false});" />
                                     <input type="button" class="button"
                                            value="<fmt:message key='org.dspace.app.webui.jsptag.SelectGroupTag.removeSelected'/>"
                                            onclick="javascript:removeSelected(window.document.epersongroup.group_ids);" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

        <%-- Hidden fields needed for servlet to know which collection and page to deal with --%>
        <input type="hidden" name="collection_id" value="<%= ((Collection) request.getAttribute("collection")).getID()%>" />
        <input type="hidden" name="stage" value="<%= CollectionWizardServlet.PERMISSIONS%>" />
        <input type="hidden" name="permission" value="<%= perm%>" />

        <div class="controles">
            <input type="submit" class="button" name="submit_next" value="<fmt:message key="jsp.dspace-admin.general.next.button"/>"
                   onclick="javascript:finishEPerson(); finishGroups();"/>
        </div>

    </form>
    </div>

</dspace:layout>
