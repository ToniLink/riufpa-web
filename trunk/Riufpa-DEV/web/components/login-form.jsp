<%--
  - login-form.jsp
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
  - notice, this list of cond;itions and the following disclaimer.
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
  - Component which displays a login form and associated information
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<style type="text/css">
    #form_login {
        width: 35%;
        padding: 10px;
        background: #EBF0FD;
        overflow:auto;
        margin-left:auto;
        margin-right:auto;

        /* Border style */
        border: 1px solid #5E78B5;
        -webkit-border-radius: 5px;
        border-radius: 5px;
    }

    #form_login #login{
        text-align: center;
        margin-left:auto;
        margin-right:auto;
    }

    #form_login div{
        padding: 5px;
    }

    #form_login label {
            font-family: "Verdana", Arial;

            display: block;
            float: left;
            font-weight: bold;
            margin-right:20px;
            text-align: right;
            width: 100px;
            line-height: 25px;
            font-size: 15px;
    }

    #form_login h3{
        text-shadow: 1px 1px 1px #ccc;
            text-align: center;
            font-size: 14pt;
    }

    #form_login input[type="text"], input[type=password]{
            font-family: Arial, Verdana;
            font-size: 15px;
            font-weight: bold;
            padding: 5px;
            width: 60%;
            color: #000372;
    }

    .senha_errada{
        color: red;
    }
</style>

<form method="post" id="form_login" action="<%= request.getContextPath() %>/password-login">

    <h3><fmt:message key="jsp.login.password.heading"/></h3>

    <%
    if(request.getParameter("incorreto") != null){
    %>
    <div class="senha_errada">
        <fmt:message key="jsp.login.incorrect.text">
            <fmt:param><%= request.getContextPath() %>/forgot</fmt:param>
        </fmt:message>
    </div>
    <%
       }
    %>

    <div>
        <label for="tlogin_email">E-mail:</label>
        <input type="text" name="login_email" id="tlogin_email" />
    </div>

    <div>
        <label for="tlogin_password"><fmt:message key="jsp.components.login-form.password"/></label>
        <input type="password" name="login_password" id="tlogin_password" />
    </div>

        <div id="login">
    <input type="submit" class="button"  name="login_submit" value="<fmt:message key="jsp.components.login-form.login"/>" />
        </div>
    <div style="text-align: left;">
        <a href="<%= request.getContextPath() %>/register"><fmt:message key="jsp.components.login-form.newuser"/></a>
        <br /><br />
        <a href="<%= request.getContextPath() %>/forgot"><fmt:message key="jsp.components.login-form.forgot"/></a>
    </div>

</form>