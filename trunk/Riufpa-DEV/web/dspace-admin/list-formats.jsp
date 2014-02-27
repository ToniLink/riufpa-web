<%--
  - list-formats.jsp
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


<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%--
  - Display list of bitstream formats
  -
  - Attributes:
  -
  -   formats - the bitstream formats in the system (BitstreamFormat[])
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.content.BitstreamFormat" %>
<%@ page import="org.dspace.core.Context"%>
<%@ page import="org.dspace.app.webui.util.UIUtil"%>



<%
    BitstreamFormat[] formats =
        (BitstreamFormat[]) request.getAttribute("formats");
%>

<dspace:layout titlekey="jsp.dspace-admin.list-formats.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

    <h1><fmt:message key="jsp.dspace-admin.list-formats.title"/></h1>

    <p><fmt:message key="jsp.dspace-admin.list-formats.text1"/></p>
    <p><fmt:message key="jsp.dspace-admin.list-formats.text2"/></p>

<%
    Context context = UIUtil.obtainContext(request);

%>

<style>
    .listaDeFormatos{
        background-color: #EBF0FD;
        border-collapse:collapse;
    }
    .listaDeFormatos td{
        padding: 5px;
    }
    .listaDeFormatos th{
        background-color: #C9D8FF;
        padding: 5px;
    }
    .listaDeFormatos tr{
        background-color: #EBF0FD;
    }
    .listaDeFormatos tr:hover{
        background-color: #C9D8FF;
    }
</style>

    <table align="center" class="listaDeFormatos">
            <tr>
                <th>
                   <fmt:message key="jsp.general.id" />
                </th>
                <th>
                    <fmt:message key="jsp.dspace-admin.list-formats.mime"/>
                </th>
                <th>
                    <fmt:message key="jsp.dspace-admin.list-formats.name"/>
                </th>
                <th>
                    <fmt:message key="jsp.dspace-admin.list-formats.description"/>
                </th>
                <th>
                    <fmt:message key="jsp.dspace-admin.list-formats.support"/>
                </th>
                <th>
                    <fmt:message key="jsp.dspace-admin.list-formats.internal"/>
                </th>
                <th>
                    <fmt:message key="jsp.dspace-admin.list-formats.extensions"/>
                </th>
                <th colspan="3">
                    <fmt:message key="jsp.dspace-admin.list-formats.action"/>
                </th>
            </tr>
<%
    for (int i = 0; i < formats.length; i++)
    {
        String[] extensions = formats[i].getExtensions();
        String extValue = "";

        for (int j = 0 ; j < extensions.length; j++)
        {
            if (j > 0)
            {
                extValue = extValue + ", ";
            }
            extValue = extValue + extensions[j];
        }
        NumberFormat formatter = new DecimalFormat("00"); //Formatar os número como: 01, 02, 03...

%>
        <tr>
            <form method="post" action="">
                <td>
                    <%= formatter.format(formats[i].getID()) %>
                </td>

                <td>
                    <input title="<fmt:message key="jsp.dspace-admin.list-formats.mime"/>" type="text" name="mimetype" value="<%= formats[i].getMIMEType() %>" size="20"/>
                </td>
                <td>
<%
    if (BitstreamFormat.findUnknown(context).getID() == formats[i].getID()) {
%>
                    <input title="<fmt:message key="jsp.dspace-admin.list-formats.name"/>" type="text" readonly="readonly" disabled="disabled" name="short_description" value="<%= formats[i].getShortDescription() %>" size="10"/>
<%
    } else {
%>
                    <input title="<fmt:message key="jsp.dspace-admin.list-formats.name"/>" type="text" name="short_description" value="<%= formats[i].getShortDescription() %>" size="10"/>
<%
    }
%>
                    </td>
                        <td>
                    <input title="<fmt:message key="jsp.dspace-admin.list-formats.description"/>" type="text" name="description" value="<%= formats[i].getDescription() %>" size="20"/>
                    </td>
                    <td>
                    <select title="<fmt:message key="jsp.dspace-admin.list-formats.support"/>" name="support_level">
                        <option value="0" <%= formats[i].getSupportLevel() == 0 ? "selected=\"selected\"" : "" %>><fmt:message key="jsp.dspace-admin.list-formats.unknown"/></option>
                        <option value="1" <%= formats[i].getSupportLevel() == 1 ? "selected=\"selected\"" : "" %>><fmt:message key="jsp.dspace-admin.list-formats.known"/></option>
                        <option value="2" <%= formats[i].getSupportLevel() == 2 ? "selected=\"selected\"" : "" %>><fmt:message key="jsp.dspace-admin.list-formats.supported"/></option>
                    </select>
                    </td>
                    <td style="text-align: center">
                    <input title="<fmt:message key="jsp.dspace-admin.list-formats.internal"/>" type="checkbox" name="internal" value="true"<%= formats[i].isInternal() ? " checked=\"checked\"" : "" %>/>
                    </td>
                    <td>
                    <input title="<fmt:message key="jsp.dspace-admin.list-formats.extensions"/>" type="text" name="extensions" value="<%= extValue %>" size="10"/>
                    </td>
                    <td>
                    <input type="hidden" name="format_id" value="<%= formats[i].getID() %>" />
                    </td>
                    <td>
                    <input type="submit" class="button" name="submit_update" value="<fmt:message key="jsp.dspace-admin.general.update"/>"/>
                    </td>
                    <td>
<%
    if (BitstreamFormat.findUnknown(context).getID() != formats[i].getID()) {
%>
                    <input type="submit" class="buttonRed" name="submit_delete" value="<fmt:message key="jsp.dspace-admin.general.delete-w-confirm"/>" />
<%
    }
%>

                </td>
            </form>
        </tr>
<%
    }
%>

  </table>

  <form method="post" action="">
    <p align="center">
            <input type="submit" class="button" name="submit_add" value="<fmt:message key="jsp.dspace-admin.general.addnew"/>" />
    </p>
  </form>
</dspace:layout>
