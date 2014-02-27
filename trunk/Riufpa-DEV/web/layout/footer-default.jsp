<%--
  -- footer-home.jsp
  --
  -- Version: $Revision: 3705 $
  --
  -- Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
  --
  -- Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  -- Institute of Technology.  All rights reserved.
  --
  -- Redistribution and use in source and binary forms, with or without
  -- modification, are permitted provided that the following conditions are
  -- met:
  --
  -- - Redistributions of source code must retain the above copyright
  -- notice, this list of conditions and the following disclaimer.
  --
  -- - Redistributions in binary form must reproduce the above copyright
  -- notice, this list of conditions and the following disclaimer in the
  -- documentation and/or other materials provided with the distribution.
  --
  -- - Neither the name of the Hewlett-Packard Company nor the name of the
  -- Massachusetts Institute of Technology nor the names of their
  -- contributors may be used to endorse or promote products derived from
  -- this software without specific prior written permission.
  --
  -- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  -- ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  -- LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  -- A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  -- HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  -- INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  -- BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  -- OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  -- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  -- TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  -- USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  -- DAMAGE.
--%>

<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%--
  - Footer for home page
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/footer-default.js"></script>
<link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/footer-default.css" type="text/css"/>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
    int overallColSpan = 3;
    if (sidebar == null) {
        overallColSpan = 2;
    }
%>
<%-- End of page content --%>
<p>&nbsp;</p>
</td>

<%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null) {
%>
<td class="sidebar">
    <%= sidebar%>
</td>
<%
    }
%>
</tr>

</table>

<%--
<div class="ir_topo" id="ir_topo" style="display: none">
    <img title="Vai subir?" src="<%= request.getContextPath()%>/image/ir_topo.png" onclick="new Effect.ScrollTo('topo',{offset:-20}); return false"/>
</div>
--%>

<div class="area_rodape">

    <div id="logos">
        <a href="http://www.portal.ufpa.br/" target="_blank" title="<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.footer.ufpa") %>">
            <img alt="UFPA" border="0" src="<%= request.getContextPath()%>/image/logo-ufpa.png"/>
        </a>
        &nbsp;&nbsp;
        <a href="http://bc.ufpa.br/site/" target="_blank" title="<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.footer.bc") %>">
            <img alt="Biblioteca Central" border="0" src="<%= request.getContextPath()%>/image/bc-logo.png"/>
        </a>
    </div>

    <div id="info">
        Universidade Federal do Pará<br />
        Biblioteca Central Prof. Dr. Clodoaldo Beckmann <br />
        Rua Augusto Corrêa, n. 1 – CEP 66075-110 Belém – PA <br />
        Tel. +55 (91) 3201-7110 / 3201-7787 / 3201-7209 - Fax: +55 (91) 3201-7351<br />

        Email: riufpabc@ufpa.br<br /> 


        <a href="<%= request.getContextPath()%>/creditos" class="secaoCreditos">
            <fmt:message key="jsp.home.credits"/>
        </a>
        |
        <a href="<%= request.getContextPath()%>/mapa" class="secaoSitemap">
            <fmt:message key="jsp.home.sitemap"/>
        </a>
    </div>

</div>
</body>
</html>