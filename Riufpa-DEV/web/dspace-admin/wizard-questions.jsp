<%--
  - wizard-questions.jsp
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
  - initial questions page for collection creation wizard
  -
  - attributes:
  -    collection - collection we're creating
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.app.webui.servlet.admin.CollectionWizardServlet" %>
<%@ page import="org.dspace.content.Collection" %>

<%  Collection collection = (Collection) request.getAttribute("collection");%>

<%  Boolean sysadmin_b = (Boolean) request.getAttribute("sysadmin_button");
    boolean sysadmin_button = (sysadmin_b == null ? false : sysadmin_b.booleanValue());

    Boolean adminCreateGroup = (Boolean) request.getAttribute("admin_create_button");
    boolean bAdminCreateGroup = (adminCreateGroup == null ? false : adminCreateGroup.booleanValue());

    Boolean workflowsButton = (Boolean) request.getAttribute("workflows_button");
    boolean bWorkflowsButton = (workflowsButton == null ? false : workflowsButton.booleanValue());

    Boolean submittersButton = (Boolean) request.getAttribute("submitters_button");
    boolean bSubmittersButton = (submittersButton == null ? false : submittersButton.booleanValue());

    Boolean templateButton = (Boolean) request.getAttribute("template_button");
    boolean bTemplateButton = (templateButton == null ? false : templateButton.booleanValue());
%>

<dspace:layout locbar="off"
               navbar="off"
               titlekey="jsp.dspace-admin.wizard-questions.title"
               nocache="true">

    <div class="painel">
        <h2>
            <fmt:message key="jsp.dspace-admin.wizard-questions.title"/>
        </h2>

        <div class="msg">
            <fmt:message key="jsp.dspace-admin.wizard-questions.text"/>
        </div>

        <form action="<%= request.getContextPath()%>/tools/collection-wizard" method="post">

            <ul>

                <li>
                    <% if (!sysadmin_button) {%>
                    <input type="hidden" name="public_read" value="true"/>
                    <input type="checkbox" name="public_read" id="public_read" value="true" disabled="disabled" checked="checked"/>
                    <% } else {%>
                    <input type="checkbox" name="public_read" id="public_read" value="true" checked="checked"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>New items should be publicly readable</td> --%>
                    <label for="public_read">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check1"/>
                    </label>
                    <% if (!sysadmin_button) {%>
                    <label for="public_read">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check1-disabled"/>
                    </label>
                    <% }%>
                </li>


                <li>
                    <% if (!bSubmittersButton) {%>
                    <input type="hidden" name="submitters" value="false" />
                    <input type="checkbox" name="submitters" id="submitters" value="true" disabled="disabled"/>
                    <% } else {%>
                    <input type="checkbox" name="submitters" id="submitters" value="true" checked="checked"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>Some users will be able to submit to this collection</td> --%>
                    <label for="submitters">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check2"/>
                    </label>
                </li>

                <li>
                    <% if (!bWorkflowsButton) {%>
                    <input type="hidden" name="workflow1" value="false" />
                    <input type="checkbox" name="workflow1" id="workflow1" value="true" disabled="disabled"/>
                    <% } else {%>
                    <input type="checkbox" name="workflow1" id="workflow1" value="true"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>The submission workflow will include an <em>accept/reject</em> step</td> --%>
                    <label for="workflow1">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check3"/>
                    </label>
                </li>

                <li>
                    <% if (!bWorkflowsButton) {%>
                    <input type="hidden" name="workflow2" value="false" />
                    <input type="checkbox" name="workflow2" id="workflow2" value="true" disabled="disabled"/>
                    <% } else {%>
                    <input type="checkbox" name="workflow2" id="workflow2" value="true" checked="checked"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>The submission workflow will include an <em>accept/reject/edit metadata</em> step</td> --%>
                    <label for="workflow2">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check4"/>
                    </label>
                </li>

                <li>
                    <% if (!bWorkflowsButton) {%>
                    <input type="hidden" name="workflow3" value="false" />
                    <input type="checkbox" name="workflow3" id="workflow3" value="true" disabled="disabled"/>
                    <% } else {%>
                    <input type="checkbox" name="workflow3" id="workflow3" value="true"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>The submission workflow will include an <em>edit metadata</em> step</td> --%>
                    <label for="workflow3">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check5"/>
                    </label>
                </li>

                <li>
                    <% if (!bAdminCreateGroup) {%>
                    <input type="hidden" name="admins" value="false" />
                    <input type="checkbox" name="admins" id="admins" value="true" disabled="disabled"/>
                    <% } else {%>
                    <input type="checkbox" name="admins" id="admins" value="true"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>This collection will have delegated collection administrators</td> --%>
                    <label for="admins">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check6"/>
                    </label>
                </li>

                <li>
                    <% if (!bTemplateButton) {%>
                    <input type="hidden" name="default.item" value="false" />
                    <input type="checkbox" name="default.item" id="default.item" value="true" disabled="disabled"/>
                    <% } else {%>
                    <input type="checkbox" name="default.item" id="default.item" value="true"/>
                    <% }%>
                    <%-- <td class="submitFormLabel" nowrap>New submissions will have some metadata already filled out with defaults</td> --%>
                    <label for="default.item">
                        <fmt:message key="jsp.dspace-admin.wizard-questions.check7"/>
                    </label>
                </li>
            </ul>

            <%-- Hidden fields needed for servlet to know which collection and page to deal with --%>
            <input type="hidden" name="collection_id" value="<%= ((Collection) request.getAttribute("collection")).getID()%>" />
            <input type="hidden" name="stage" value="<%= CollectionWizardServlet.INITIAL_QUESTIONS%>" />

            <div class="centralizar">
                <input type="submit" class="button" name="submit_next" value="<fmt:message key="jsp.dspace-admin.general.next.button"/>" />
            </div>

        </form>

    </div>

</dspace:layout>
