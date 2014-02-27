<%--
  - main.jsp
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

<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%--
  - Main My DSpace page
  -
  -
  - Attributes:
  -    mydspace.user:    current user (EPerson)
  -    workspace.items:  WorkspaceItem[] array for this user
  -    workflow.items:   WorkflowItem[] array of submissions from this user in
  -                      workflow system
  -    workflow.owned:   WorkflowItem[] array of tasks owned
  -    workflow.pooled   WorkflowItem[] array of pooled tasks
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page  import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.content.SupervisedItem" %>
<%@ page import="org.dspace.content.WorkspaceItem" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.eperson.Group"   %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>
<%@ page import="java.util.List" %>

<%
    EPerson user = (EPerson) request.getAttribute("mydspace.user");

    WorkspaceItem[] workspaceItems =
            (WorkspaceItem[]) request.getAttribute("workspace.items");

    WorkflowItem[] workflowItems =
            (WorkflowItem[]) request.getAttribute("workflow.items");

    WorkflowItem[] owned =
            (WorkflowItem[]) request.getAttribute("workflow.owned");

    WorkflowItem[] pooled =
            (WorkflowItem[]) request.getAttribute("workflow.pooled");

    Group[] groupMemberships =
            (Group[]) request.getAttribute("group.memberships");

    SupervisedItem[] supervisedItems =
            (SupervisedItem[]) request.getAttribute("supervised.items");

    List<String> exportsAvailable = (List<String>) request.getAttribute("export.archives");

    // Is the logged in user an admin
    Boolean displayMembership = (Boolean) request.getAttribute("display.groupmemberships");
    boolean displayGroupMembership = (displayMembership == null ? false : displayMembership.booleanValue());

    //Toda vez que o usuário faz login, armazenamos o seu nome completo como um atributo, para que todas as páginas
    //tenha acesso a ele. Assim, podemos exibir o nome do usuário em todas as páginas que possuem a barra de navegação.
    session.setAttribute("nome_usuario", user.getFullName());

    //Verifica se o usuário estava fazendo alguma coisa importante antes de logar.

    //Se o usuário estava fazendo uma aprovação de cadastro
    String aprovacao = request.getParameter("fazendo_aprovacao");
    if (aprovacao != null) {
        String id = (String) request.getParameter("id_user");
        response.sendRedirect(request.getContextPath() + "/register/aprovacao.jsp?id_user=" + id);
    }

%>

<dspace:layout titlekey="jsp.mydspace" nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>

    <h1><fmt:message key="jsp.mydspace"/> &#8212; <%= user.getFullName()%></h1>

    <div style="text-align: center;">
        <form action="<%= request.getContextPath()%>/mydspace" method="post">
            <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>" />
            <input type="submit" class="button" name="submit_new" value="<fmt:message key="jsp.mydspace.main.start.button"/>" />
            <input type="submit" class="button" name="submit_own" value="<fmt:message key="jsp.mydspace.main.view.button"/>" />
            <a href="<%= request.getContextPath()%>/subscribe" class="button"><fmt:message key="jsp.mydspace.main.link"/></a>
        </form>
    </div>

    <%
        //                                          TAREFAS NA ÁREA DE TRABALHO
        // Pooled tasks - only show if there are any
        if (pooled.length > 0) {
    %>
    <div>
        <%--
        <p>
            <fmt:message key="jsp.mydspace.main.text2"/>
        </p>
        --%>

        <table class="tabela" summary="Table listing the tasks in the pool">
            <tr class="tituloTabela">
                <td colspan="5"><fmt:message key="jsp.mydspace.main.heading3"/></td>
            </tr>
            <tr>
                <th id="t6"><fmt:message key="jsp.mydspace.main.task"/></th>
                <th id="t7"><fmt:message key="jsp.mydspace.main.item"/></th>
                <th id="t8"><fmt:message key="jsp.mydspace.main.subto"/></th>
                <th id="t9"><fmt:message key="jsp.mydspace.main.subby"/></th>
                <th id="t9"><fmt:message key="jsp.mydspace.main.acao"/></th>
            </tr>
            <%
                for (int i = 0; i < pooled.length; i++) {
                    DCValue[] titleArray = pooled[i].getItem().getDC("title", null, Item.ANY);
                    String title = (titleArray.length > 0 ? titleArray[0].value : LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.untitled"));
                    EPerson submitter = pooled[i].getItem().getSubmitter();
                    if (i % 2 == 0) {
            %>
            <tr>
                <%                } else {
                %>
            <tr class="stripe">
                <%                    }
                %>
                <td headers="t6">
                    <%
                        switch (pooled[i].getState()) {
                            case WorkflowManager.WFSTATE_STEP1POOL:%><fmt:message key="jsp.mydspace.main.sub1"/><% break;
                                case WorkflowManager.WFSTATE_STEP2POOL:%><fmt:message key="jsp.mydspace.main.sub2"/><% break;
                        case WorkflowManager.WFSTATE_STEP3POOL:%><fmt:message key="jsp.mydspace.main.sub3"/><% break;
                    }
                    %>
                </td>
                <td headers="t7"><%= Utils.addEntities(title)%></td>
                <td headers="t8"><%= pooled[i].getCollection().getMetadata("name")%></td>
                <td headers="t9"><a href="mailto:<%= submitter.getEmail()%>"><%= submitter.getFullName()%></a></td>
                <td>
                    <form action="<%= request.getContextPath()%>/mydspace" method="post">
                        <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>" />
                        <input type="hidden" name="workflow_id" value="<%= pooled[i].getID()%>" />
                        <input type="submit" class="button" name="submit_claim" value="<fmt:message key="jsp.mydspace.main.take.button"/>" />
                    </form>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    </div>
    <%
        }
    %>


    <%-- Task list:  Only display if the user has any tasks --%>
    <%//                                            TAREFAS APROPRIADAS
        if (owned.length > 0) {
    %>
    <%--
    <p class="submitFormHelp">
        <fmt:message key="jsp.mydspace.main.text1"/>
    </p>
    --%>

    <table class="tabela" align="center" summary="Table listing owned tasks">
        <tr class="tituloTabela">
            <td colspan="6"><fmt:message key="jsp.mydspace.main.heading2"/></td>
        </tr>
        <tr>
            <th id="t1"><fmt:message key="jsp.mydspace.main.task"/></th>
            <th id="t2"><fmt:message key="jsp.mydspace.main.item"/></th>
            <th id="t3"><fmt:message key="jsp.mydspace.main.subto"/></th>
            <th id="t4"><fmt:message key="jsp.mydspace.main.subby"/></th>
            <th id="t5" colspan="2"><fmt:message key="jsp.mydspace.main.acao"/></th>
        </tr>
        <%
            for (int i = 0; i < owned.length; i++) {
                DCValue[] titleArray =
                        owned[i].getItem().getDC("title", null, Item.ANY);
                String title = (titleArray.length > 0 ? titleArray[0].value
                        : LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.untitled"));
                EPerson submitter = owned[i].getItem().getSubmitter();
                if (i % 2 == 0) {
        %>
        <tr>
            <%
                } else {
            %>
        <tr class="stripe">
            <%
                }
            %>
            <td headers="t1">
                <%
                    switch (owned[i].getState()) {

                        //There was once some code...
                        case WorkflowManager.WFSTATE_STEP1:%><fmt:message key="jsp.mydspace.main.sub1"/><% break;
                            case WorkflowManager.WFSTATE_STEP2:%><fmt:message key="jsp.mydspace.main.sub2"/><% break;
                                case WorkflowManager.WFSTATE_STEP3:%><fmt:message key="jsp.mydspace.main.sub3"/><% break;
                                                        }
                %>
            </td>
            <td headers="t2"><%= Utils.addEntities(title)%></td>
            <td headers="t3"><%= owned[i].getCollection().getMetadata("name")%></td>
            <td headers="t4"><a href="mailto:<%= submitter.getEmail()%>"><%= submitter.getFullName()%></a></td>
            <td headers="t5">
                <form action="<%= request.getContextPath()%>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>" />
                    <input type="hidden" name="workflow_id" value="<%= owned[i].getID()%>" />
                    <input type="submit" name="submit_perform" class="button" value="<fmt:message key="jsp.mydspace.main.perform.button"/>" />
                </form>
            </td>
            <td headers="t5">
                <form action="<%= request.getContextPath()%>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>" />
                    <input type="hidden" name="workflow_id" value="<%= owned[i].getID()%>" />
                    <input type="submit" name="submit_return" class="button" value="<fmt:message key="jsp.mydspace.main.return.button"/>" />
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        }

    %>



    <%
        //                                              SUBMISSÕES EM PROCESSO
        // Display workspace items (authoring or supervised), if any
        if (workspaceItems.length > 0 || supervisedItems.length > 0) {
    %>
    <%--
    <p><fmt:message key="jsp.mydspace.main.text4" /></p>
    --%>

    <table class="tabela" align="center" summary="Table listing unfinished submissions">
        <tr class="tituloTabela">
            <td colspan="5"><fmt:message key="jsp.mydspace.main.heading4"/></td>
        </tr>
        <tr>
            <th id="t10"><fmt:message key="jsp.mydspace.main.subby"/></th>
            <th id="t11"><fmt:message key="jsp.mydspace.main.elem1"/></th>
            <th id="t12"><fmt:message key="jsp.mydspace.main.subto"/></th>
            <th id="t13" colspan="2"><fmt:message key="jsp.mydspace.main.acao"/></th>
        </tr>
        <%
            if (supervisedItems.length > 0 && workspaceItems.length > 0) {
        %>
        <tr>
            <th colspan="5">
                <%-- Authoring --%>
                <fmt:message key="jsp.mydspace.main.authoring" />
            </th>
        </tr>
        <%
            }
            for (int i = 0; i < workspaceItems.length; i++) {
                DCValue[] titleArray =
                        workspaceItems[i].getItem().getDC("title", null, Item.ANY);
                String title = (titleArray.length > 0 ? titleArray[0].value
                        : LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.untitled"));
                EPerson submitter = workspaceItems[i].getItem().getSubmitter();
        if (i % 2 == 0) {
        %>
        <tr>
            <%
                } else {
            %>
        <tr class="stripe">
            <%
                }
            %>
            <td headers="t10">
                <a href="mailto:<%= submitter.getEmail()%>"><%= submitter.getFullName()%></a>
            </td>
            <td headers="t11"><%= Utils.addEntities(title)%></td>
            <td headers="t12"><%= workspaceItems[i].getCollection().getMetadata("name")%></td>
            <td>
                <form action="<%= request.getContextPath()%>/workspace" method="post">
                    <input type="hidden" name="workspace_id" value="<%= workspaceItems[i].getID()%>"/>
                    <input type="submit" name="submit_open" class="button" value="<fmt:message key="jsp.mydspace.general.open" />"/>
                </form>
            </td>
            <td headers="t13">
                <form action="<%= request.getContextPath()%>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>"/>
                    <input type="hidden" name="workspace_id" value="<%= workspaceItems[i].getID()%>"/>
                    <input type="submit" class="buttonRed" name="submit_delete" value="<fmt:message key="jsp.mydspace.general.remove" />"/>
                </form>
            </td>
        </tr>
        <%
            }
        %>

        <%-- Start of the Supervisors workspace list --%>
        <%
            if (supervisedItems.length > 0) {
        %>
        <tr class="destaque">
            <td colspan="5">
                <fmt:message key="jsp.mydspace.main.supervising" />
            </td>
        </tr>
        <%    }

            for (int i = 0; i < supervisedItems.length; i++) {
                DCValue[] titleArray =
                        supervisedItems[i].getItem().getDC("title", null, Item.ANY);
                String title = (titleArray.length > 0 ? titleArray[0].value
                        : LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.untitled"));
                EPerson submitter = supervisedItems[i].getItem().getSubmitter();
        if (i % 2 == 0) {
        %>
        <tr class="stripe">
            <%
                } else {
            %>
        <tr>
            <%
                }
            %>
            <td>
                <form action="<%= request.getContextPath()%>/workspace" method="post">
                    <input type="hidden" name="workspace_id" value="<%= supervisedItems[i].getID()%>"/>
                    <input type="submit" class="button" name="submit_open" value="<fmt:message key="jsp.mydspace.general.open" />"/>
                </form>
            </td>
            <td>
                <a href="mailto:<%= submitter.getEmail()%>"><%= submitter.getFullName()%></a>
            </td>
            <td><%= Utils.addEntities(title)%></td>
            <td><%= supervisedItems[i].getCollection().getMetadata("name")%></td>
            <td>
                <form action="<%= request.getContextPath()%>/mydspace" method="post">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>"/>
                    <input type="hidden" name="workspace_id" value="<%= supervisedItems[i].getID()%>"/>
                    <input type="submit" class="button" name="submit_delete" value="<fmt:message key="jsp.mydspace.general.remove" />"/>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
    <%
        }
    %>


    <%
        //                            SUBMISSÕES EM ANDAMENTO NO FLUXO DE SUBMISSÃO
        // Display workflow items, if any
        if (workflowItems.length > 0) {
    %>
    <table class="tabela" align="center" summary="Table listing submissions in workflow process">
        <tr class="tituloTabela">
            <td colspan="5"><fmt:message key="jsp.mydspace.main.heading5"/></td>
        </tr>
        <tr>
            <th id="t14"><fmt:message key="jsp.mydspace.main.elem1"/></th>
            <th id="t15"><fmt:message key="jsp.mydspace.main.subto"/></th>
        </tr>
        <%
            for (int i = 0; i < workflowItems.length; i++) {
                DCValue[] titleArray =
                        workflowItems[i].getItem().getDC("title", null, Item.ANY);
                String title = (titleArray.length > 0 ? titleArray[0].value
                        : LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.untitled"));
        if (i % 2 == 0) {
        %>
        <tr>
            <%
                } else {
            %>
        <tr class="stripe">
            <%
                }
            %>
            <td headers="t14"><%= Utils.addEntities(title)%></td>
            <td headers="t15">
                <form action="<%= request.getContextPath()%>/mydspace" method="post">
                    <%= workflowItems[i].getCollection().getMetadata("name")%>
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>" />
                    <input type="hidden" name="workflow_id" value="<%= workflowItems[i].getID()%>" />
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>


    <%
        }

        //                             GRUPO DE AUTORIZAÇÃO DAS QUAIS SOU MEMBRO
        if (displayGroupMembership && groupMemberships.length > 0) {
    %>
    <h2><fmt:message key="jsp.mydspace.main.heading6"/></h2>
    <ul>
        <%
            for (int i = 0; i < groupMemberships.length; i++) {
        %>
        <li><%=groupMemberships[i].getName()%></li>
        <%
            }
        %>
    </ul>
    <%
        }
    %>



    <%
        //                                       MEUS ITENS EXPORTADOS
        if (exportsAvailable != null && exportsAvailable.size() > 0) {
    %>
    <table class="tabela">
        <tr class="tituloTabela">
            <td>
                <fmt:message key="jsp.mydspace.main.heading7"/>
            </td>
        </tr>
        <%
        boolean listrado = false;
        for (String fileName : exportsAvailable) {
    if (listrado) {
        %>
        <tr>
            <%
                } else {
            %>
        <tr class="stripe">
            <%
                }
            %>
        <td>
            <a href="<%=request.getContextPath() + "/exportdownload/" + fileName%>"
               title="<fmt:message key="jsp.mydspace.main.export.archive.title"><fmt:param><%= fileName%></fmt:param></fmt:message>">
                <%=fileName%>
            </td>
            </tr>
        <%
        listrado = !listrado;
        }
%>
    </table>
    <%
        }
%>

</dspace:layout>
