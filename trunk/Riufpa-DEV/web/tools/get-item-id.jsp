<%--
  - get-item-id.jsp
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
  - Form requesting a Handle or internal item ID for item editing
  -
  - Attributes:
  -     invalid.id  - if this attribute is present, display error msg
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.ConfigurationManager" %>

<dspace:layout titlekey="jsp.tools.get-item-id.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

    <style type="text/css">
        .tabela{
            width: 90%;
            padding: 20px;
            margin-left: auto;
            margin-right: auto;

            background: #EBF0FD;
            overflow:auto;

            /* Border style */
            border: 1px solid #5E78B5;
            -moz-border-radius: 7px;
            -webkit-border-radius: 7px;
            border-radius: 7px;
        }
        .tabela label{
            font-family: Arial, Verdana;
            float: left;
            font-weight: bold;
            text-align: right;
            width: 100%;
            line-height: 25px;
            font-size: 15px;
        }
        .tabela h3{
            text-shadow: 1px 1px 1px rgb(204, 204, 204);
            text-align: center;
            font-size: 12pt;
        }
    </style>

	<%-- <h1>Edit or Delete Item</h1> --%>
	<h1><fmt:message key="jsp.tools.get-item-id.heading"/></h1>

<%
    if (request.getAttribute("invalid.id") != null) { %>
    <%-- <p><strong>The ID you entered isn't a valid item ID.</strong>  If you're trying to
    edit a community or collection, you need to use the --%>
    <%-- <a href="<%= request.getContextPath() %>/dspace-admin/edit-communities">communities/collections admin page.</a></p> --%>
	<p><fmt:message key="jsp.tools.get-item-id.info1">
        <fmt:param><%= request.getContextPath() %>/dspace-admin/edit-communities</fmt:param>
    </fmt:message></p>
<%  } %>

    <form method="get" action="">
        <table class="tabela">
            <tr>
                <td colspan="2">
                    <h3>
                        <fmt:message key="jsp.tools.get-item-id.info2"/>
                    </h3>
                </td>
            </tr>
            <tr>
                <%-- <td class="submitFormLabel">Handle:</td> --%>
                <td>
                    <label for="thandle"><fmt:message key="jsp.tools.get-item-id.handle"/></label>
                </td>
                <td>
                    <input type="text" name="handle" id="thandle" value="<%= ConfigurationManager.getProperty("handle.prefix")%>/" size="12"/>
                    <%-- <input type="submit" name="submit" value="Find" /> --%>
                    <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.tools.get-item-id.find.button"/>" />
                </td>
            </tr>
            <tr><td></td></tr>
            <tr>
                <%-- <td class="submitFormLabel">Internal ID:</td> --%>
                <td>
                    <label for="titem_id"><fmt:message key="jsp.tools.get-item-id.internal"/></label>
                </td>
                <td>
                    <input type="text" name="item_id" id="titem_id" size="12"/>
                    <%-- <input type="submit" name="submit" value="Find"> --%>
                    <input type="submit" class="button" name="submit" value="<fmt:message key="jsp.tools.get-item-id.find.button"/>" />
                </td>
            </tr>
        </table>
    </form>

</dspace:layout>
