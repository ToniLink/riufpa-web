<%--
  - perform-task.jsp
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
  - Perform task page
  -
  - Attributes:
  -    workflow.item: The workflow item for the task being performed
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>

<%
    WorkflowItem workflowItem =
            (WorkflowItem) request.getAttribute("workflow.item");

    Collection collection = workflowItem.getCollection();
    Item item = workflowItem.getItem();
%>

<dspace:layout locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace.perform-task.title"
               nocache="true">

    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/mydspace.css"/>

    <h1><fmt:message key="jsp.mydspace.perform-task.title"/></h1>

    <%
        if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1) {
    %>
    <p>
        
        <fmt:message key="jsp.mydspace.perform-task.text1">
            <fmt:param><%= collection.getMetadata("name")%></fmt:param>
        </fmt:message>
    </p>
    <%
    } else if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP2) {
    %>
    <p>
        <fmt:message key="jsp.mydspace.perform-task.text3">
            <fmt:param><%= collection.getMetadata("name")%></fmt:param>
        </fmt:message>
    </p>
    <%
    } else if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP3) {
    %>
    <p>
        <fmt:message key="jsp.mydspace.perform-task.text4">
            <fmt:param><%= collection.getMetadata("name")%></fmt:param>
        </fmt:message>
    </p>
    <%
        }
    %>

    <dspace:item item="<%= item%>" />


    <script type="text/javascript">
        function bloquearBotao() {
            $("fakeapprove").disabled = true;
            $("submit_approve").click();
            $("fakeapprove").removeClassName("button");
            $("fakeapprove").addClassName("buttonDisabled");
        }
    </script>

    <form action="<%= request.getContextPath()%>/mydspace" method="post">
        <input type="hidden" name="workflow_id" value="<%= workflowItem.getID()%>"/>
        <input type="hidden" name="step" value="<%= MyDSpaceServlet.PERFORM_TASK_PAGE%>"/>

        <table class="tabela">
            <tr class="tituloTabela">
                <td colspan="2">
                    <fmt:message key="jsp.mydspace.perform-task.options"/>
                </td>
            </tr>
            <tr>
                <th>
                    <fmt:message key="jsp.mydspace.perform-task.description"/>
                </th>
                <th>
                    <fmt:message key="jsp.mydspace.perform-task.action"/>
                </th>
            </tr>
            <%
                boolean stripe = false;
                if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1
                        || workflowItem.getState() == WorkflowManager.WFSTATE_STEP2) {
            %>
            <tr <% if (stripe) {%> class="stripe" <%}
                stripe = !stripe;%> >
                <td>
                    <fmt:message key="jsp.mydspace.perform-task.instruct1"/>
                </td>
                <td>
                    <input style="display: none;" type="submit" name="submit_approve" id="submit_approve" value="<fmt:message key="jsp.mydspace.general.approve"/>" />

                    <%--
                    Para evitar que o formulário seja submetido mais de uma vez, este botão falso clica no botão de submissão
                    verdadeiro ('submit_approve'). O botão falso só pode ser clicado uma vez, logo o botão verdadeiro
                    só pode ser chamado uma vez também. Embora a solução mais simples seria desativar o botão verdadeiro
                    assim que ele fosse clicado, isso faria com que o servlet não reconhecesse qual botão foi clicado, e
                    assim sempre executaria a ação padrão que é 'cancelar'.
                    --%>
                    <input class="button" type="submit" name="fakeapprove" id="fakeapprove" onclick="bloquearBotao();" value="<fmt:message key="jsp.mydspace.general.approve"/>" />
                </td>
            </tr>
            <%
            } else {
                // Must be an editor (step 3)
%>
            <tr <% if (stripe) {%> class="stripe" <%}
                stripe = !stripe;%> >
                <td>
                    <fmt:message key="jsp.mydspace.perform-task.instruct2"/>
                </td>
                <td>
                    <input style="display: none;" type="submit" name="submit_approve" id="submit_approve" value="<fmt:message key="jsp.mydspace.perform-task.commit.button"/>" />
                    <%-- Ver comentário acima. --%>
                    <input class="button" type="submit" name="fakeapprove" id="fakeapprove" onclick="bloquearBotao();" value="<fmt:message key="jsp.mydspace.perform-task.commit.button"/>" />
                </td>
            </tr>
            <%    }

                if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1
                        || workflowItem.getState() == WorkflowManager.WFSTATE_STEP2) {
            %>
            <tr <% if (stripe) {%> class="stripe" <%}
                stripe = !stripe;%> >
                <td>
                    <fmt:message key="jsp.mydspace.perform-task.instruct3"/>
                </td>
                <td>
                    <input class="button" type="submit" name="submit_reject" value="<fmt:message key="jsp.mydspace.general.reject"/>"/>
                </td>
            </tr>
            <%    }

                if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP2
                        || workflowItem.getState() == WorkflowManager.WFSTATE_STEP3) {
            %>
            <tr <% if (stripe) {%> class="stripe" <%}
                stripe = !stripe;%> >
                <td>
                    <fmt:message key="jsp.mydspace.perform-task.instruct4"/>
                </td>
                <td>
                    <input class="button" type="submit" name="submit_edit" value="<fmt:message key="jsp.mydspace.perform-task.edit.button"/>" />
                </td>
            </tr>
            <%    }
            %>
            <tr <% if (stripe) {%> class="stripe" <%}
                stripe = !stripe;%> >
                <td>
                    <fmt:message key="jsp.mydspace.perform-task.instruct5"/>
                </td>
                <td>
                    <input class="button" type="submit" name="submit_cancel" value="<fmt:message key="jsp.mydspace.perform-task.later.button"/>" />
                </td>
            </tr>
            <tr <% if (stripe) {%> class="stripe" <%}
                stripe = !stripe;%> >
                <td>
                    <fmt:message key="jsp.mydspace.perform-task.instruct6"/>
                </td>
                <td>
                    <input class="button" type="submit" name="submit_pool" value="<fmt:message key="jsp.mydspace.perform-task.return.button"/>" />
                </td>
            </tr>
        </table>
    </form>
</dspace:layout>
