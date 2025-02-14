<%--
  - confirm-delete-item.jsp
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
  - Confirm deletion of a item
  -
  - Attributes:
  -    item   - item we may delete
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditItemServlet" %>
<%@ page import="org.dspace.content.Item" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    String handle = (String) request.getAttribute("handle");
    Item item = (Item) request.getAttribute("item");
    request.setAttribute("LanguageSwitch", "hide");
%>

<dspace:layout titlekey="jsp.tools.confirm-delete-item.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/mydspace.css" type="text/css" />

    <h1>
        <fmt:message key="jsp.tools.confirm-delete-item.title"/>: <%= (handle == null ? String.valueOf(item.getID()) : handle)%>
    </h1>

    <p>
        <fmt:message key="jsp.tools.confirm-delete-item.info"/>
    </p>

    <dspace:item item="<%= item%>" style="full" />

    <div class="controles">
        <form method="post" action="">
            <input type="hidden" name="item_id" value="<%= item.getID()%>"/>
            <input type="hidden" name="action" value="<%= EditItemServlet.CONFIRM_DELETE%>"/>
            <input type="submit" name="submit" class="buttonRed" value="<fmt:message key="jsp.tools.general.delete"/>" />
            <input type="submit" name="submit_cancel" class="button" value="<fmt:message key="jsp.tools.general.cancel"/>" />
        </form>
    </div>
</dspace:layout>
