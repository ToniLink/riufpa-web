<%--
  - authorize_policy_main.jsp
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
  - main page for authorization editing
  -
  - Attributes:
  -   none
  -
  - Returns:
  -   submit_community
  -   submit_collection
  -   submit_item
  -       item_handle
  -       item_id
  -   submit_advanced
  -
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.content.Collection" %>

<% request.setAttribute("LanguageSwitch", "hide"); %>

<%
// this space intentionally left blank. (Quer dizer, POG).
%>

<dspace:layout titlekey="jsp.dspace-admin.authorize-main.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

<style type="text/css">
    .politicas table{
        width: auto;
        margin-left: auto;
        margin-right: auto;

        padding: 20px;
        background: #EBF0FD;
        overflow:auto;

        margin-left:auto;
        margin-right:auto;

        /* Border style */
        border: 1px solid #5E78B5;
        -moz-border-radius: 7px;
        -webkit-border-radius: 7px;
        border-radius: 7px;
    }
    .politicas h3{
        text-align: center;
        font-size: 12pt;
        text-shadow: 1px 1px 1px rgb(204, 204, 204);
    }
    .politicas input{
        width: 100%;
    }
</style>

    <%-- <h1>Administer Authorization Policies</h1> --%>
    <h1><fmt:message key="jsp.dspace-admin.authorize-main.adm"/></h1>


    <form method="post" action="" class="politicas">
            <table>
                <tr>
                    <td>
                        <h3><fmt:message key="jsp.dspace-admin.authorize-main.choose"/></h3>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%-- <input type="submit" name="submit_community" value="Manage a Community's Policies"> --%>
                        <input type="submit" class="button" name="submit_community" value="<fmt:message key="jsp.dspace-admin.authorize-main.manage1"/>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%-- <input type="submit" name="submit_collection" value="Manage Collection's Policies"> --%>
                        <input type="submit" class="button" name="submit_collection" value="<fmt:message key="jsp.dspace-admin.authorize-main.manage2"/>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%-- <input type="submit" name="submit_item" value="Manage An Item's Policies"> --%>
                        <input type="submit" class="button" name="submit_item" value="<fmt:message key="jsp.dspace-admin.authorize-main.manage3"/>" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <%-- <input type="submit" name="submit_advanced" value="Advanced/Item Wildcard Policy Admin Tool"> --%>
                        <input type="submit" class="button" name="submit_advanced" value="<fmt:message key="jsp.dspace-admin.authorize-main.advanced"/>" />
                    </td>
                </tr>
            </table>
    </form>
</dspace:layout>
