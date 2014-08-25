<%--
  - edit-item-form.jsp
  -
  - Version: $Revision: 4365 $
  -
  - Date: $Date: 2009-10-05 23:52:42 +0000 (Mon, 05 Oct 2009) $
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
  -    item        - item to edit
  -    collections - collections the item is in, if any
  -    handle      - item's Handle, if any (String)
  -    dc.types    - MetadataField[] - all metadata fields in the registry
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="javax.servlet.jsp.PageContext" %>

<%@ page import="org.dspace.content.MetadataField" %>
<%@ page import="org.dspace.app.webui.servlet.admin.AuthorizeAdminServlet" %>
<%@ page import="org.dspace.app.webui.servlet.admin.EditItemServlet" %>
<%@ page import="org.dspace.content.Bitstream" %>
<%@ page import="org.dspace.content.BitstreamFormat" %>
<%@ page import="org.dspace.content.Bundle" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.content.authority.MetadataAuthorityManager" %>
<%@ page import="org.dspace.content.authority.ChoiceAuthorityManager" %>
<%@ page import="org.dspace.content.authority.Choices" %>

<%
    Item item = (Item) request.getAttribute("item");
    String handle = (String) request.getAttribute("handle");
    Collection[] collections = (Collection[]) request.getAttribute("collections");
    MetadataField[] dcTypes = (MetadataField[]) request.getAttribute("dc.types");
    HashMap metadataFields = (HashMap) request.getAttribute("metadataFields");
    request.setAttribute("LanguageSwitch", "hide");

    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin of the item
    Boolean itemAdmin = (Boolean) request.getAttribute("admin_button");
    boolean isItemAdmin = (itemAdmin == null ? false : itemAdmin.booleanValue());

    Boolean policy = (Boolean) request.getAttribute("policy_button");
    boolean bPolicy = (policy == null ? false : policy.booleanValue());

    Boolean delete = (Boolean) request.getAttribute("delete_button");
    boolean bDelete = (delete == null ? false : delete.booleanValue());

    Boolean createBits = (Boolean) request.getAttribute("create_bitstream_button");
    boolean bCreateBits = (createBits == null ? false : createBits.booleanValue());

    Boolean removeBits = (Boolean) request.getAttribute("remove_bitstream_button");
    boolean bRemoveBits = (removeBits == null ? false : removeBits.booleanValue());

    Boolean ccLicense = (Boolean) request.getAttribute("cclicense_button");
    boolean bccLicense = (ccLicense == null ? false : ccLicense.booleanValue());

    Boolean withdraw = (Boolean) request.getAttribute("withdraw_button");
    boolean bWithdraw = (withdraw == null ? false : withdraw.booleanValue());

    Boolean reinstate = (Boolean) request.getAttribute("reinstate_button");
    boolean bReinstate = (reinstate == null ? false : reinstate.booleanValue());

    // owning Collection ID for choice authority calls
    int collectionID = -1;
    if (collections.length > 0) {
        collectionID = collections[0].getID();
    }
%>
<%!
    StringBuffer doAuthority(MetadataAuthorityManager mam, ChoiceAuthorityManager cam,
            PageContext pageContext,
            String contextPath, String fieldName, String idx,
            DCValue dcv, int collectionID) {
        StringBuffer sb = new StringBuffer();
        if (cam.isChoicesConfigured(fieldName)) {
            boolean authority = mam.isAuthorityControlled(fieldName);
            boolean required = authority && mam.isAuthorityRequired(fieldName);

            String fieldNameIdx = "value_" + fieldName + "_" + idx;
            String authorityName = "choice_" + fieldName + "_authority_" + idx;
            String confidenceName = "choice_" + fieldName + "_confidence_" + idx;

            // put up a SELECT element containing all choices
            if ("select".equals(cam.getPresentation(fieldName))) {
                sb.append("<select id=\"").append(fieldNameIdx).append("\" name=\"").append(fieldNameIdx).append("\" size=\"1\">");
                Choices cs = cam.getMatches(fieldName, dcv.value, collectionID, 0, 0, null);
                if (cs.defaultSelected < 0) {
                    sb.append("<option value=\"").append(dcv.value).append("\" selected>").append(dcv.value).append("</option>\n");
                }

                for (int i = 0; i < cs.values.length; ++i) {
                    sb.append("<option value=\"").append(cs.values[i].value).append("\"").append(i == cs.defaultSelected ? " selected>" : ">").append(cs.values[i].label).append("</option>\n");
                }
                sb.append("</select>\n");
            } // use lookup for any other presentation style (i.e "select")
            else {
                String confidenceIndicator = "indicator_" + confidenceName;
                sb.append("<textarea id=\"").append(fieldNameIdx).append("\" name=\"").append(fieldNameIdx).append("\" rows=\"3\" cols=\"50\">").append(dcv.value).append("</textarea>\n<br/>\n");

                if (authority) {
                    String confidenceSymbol = Choices.getConfidenceText(dcv.confidence).toLowerCase();
                    sb.append("<img id=\"" + confidenceIndicator + "\"  title=\"").append(LocaleSupport.getLocalizedMessage(pageContext, "jsp.authority.confidence.description." + confidenceSymbol)).append("\" class=\"ds-authority-confidence cf-" + confidenceSymbol).append("\" src=\"").append(contextPath).append("/image/confidence/invisible.gif\" />").append("<input type=\"text\" readonly value=\"").append(dcv.authority != null ? dcv.authority : "").append("\" id=\"").append(authorityName).append("\" onChange=\"javascript: return DSpaceAuthorityOnChange(this, '").append(confidenceName).append("','").append(confidenceIndicator).append("');\" name=\"").append(authorityName).append("\" class=\"ds-authority-value ds-authority-visible \"/>").append("<input type=\"image\" class=\"ds-authority-lock is-locked \" ").append(" src=\"").append(contextPath).append("/image/confidence/invisible.gif\" ").append(" onClick=\"javascript: return DSpaceToggleAuthorityLock(this, '").append(authorityName).append("');\" ").append(" title=\"").append(LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-item-form.unlock")).append("\" >").append("<input type=\"hidden\" value=\"").append(confidenceSymbol).append("\" id=\"").append(confidenceName).append("\" name=\"").append(confidenceName).append("\" class=\"ds-authority-confidence-input\"/>");
                }

                sb.append("<input type=\"image\" name=\"").append(fieldNameIdx).append("_lookup\" ").append("onclick=\"javascript: return DSpaceChoiceLookup('").append(contextPath).append("/tools/lookup.jsp','").append(fieldName).append("','edit_metadata','").append(fieldNameIdx).append("','").append(authorityName).append("','").append(confidenceIndicator).append("',").append(String.valueOf(collectionID)).append(",").append("false").append(",false);\"").append(" title=\"").append(LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.lookup.lookup")).append("\" width=\"16px\" height=\"16px\" src=\"" + contextPath + "/image/authority/zoom.png\" />");
            }
        }
        return sb;
    }
%>

<dspace:layout titlekey="jsp.tools.edit-item-form.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/edit-col-com.css" type="text/css"/>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css"/>


    <h1><fmt:message key="jsp.tools.edit-item-form.title"/></h1>
     
    <div class="boxAlerta">
        <fmt:message key="jsp.tools.edit-item-form.note"/>
    </div>

    <div class="fundo">
        <table class="metadados">
            <tr>
                <th colspan="2"><fmt:message key="jsp.tools.edit-item-form.info"/></th>
            </tr>
            <tr>
                <td>
                    <label><fmt:message key="jsp.tools.edit-item-form.itemID"/></label>
                </td>
                <td>
                    <%= item.getID()%>
                </td>
            </tr>
            <tr>
                <td>
                    <label><fmt:message key="jsp.tools.edit-item-form.handle"/></label>
                </td>
                <td>
                    <%= (handle == null ? "None" : handle)%>
                </td>
            </tr>
            <tr>
                <td>
                    <label><fmt:message key="jsp.tools.edit-item-form.modified"/></label>
                </td>
                <td>
                    <dspace:date date="<%= new DCDate(item.getLastModified())%>" />
                </td>
            </tr>
            <tr>
                <td>
                    <label><fmt:message key="jsp.tools.edit-item-form.collections"/></label>
                </td>
                <td>
                    <%  for (int i = 0; i < collections.length; i++) {%>
                    <%= collections[i].getMetadata("name")%><br/>
                    <%  }%>
                </td>
            </tr>

            <tr>
                <td>
                    <label><fmt:message key="jsp.tools.edit-item-form.itempage"/></label>
                </td>
                <td>
                    <%  if (handle == null) {%>
                    <em><fmt:message key="jsp.tools.edit-item-form.na"/></em>
                    <%  } else {
                        //A propriedade dspace.url é definida na configuração do dspace ({home-do-dspace}/config/dspace.cfg).
                        //Por padrão essa propriedade é ${dspace.baseUrl}/xmlui, o que faz com que os links desses itens redirecionem
                        //para o site do Manakin. Tanto o Jspui como o Xmlui (Manakin) possuem esses itens, mas queremos redirecionar
                        //esses links para o próprio Jspui, logo alteramos a propriedade no dspace.cfg para ${dspace.baseUrl}/Backup_RIUFPA.
                        String url = ConfigurationManager.getProperty("dspace.url") + "/handle/" + handle;%>
                    <a target="_blank" href="<%= url%>"><%= url%></a>
                    <%  }%>
                </td>
            </tr>
            <%
                if (bPolicy) {
            %>
            <%-- ===========================================================
                 Edit item's policies
                 =========================================================== --%>
            <tr>
                <td>
                    <label><fmt:message key="jsp.tools.edit-item-form.item"/></label>
                </td>
                <td>
                    <form method="post" action="<%= request.getContextPath()%>/tools/authorize">
                        <input type="hidden" name="handle" value="<%= ConfigurationManager.getProperty("handle.prefix")%>" />
                        <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                        <input type="submit" class="button" name="submit_item_select" value="<fmt:message key="jsp.tools.general.edit"/>"/>
                    </form>
                </td>
            </tr>
            <%
                }
            %>

            <tr>
                <td colspan="2">
                    <div id="itemopt">
                        <%
                            if (!item.isWithdrawn() && bWithdraw) {
                        %>
                        <form method="post" action="<%= request.getContextPath()%>/tools/edit-item">
                            <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                            <input type="hidden" name="action" value="<%= EditItemServlet.START_WITHDRAW%>" />
                            <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.tools.edit-item-form.withdraw-w-confirm.button"/>"/>
                        </form>
                        <%
                        } else if (item.isWithdrawn() && bReinstate) {
                        %>
                        <form method="post" action="<%= request.getContextPath()%>/tools/edit-item">
                            <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                            <input type="hidden" name="action" value="<%= EditItemServlet.REINSTATE%>" />
                            <input type="submit" class="buttonGreen" name="submit" value="<fmt:message key="jsp.tools.edit-item-form.reinstate.button"/>"/>
                        </form>
                        <%
                            }
                            if (isItemAdmin) {
                        %>
                        <form method="post" action="<%= request.getContextPath()%>/tools/edit-item">
                            <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                            <input type="hidden" name="action" value="<%= EditItemServlet.START_MOVE_ITEM%>" />
                            <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.tools.edit-item-form.move-item.button"/>"/>
                        </form>
                        <%
                            }
                            if (bDelete) {
                        %>
                        <form method="post" action="<%= request.getContextPath()%>/tools/edit-item">
                            <input type="hidden" name="item_id" value="<%= item.getID()%>" />
                            <input type="hidden" name="action" value="<%= EditItemServlet.START_DELETE%>" />
                            <input type="submit" class="buttonRed" name="submit" value="<fmt:message key="jsp.tools.edit-item-form.delete-w-confirm.button"/>"/>
                        </form>
                        <%
                            }
                        %>
                    </div>
                </td>
            </tr>
        </table>
    </div>


    <%

        if (item.isWithdrawn()) {
    %>
    <%-- <p align="center"><strong>This item was withdrawn from DSpace</strong></p> --%>
    <p align="center"><strong><fmt:message key="jsp.tools.edit-item-form.msg"/></strong></p>
            <%    }
            %>


    <form id="edit_metadata" name="edit_metadata" method="post" action="<%= request.getContextPath()%>/tools/edit-item">
        <table class="tabela">
            <tr class="tituloTabela">
                <td colspan="6"><fmt:message key="jsp.tools.edit-item-form.metadata"/></td>
            </tr>
            <tr>
                <th id="t0"><fmt:message key="jsp.tools.edit-item-form.elem0"/></th>
                <th id="t1"><fmt:message key="jsp.tools.edit-item-form.elem1"/></th>
                <th id="t2"><fmt:message key="jsp.tools.edit-item-form.elem2"/></th>
                <th id="t3"><fmt:message key="jsp.tools.edit-item-form.elem3"/></th>
                <th id="t4"><fmt:message key="jsp.tools.edit-item-form.elem4"/></th>
                <th id="t5"><fmt:message key="jsp.tools.edit-item-form.elem12"/></th>
            </tr>
            <%
                MetadataAuthorityManager mam = MetadataAuthorityManager.getManager();
                ChoiceAuthorityManager cam = ChoiceAuthorityManager.getManager();
                DCValue[] dcv = item.getMetadata(Item.ANY, Item.ANY, Item.ANY, Item.ANY);

                // Keep a count of the number of values of each element+qualifier
                // key is "element" or "element_qualifier" (String)
                // values are Integers - number of values that element/qualifier so far
                Map dcCounter = new HashMap();

                for (int i = 0; i < dcv.length; i++) {
                    // Find out how many values with this element/qualifier we've found

                    String key = ChoiceAuthorityManager.makeFieldKey(dcv[i].schema, dcv[i].element, dcv[i].qualifier);

                    Integer count = (Integer) dcCounter.get(key);
                    if (count == null) {
                        count = new Integer(0);
                    }

                    // Increment counter in map
                    dcCounter.put(key, new Integer(count.intValue() + 1));

                    // We will use two digits to represent the counter number in the parameter names.
                    // This means a string sort can be used to put things in the correct order even
                    // if there are >= 10 values for a particular element/qualifier.  Increase this to
                    // 3 digits if there are ever >= 100 for a single element/qualifer! :)
                    String sequenceNumber = count.toString();

                    while (sequenceNumber.length() < 2) {
                        sequenceNumber = "0" + sequenceNumber;
                    }
                    if (i % 2 == 0) {
            %>
            <tr class="stripe">
                <%                } else {
                %>
            <tr>
                <%}
                %>
                <td headers="t0"><%=dcv[i].schema%></td>
                <td headers="t1"><%= dcv[i].element%></td>
                <td headers="t2"><%= (dcv[i].qualifier == null ? "" : dcv[i].qualifier)%></td>
                <td headers="t3">
                    <%
                        if (cam.isChoicesConfigured(key)) {
                    %>
                    <%=doAuthority(mam, cam, pageContext, request.getContextPath(), key, sequenceNumber,
                            dcv[i], collectionID).toString()%>
                    <% } else {%>
                    <textarea id="value_<%= key%>_<%= sequenceNumber%>" name="value_<%= key%>_<%= sequenceNumber%>" rows="3" cols="50"><%= dcv[i].value%></textarea>
                    <% }%>
                </td>
                <td headers="t4">
                    <input type="text" name="language_<%= key%>_<%= sequenceNumber%>" value="<%= (dcv[i].language == null ? "" : dcv[i].language)%>" size="5"/>
                </td>
                <td headers="t5">
                    <input type="submit" class="buttonRed" name="submit_remove_<%= key%>_<%= sequenceNumber%>" value="<fmt:message key="jsp.tools.general.remove"/>"/>
                </td>
            </tr>
            <%
                }%>
            <tr>
                <td headers="t1" colspan="3">
                    <select name="addfield_dctype" id="addfield_dctype">
                        <%  for (int i = 0; i < dcTypes.length; i++) {
                                Integer fieldID = new Integer(dcTypes[i].getFieldID());
                                String displayName = (String) metadataFields.get(fieldID);
                        %>
                        <option value="<%= fieldID.intValue()%>"><%= displayName%></option>
                        <%  }%>
                    </select>
                </td>
                <td headers="t3">
                    <textarea name="addfield_value" id="addfield_value" rows="3" cols="50" onkeyup="sugerirAssunto(this, event);"></textarea>
                </td>
                <td headers="t4">
                    <input type="text" name="addfield_language" size="5"/>
                </td>
                <td headers="t5">
                    <input type="submit" class="button" name="submit_addfield" value="<fmt:message key="jsp.tools.general.add"/>"/>
                </td>
            </tr>
        </table>

        <script type="text/javascript">
                        function sugerirAssunto(textArea, e) {
                            var val = $('addfield_dctype');
                            
                            if (val.options[val.selectedIndex].innerHTML === 'dc.subject') {
                                ajax_showOptions(textArea, 'starts_with', e, removerQuebra, null, null, 'assunto');
                            }
                        }
                        function removerQuebra() {
                            var val = $('addfield_value').value;
                            $('addfield_value').value = val.replace("\n", "");
                        }
        </script>

        <%-- Não usaremos mais este alerta.
                <div class="boxAlerta">
                    <fmt:message key="jsp.tools.edit-item-form.note3"/>
                </div>
        --%>

        <table class="tabela">
            <tr class="tituloTabela">
                <td colspan="7"><fmt:message key="jsp.tools.edit-item-form.heading"/></td>
            </tr>
            <tr>
                <th id="t11"><fmt:message key="jsp.tools.edit-item-form.elem5"/></th>
                <th id="t12"><fmt:message key="jsp.tools.edit-item-form.elem7"/></th>

                <%-- Oculta a seção "Fonte".--%>
                <th id="t13" style="display:none"><fmt:message key="jsp.tools.edit-item-form.elem8"/></th>

                <th id="t14"><fmt:message key="jsp.tools.edit-item-form.elem9"/></th>

                <%-- A seção "Formato" será escondida do usuário.--%>
                <th id="t15" style="display:none"><fmt:message key="jsp.tools.edit-item-form.elem10"/></th>

                <%-- "Descrição do Usuário" nunca é usado no RIUFPA. Ele serve para descrever
                a extensão de um arquivo, por exemplo: "Modelo do Blender".--%>
                <th id="t16" style="display:none"><fmt:message key="jsp.tools.edit-item-form.elem11"/></th>

                <th id="t17" colspan="2"><fmt:message key="jsp.tools.edit-item-form.elem12"/></th>
            </tr>
            <%
                boolean stripe = true;
                Bundle[] bundles = item.getBundles();

                for (int i = 0; i < bundles.length; i++) {
                    Bitstream[] bitstreams = bundles[i].getBitstreams();
                    for (int j = 0; j < bitstreams.length; j++) {
                        // Parameter names will include the bundle and bitstream ID
                        // e.g. "bitstream_14_18_desc" is the description of bitstream 18 in bundle 14
                        String key = bundles[i].getID() + "_" + bitstreams[j].getID();
                        BitstreamFormat bf = bitstreams[j].getFormat();
                        if (stripe) {
            %>
            <tr class="stripe">
                <%            } else {
                %>
            <tr>
                <%                }
                    stripe = !stripe;
                %>
                <% if (bundles[i].getName().equals("ORIGINAL")) {%>
                <td>
                    <input type="radio" name="<%= bundles[i].getID()%>_primary_bitstream_id" value="<%= bitstreams[j].getID()%>"
                           <% if (bundles[i].getPrimaryBitstreamID() == bitstreams[j].getID()) {%>
                           checked="<%="checked"%>"
                           <% }%> />
                </td>
                <% } else {%>
                <td>

                </td>

                <% }%>
                <td>
                    <input type="text" name="bitstream_name_<%= key%>" value="<%= (bitstreams[j].getName() == null ? "" : Utils.addEntities(bitstreams[j].getName()))%>"/>
                </td>

                <%-- Oculta a fonte. --%>
                <td style="display:none">
                    <input type="text" name="bitstream_source_<%= key%>" value="<%= (bitstreams[j].getSource() == null ? "" : bitstreams[j].getSource())%>"/>
                </td>

                <td>
                    <input type="text" name="bitstream_description_<%= key%>" value="<%= (bitstreams[j].getDescription() == null ? "" : Utils.addEntities(bitstreams[j].getDescription()))%>"/>
                </td>

                <%-- Oculta as IDs de formato de arquivo. --%>
                <td style="display:none">
                    <input type="text" name="bitstream_format_id_<%= key%>" value="<%= bf.getID()%>" size="3" title="<%= Utils.addEntities(bf.getShortDescription())%>"/>
                </td>

                <%-- Oculta os valores do User Description. --%>
                <td style="display:none">
                    <input type="text" name="bitstream_user_format_description_<%= key%>" value="<%= (bitstreams[j].getUserFormatDescription() == null ? "" : Utils.addEntities(bitstreams[j].getUserFormatDescription()))%>"/>
                </td>

                <td>
                    <a target="_blank" class="button" href="<%= request.getContextPath()%>/retrieve/<%= bitstreams[j].getID()%>">
                        <fmt:message key="jsp.tools.general.view"/>
                    </a>
                </td>
                <td>
                    <% if (bRemoveBits) {%>
                    <input type="submit" class="buttonRed" name="submit_delete_bitstream_<%= key%>" value="<fmt:message key="jsp.tools.general.remove"/>" />
                    <% }%>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>


        <div style="text-align: center; margin-top: 10px;">
            <%
                if (bCreateBits) {
            %>
            <input type="submit" class="button" name="submit_addbitstream" value="<fmt:message key="jsp.tools.edit-item-form.addbit.button"/>"/>
            <%  }

                if (ConfigurationManager.getBooleanProperty("webui.submit.enable-cc") && bccLicense) {
                    String s;
                    Bundle[] ccBundle = item.getBundles("CC-LICENSE");
                    s = ccBundle.length > 0 ? LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-item-form.replacecc.button") : LocaleSupport.getLocalizedMessage(pageContext, "jsp.tools.edit-item-form.addcc.button");
            %>
            <input type="submit" class="button" name="submit_addcc" value="<%= s%>" />
            <input type="hidden" name="handle" value="<%= ConfigurationManager.getProperty("handle.prefix")%>"/>
            <input type="hidden" name="item_id" value="<%= item.getID()%>"/>
            <%
                }
            %>
        </div>

        <div style="display: none;">
            <input type="hidden" name="item_id" value="<%= item.getID()%>"/>
            <input type="hidden" name="action" value="<%= EditItemServlet.UPDATE_ITEM%>"/>
            <input type="submit" id="form_update" name="submit" value="<fmt:message key="jsp.tools.general.update"/>" />
            <input type="submit" id="form_cancel" name="submit_cancel" value="<fmt:message key="jsp.tools.general.cancel"/>" />
        </div>
    </form>


    <style type="text/css">
        #nav {
            background-color: #C9D8FF;
            width: 100%;
            height: 55px;
            box-shadow: 0px 10px 30px #2E6AB1;
            position: fixed;
            bottom: 0px;
            text-align: center;
        }

        #navigation {
            list-style-type: none;
        }

        #navigation li {
            display: inline;
            padding: 10px;
        }

        #nav a {
            font-family: verdana;
            text-decoration: none;
            color: #EDEDED;
        }

        #nav a:hover {
            color: #BDBDBD;
        }
    </style>    

    <script type="text/javascript">
        function submit_form() {
            $("form_update").click();
        }

        function cancel_form() {
            $("form_cancel").click();
        }
    </script>

</dspace:layout>

<div id="nav">
    <ul id="navigation">
        <li><button class="buttonGreen" onclick="submit_form();"> <fmt:message key="jsp.tools.general.update"/> </button> </li>
        <li><button class="button" onclick="cancel_form();"> <fmt:message key="jsp.tools.general.cancel"/> </button> </li>
    </ul>
</div>
