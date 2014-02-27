<%--
  - edit-collection.jsp
  -
  - Version: $Revision: 4886 $
  -
  - Date: $Date: 2010-05-05 11:41:24 +0000 (Wed, 05 May 2010) $
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
  - Show form allowing edit of collection metadata
  -
  - Attributes:
  -    community    - community to create new collection in, if creating one
  -    collection   - collection to edit, if editing an existing one.  If this
  -                  is null, we are creating one.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.content.Bitstream" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.eperson.Group" %>
<%@ page import="org.dspace.harvest.HarvestedCollection" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.List" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    Collection collection = (Collection) request.getAttribute("collection");
    Community community = (Community) request.getAttribute("community");

    Boolean adminCollection = (Boolean) request.getAttribute("admin_collection");
    boolean bAdminCollection = (adminCollection == null ? false : adminCollection.booleanValue());

    Boolean adminCreateGroup = (Boolean) request.getAttribute("admin_create_button");
    boolean bAdminCreateGroup = (adminCreateGroup == null ? false : adminCreateGroup.booleanValue());

    Boolean adminRemoveGroup = (Boolean) request.getAttribute("admin_remove_button");
    boolean bAdminRemoveGroup = (adminRemoveGroup == null ? false : adminRemoveGroup.booleanValue());

    Boolean workflowsButton = (Boolean) request.getAttribute("workflows_button");
    boolean bWorkflowsButton = (workflowsButton == null ? false : workflowsButton.booleanValue());

    Boolean submittersButton = (Boolean) request.getAttribute("submitters_button");
    boolean bSubmittersButton = (submittersButton == null ? false : submittersButton.booleanValue());

    Boolean templateButton = (Boolean) request.getAttribute("template_button");
    boolean bTemplateButton = (templateButton == null ? false : templateButton.booleanValue());

    Boolean policyButton = (Boolean) request.getAttribute("policy_button");
    boolean bPolicyButton = (policyButton == null ? false : policyButton.booleanValue());

    Boolean deleteButton = (Boolean) request.getAttribute("delete_button");
    boolean bDeleteButton = (deleteButton == null ? false : deleteButton.booleanValue());

    // Is the logged in user a sys admin
    Boolean admin = (Boolean) request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    HarvestedCollection hc = (HarvestedCollection) request.getAttribute("harvestInstance");

    String name = "";
    String shortDesc = "";
    String intro = "";
    String copy = "";
    String side = "";
    String license = "";
    String provenance = "";

    String oaiProviderValue = "";
    String oaiSetIdValue = "";
    String metadataFormatValue = "";
    String lastHarvestMsg = "";
    int harvestLevelValue = 0;
    int harvestStatus = 0;

    Group[] wfGroups = new Group[3];
    wfGroups[0] = null;
    wfGroups[1] = null;
    wfGroups[2] = null;

    Group admins = null;
    Group submitters = null;

    Item template = null;

    Bitstream logo = null;

    if (collection != null) {
        name = collection.getMetadata("name");
        shortDesc = collection.getMetadata("short_description");
        intro = collection.getMetadata("introductory_text");
        copy = collection.getMetadata("copyright_text");
        side = collection.getMetadata("side_bar_text");
        provenance = collection.getMetadata("provenance_description");

        if (collection.hasCustomLicense()) {
            license = collection.getLicense();
        }

        wfGroups[0] = collection.getWorkflowGroup(1);
        wfGroups[1] = collection.getWorkflowGroup(2);
        wfGroups[2] = collection.getWorkflowGroup(3);

        admins = collection.getAdministrators();
        submitters = collection.getSubmitters();

        template = collection.getTemplateItem();

        logo = collection.getLogo();

        /*
         * Harvesting stuff
         */
        if (hc != null) {
            oaiProviderValue = hc.getOaiSource();
            oaiSetIdValue = hc.getOaiSetId();
            metadataFormatValue = hc.getHarvestMetadataConfig();
            harvestLevelValue = hc.getHarvestType();
            lastHarvestMsg = hc.getHarvestMessage();
            harvestStatus = hc.getHarvestStatus();
        }

    }

    String t = request.getHeader("referer"); //página anterior (completa)
    //temos que tirar a parte repetida do domínio. Assim tudo que está desde o
    //começo da string até o contextpath será trocado por uma barra (/), pois
    //a tag parentlink coloca o resto no início.
    String t2 = t.replaceAll("^(.*)?" + request.getContextPath(), "");
    String k9 = collection.getMetadata("name");

%>

<dspace:layout titlekey="jsp.tools.edit-collection.title"
               navbar="admin"
               locbar="link"
               nocache="false">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/edit-col-com.css" type="text/css"/>

    <%
        if (collection == null) {
    %>
    <h1><fmt:message key="jsp.tools.edit-collection.heading1"/></h1>
    <% } else {%>
    <h1><fmt:message key="jsp.tools.edit-collection.heading2">
            <fmt:param><%= collection.getHandle()%></fmt:param>
        </fmt:message>
    </h1>

    <%--
        <% if (bDeleteButton) {%>
        <form method="post" action="">
            <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_DELETE_COLLECTION%>" />
            <input type="hidden" name="community_id" value="<%= community.getID()%>" />
            <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
            <input type="submit" name="submit" class="button-generic pink" value="<fmt:message key="jsp.tools.edit-collection.button.delete"/>" />
        </form>
    <% } %>
    --%>

    <%    }%>


    <form method="post" action="<%= request.getContextPath()%>/tools/edit-communities">
        <div class="fundo">
            <table class="metadados">
                <tr>
                    <th colspan="2"><fmt:message key="jsp.tools.edit-community.heading3"/></th>
                </tr>

                <tr>
                    <td>
                        <label for="name"><fmt:message key="jsp.tools.edit-collection.form.label1"/></label>
                    </td>
                    <td>
                        <input type="text" name="name" id="name" value="<%= Utils.addEntities(name)%>" size="50" />
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="short_description"><fmt:message key="jsp.tools.edit-collection.form.label2"/></label>
                    </td>
                    <td>
                        <input type="text" name="short_description" id="short_description" value="<%= Utils.addEntities(shortDesc)%>" size="50"/>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="introductory_text"><fmt:message key="jsp.tools.edit-collection.form.label3"/></label>
                    </td>
                    <td>
                        <textarea name="introductory_text" id="introductory_text" rows="6" cols="50"><%= Utils.addEntities(intro)%></textarea>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="copyright_text"><fmt:message key="jsp.tools.edit-collection.form.label4"/></label>
                    </td>
                    <td>
                        <textarea name="copyright_text" id="copyright_text" rows="6" cols="50"><%= Utils.addEntities(copy)%></textarea>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="side_bar_text"><fmt:message key="jsp.tools.edit-collection.form.label5"/></label>
                    </td>
                    <td>
                        <textarea name="side_bar_text" id="side_bar_text" rows="6" cols="50"><%= Utils.addEntities(side)%></textarea>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="license"><fmt:message key="jsp.tools.edit-collection.form.label6"/></label>
                    </td>
                    <td>
                        <textarea name="license" id="license" rows="6" cols="50"><%= Utils.addEntities(license)%></textarea>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label id="provenance_description"><fmt:message key="jsp.tools.edit-collection.form.label7"/></label>
                    </td>
                    <td>
                        <textarea name="provenance_description" id="provenance_description" rows="6" cols="50"><%= Utils.addEntities(provenance)%></textarea>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="logomarca"><fmt:message key="jsp.tools.edit-collection.form.label8"/></label>
                    </td>
                    <td>
                        <div id="logomarca">
                            <%  if (logo != null) {%>
                            <img src="<%= request.getContextPath()%>/retrieve/<%= logo.getID()%>" alt="collection logo"/>
                            <input type="submit" name="submit_set_logo" class="button" value="<fmt:message key="jsp.tools.edit-collection.form.button.add-logo"/>" />
                            <input type="submit" name="submit_delete_logo" class="buttonRed" value="<fmt:message key="jsp.tools.edit-collection.form.button.delete-logo"/>" />
                            <%  } else {%>
                            <input type="submit" name="submit_set_logo" class="button" value="<fmt:message key="jsp.tools.edit-collection.form.button.set-logo"/>" />
                            <%  }%>
                        </div>
                    </td>
                </tr>

            </table>
        </div>

        <% if (bSubmittersButton || bWorkflowsButton || bAdminCreateGroup || (admins != null && bAdminRemoveGroup)) {%>

        <div class="fundo">
            <table class="metadados">
                <tr>
                    <th colspan="2"><fmt:message key="jsp.tools.edit-collection.form.label9"/></th>
                </tr>

                <% }

                    if (bSubmittersButton) {%>
                <%-- ===========================================================
                     Collection Submitters
                     =========================================================== --%>
                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label10"/></label>
                    </td>
                    <td>
                        <%  if (submitters == null) {%>
                        <input type="submit" class="button" name="submit_submitters_create" value="<fmt:message key="jsp.tools.edit-collection.form.button.create"/>" />
                        <%  } else {%>
                        <input type="submit" class="button" name="submit_submitters_edit" value="<fmt:message key="jsp.tools.edit-collection.form.button.edit"/>" />
                        <input type="submit" class="buttonRed" name="submit_submitters_delete" value="<fmt:message key="jsp.tools.edit-collection.form.button.delete"/>" />
                        <%  }
            }%>
                    </td>
                </tr>

                <tr>
                    <td>
                        <% if (bAdminCreateGroup || (admins != null && bAdminRemoveGroup)) {%>
                        <%-- ===========================================================
                             Collection Administrators
                             =========================================================== --%>

                        <label><fmt:message key="jsp.tools.edit-collection.form.label12"/></label>
                    </td>
                    <td>
                        <%  if (admins == null) {
                                if (bAdminCreateGroup) {
                        %>
                        <input type="submit" class="button" name="submit_admins_create" id="submit_admins_create" value="<fmt:message key="jsp.tools.edit-collection.form.button.create"/>" />
                        <%  	}
                        } else {
                            if (bAdminCreateGroup) {
                        %>
                        <input type="submit" class="button" name="submit_admins_edit" id="submit_admins_edit" value="<fmt:message key="jsp.tools.edit-collection.form.button.edit"/>" />
                        <%  }
                            if (bAdminRemoveGroup) {
                        %>
                        <input type="submit" class="buttonRed" name="submit_admins_delete" id="submit_admins_delete" value="<fmt:message key="jsp.tools.edit-collection.form.button.delete"/>" />
                        <%  	}
                                }
                            }%>
                    </td>
                </tr>

                <tr>
                    <td>
                        <% if (bTemplateButton) {%>
                        <%-- ===========================================================
                             Item template
                             =========================================================== --%>

                        <label><fmt:message key="jsp.tools.edit-collection.form.label13"/></label>
                    </td>
                    <td>
                        <%  if (template == null) {%>
                        <input type="submit" class="button" name="submit_create_template" id="submit_create_template" value="<fmt:message key="jsp.tools.edit-collection.form.button.create"/>" />

                        <%  } else {%>
                        <input type="submit" class="button" name="submit_edit_template" id="submit_edit_template" value="<fmt:message key="jsp.tools.edit-collection.form.button.edit"/>" />
                        <input type="submit" class="buttonRed" name="submit_delete_template" id="submit_delete_template" value="<fmt:message key="jsp.tools.edit-collection.form.button.delete"/>" />
                        <%  }
            }%>
                    </td>
                </tr>

                <tr>
                    <td>
                        <% if (bPolicyButton) {%>
                        <%-- ===========================================================
                             Edit collection's policies
                             =========================================================== --%>

                        <label><fmt:message key="jsp.tools.edit-collection.form.label14"/></label>
                    </td>
                    <td>
                        <input type="submit" class="button" name="submit_authorization_edit" id="submit_authorization_edit" value="<fmt:message key="jsp.tools.edit-collection.form.button.edit"/>" />
                        <%  }%>
                    </td>
                </tr>
            </table>
        </div>

        <div class="fundo">
            <table class="metadados">
                <tr>
                    <th colspan="2">
                        <fmt:message key="jsp.tools.edit-collection.form.label10"/>
                    </th>
                </tr>

                <% if (bWorkflowsButton) {%>
                <%-- ===========================================================
                     Workflow groups
                     =========================================================== --%>
                <%
                    String[] roleTexts = {
                        LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-collection.wf-role1"),
                        LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-collection.wf-role2"),
                        LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-collection.wf-role3")
                    };

                    for (int i = 0; i < 3; i++) {
                %>
                <tr>
                    <td>
                        <%--<label><fmt:message key="jsp.tools.edit-collection.form.label11"/> <u><%= roleTexts[i]%></u></label>--%>
                        <label><%= roleTexts[i]%>:</label>
                    </td>
                    <td>
                        <%      if (wfGroups[i] == null) {%>
                        <input type="submit" class="button" name="submit_wf_create_<%= i + 1%>" value="<fmt:message key="jsp.tools.edit-collection.form.button.create"/>" />
                        <%      } else {%>
                        <input type="submit" class="button" name="submit_wf_edit_<%= i + 1%>" value="<fmt:message key="jsp.tools.edit-collection.form.button.edit"/>" />
                        <input type="submit" class="buttonRed" name="submit_wf_delete_<%= i + 1%>" value="<fmt:message key="jsp.tools.edit-collection.form.button.delete"/>" />
                    </td>
                </tr>
                <%      }
            }
        }%>


            </table>
        </div>



        <div class="fundo">
            <table class="metadados">

                <% if (bAdminCollection) {%>
                <%-- ===========================================================
                     Harvesting Settings
                     =========================================================== --%>
                <tr>
                    <th colspan="2"><fmt:message key="jsp.tools.edit-collection.form.label15"/></th>
                </tr>

                <%--
                oaiProviderValue = hc.getOaiSource();
                        oaiSetIdValue = hc.getOaiSetId();
                        metadataFormatValue = hc.getHarvestMetadataConfig();
                        harvestLevelValue = hc.getHarvestType();
                        String lastHarvestMsg= hc.getHarvestMessage();
                        int harvestStatus = hc.getHarvestStatus();

                        if (lastHarvestMsg == null)
                                lastHarvestMsg = "none";
                --%>

                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label16"/></label>
                    </td>
                    <td>
                        <input type="radio" id="col_padrao" value="source_normal" <% if (harvestLevelValue == 0) {%> checked="checked" <% }%> name="source"/>
                        <label for="col_padrao" id="desc"><fmt:message key="jsp.tools.edit-collection.form.label17"/></label>
                        <br/>

                        <input type="radio" id="col_ext" value="source_harvested" <% if (harvestLevelValue > 0) {%> checked="checked" <% }%> name="source"/>
                        <label for="col_ext" id="desc"><fmt:message key="jsp.tools.edit-collection.form.label18"/></label>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label19"/></label>
                    </td>
                    <td>
                        <input type="text" name="oai_provider" id="oai_provider" value="<%= oaiProviderValue%>" size="50" />
                    </td>
                </tr>

                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label20"/></label>
                    </td>
                    <td>
                        <input type="text" name="oai_setid" id="oai_setid" value="<%= oaiSetIdValue%>" size="50" />
                    </td>
                </tr>

                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label21"/></label>
                    </td>
                    <td>
                        <select name="metadata_format" id="metadata_format" >
                            <%
                                // Add an entry for each instance of ingestion crosswalks configured for harvesting
                                String metaString = "harvester.oai.metadataformats.";
                                Enumeration pe = ConfigurationManager.propertyNames();
                                while (pe.hasMoreElements()) {
                                    String key = (String) pe.nextElement();


                                    if (key.startsWith(metaString)) {
                                        String metadataString = ConfigurationManager.getProperty(key);
                                        String metadataKey = key.substring(metaString.length());
                                        String label = "jsp.tools.edit-collection.form.label21.select." + metadataKey;

                            %>
                            <option value="<%= metadataKey%>"
                                    <% if (metadataKey.equalsIgnoreCase(metadataFormatValue)) {%>
                                    selected="selected" <% }%> >
                                <fmt:message key="<%=label%>"/>
                            </option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label22"/></label>
                    </td>
                    <td>
                        <input type="radio" id="so_met" value="1" <% if (harvestLevelValue != 2 && harvestLevelValue != 3) {%> checked="checked" <% }%> name="harvest_level" id="harvest_level"/>
                        <label for="so_met" id="desc"><fmt:message key="jsp.tools.edit-collection.form.label23"/></label>
                        <br/>
                        <input type="radio" id="met_ref" value="2" <% if (harvestLevelValue == 2) {%> checked="checked" <% }%> name="harvest_level" id="harvest_level"/>
                        <label for="met_ref" id="desc"><fmt:message key="jsp.tools.edit-collection.form.label24"/></label>
                        <br/>
                        <input type="radio" id="met_bit" value="3" <% if (harvestLevelValue == 3) {%> checked="checked" <% }%> name="harvest_level" id="harvest_level"/>
                        <label for="met_bit" id="desc"><fmt:message key="jsp.tools.edit-collection.form.label25"/></label>
                    </td>
                </tr>

                <tr>
                    <td>
                        <label><fmt:message key="jsp.tools.edit-collection.form.label26"/></label>
                    </td>
                    <td>
                        <%= lastHarvestMsg%>
                    </td>
                </tr>
                <%  }%>
            </table>
        </div>

        <div class="esquerda">
            <%
                if (collection == null) {
            %>
            <input type="hidden" name="community_id" value="<%= community.getID()%>" />
            <input type="hidden" name="create" value="true" />
            <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.tools.edit-collection.form.button.create2"/>" />
            <%
            } else {
            %>
            <input type="hidden" name="community_id" value="<%= community.getID()%>" />
            <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
            <input type="hidden" name="create" value="false" />
            <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.tools.edit-collection.form.button.update"/>" />
            <%
                }
            %>
            <input type="hidden" name="community_id" value="<%= community.getID()%>" />
            <input type="hidden" name="action" value="<%= EditCommunitiesServlet.CONFIRM_EDIT_COLLECTION%>" />
            <input type="submit" class="button" name="submit_cancel" value="<fmt:message key="jsp.tools.edit-collection.form.button.cancel"/>" />
        </div>

    </form>

    <div id="controles">
        <div class="direita">
            <% if (bDeleteButton) {%>

            <form method="post" action="">
                <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_DELETE_COLLECTION%>" />
                <input type="hidden" name="community_id" value="<%= community.getID()%>" />
                <input type="hidden" name="collection_id" value="<%= collection.getID()%>" />
                <input type="submit" name="submit" class="buttonRed" value="<fmt:message key="jsp.tools.edit-collection.button.delete"/>" />
            </form>

            <% } %>
        </div>
    </div>

</dspace:layout>