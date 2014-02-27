<%--
  - eperson-main.jsp
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
  - main page for eperson admin
  -
  - Attributes:
  -   no_eperson_selected - if a user tries to edit or delete an EPerson without
  -                         first selecting one
  -
  - Returns:
  -   submit_add    - admin wants to add an eperson
  -   submit_browse - admin wants to browse epeople
  -
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
   boolean noEPersonSelected = (request.getAttribute("no_eperson_selected") != null);
%>

<dspace:layout titlekey="jsp.dspace-admin.eperson-main.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

    <h1><fmt:message key="jsp.dspace-admin.eperson-main.heading"/></h1>

<% if (noEPersonSelected){
%>
    <p><strong>
        <fmt:message key="jsp.dspace-admin.eperson-main.noepersonselected"/>
    </strong></p>
<%
    }
%>

<script type="text/javascript">
    function closeIframe() {
        //var iframe = document.getElementById('someid');
        //iframe.parentNode.removeChild(iframe);
        TINY.box.hide();
        if(document.getElementById("teste2").style.display === "none")
            Effect.toggle('teste2', 'appear', { duration: 0.4});
    }
</script>
<form name="epersongroup" method="post" action="">
    <center>
        <input type="submit" class="button" name="submit_add" value="<fmt:message key="jsp.dspace-admin.eperson-main.add"/>" />
        <button type="button" class="button" onclick="Effect.toggle('teste', 'appear', { duration: 0.4});">
            <fmt:message key="jsp.dspace-admin.eperson-main.edit"/>
        </button>
        <br /><br />
        <div style="background-color: #EBF0FD; width: 50%;">
            <div style="display: none; padding: 20px;" id="teste">
                <input type="button" class="button" value="<fmt:message key="jsp.dspace-admin.eperson-main.select"/>" onclick="TINY.box.show({iframe:'<%= request.getContextPath() %>/tools/eperson-list?multiple=false', width: largura, height: altura, animate:false});" />
                <br/>
                <select multiple="multiple" name="eperson_id" size="1">
                    <option value="">&nbsp;</option>
                </select>
            </div>
            <div style="display: none; padding-bottom: 10px;" id="teste2">
                <input type="submit" class="button" name="submit_edit" value="<fmt:message key="jsp.dspace-admin.general.edit"/>" onclick="javascript:finishEPerson();"/>
                <input type="submit" class="button" name="submit_delete" value="<fmt:message key="jsp.dspace-admin.general.delete-w-confirm"/>" onclick="javascript:finishEPerson();"/>
            </div>
        </div>

    </center>
</form>

</dspace:layout>
