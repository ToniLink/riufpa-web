<%--
  - navbar-default.jsp
  -
  - Version: $Revision: 4020 $
  -
  - Date: $Date: 2009-07-03 03:55:39 +0000 (Fri, 03 Jul 2009) $
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

<%@page import="javax.servlet.jsp.jstl.core.Config"%>
<%@page import="org.dspace.core.I18nUtil"%>
<%@page import="java.util.Locale"%>
<%--
  - Default navigation bar
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf( '?' );
    if( c > -1 )
    {
        currentPage = currentPage.substring( 0, c );
    }


    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);

    // E-mail may have to be truncated
    String navbarEmail = null;

    if (user != null)
    {
        navbarEmail = user.getEmail();
        if (navbarEmail.length() > 18)
        {
            navbarEmail = navbarEmail.substring(0, 17) + "...";
        }
    }

    // get the browse indices

    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
%>


<div>
    <ul id="primary-nav">
        <li>
            <a href="<%= request.getContextPath() %>/">
                <fmt:message key="jsp.layout.navbar-default.home"/>
            </a>
        </li>
        <li class="menuparent">
            <a href="javascript:void(0);">
                <fmt:message key="jsp.navbar.indexes"/>
            </a>
            <ul>
                <li>
                    <a href="<%= request.getContextPath() %>/community-list">
                        <fmt:message key="jsp.layout.navbar-default.communities-collections"/>
                    </a>
                </li>
                <%
                for (int i = 0; i < bis.length-2; i++)
                {
                BrowseIndex bix = bis[i];
                String key = "browse.menu." + bix.getName();
                %>
                <li><a href="<%= request.getContextPath() %>/browse?type=<%= bix.getName() %>"><fmt:message key="<%= key %>"/></a></li>
                <%
                }
                %>
            </ul>
        </li>

        <li class="menuparent">
            <a href="javascript:void(0);">
                <fmt:message key="jsp.navbar.docs"/>
            </a>
            <ul>
                <li>
                    <a href="<%= request.getContextPath()%>/outros/em-autorizacao.jsp">
                        <fmt:message key="jsp.navbar.docs.politica"/>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath()%>/outros/em-autorizacao.jsp">
                        <fmt:message key="jsp.navbar.docs.pii"/>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath()%>/docs_riufpa/termo_de_autorizacao_do_autor.pdf" target="_blank">
                        <fmt:message key="jsp.navbar.docs.autorizacao"/>
                    </a>
                </li>
            </ul>
        </li>

        <li class="menuparent">
            <a href="javascript:void(0);">
                <fmt:message key="jsp.navbar.links"/>
            </a>
            <ul>
                <li>
                    <a href="http://www.ibict.br/informacao-para-ciencia-tecnologia-e-inovacao%20/repositorios-digitais/repositorios-brasileiros" target="_blank">
                        <fmt:message key="jsp.navbar.links.lista"/>
                    </a>
                </li>
                <li>
                    <a href="http://diadorim.ibict.br/" target="_blank">Diadorim</a>
                </li>
                <li>
                    <a href="http://www.sherpa.ac.uk/romeo/" target="_blank">Sherpa/RoMEO</a>
                </li>
                <li>
                    <a href="http://roar.eprints.org/" target="_blank">ROAR</a>
                </li>
                <li>
                    <a href="http://www.opendoar.org/" target="_blank">OpenDOAR</a>
                </li>
            </ul>
        </li>
        
        <li >
            <a href="<%= request.getContextPath() %>/Estatistica?nome=csc&publica=true">
                <fmt:message key="jsp.layout.navbar-admin.statistics"/>
            </a>
        </li>
        
<%
        if(user == null){
%>
        <li>
            <a href="<%= request.getContextPath() %>/register">
                <fmt:message key="jsp.navbar.signup"/>
            </a>
        </li>
<%
        }
%>
        <li>
            <a href="<%= request.getContextPath() %>/faleConosco">
                <fmt:message key="jsp.navbar.contact"/>
            </a>
        </li>
        <%-- Acrescenta uma opção específica para o administrador --%>
        <%
        if (isAdmin) {
        %>
        <li>
            <a href="<%= request.getContextPath() %>/dspace-admin">
                <fmt:message key="jsp.administer"/>
            </a>
        </li>
        <%
        }
        %>

        <hr/>

            <%
                if (supportedLocales != null && supportedLocales.length > 1) {
            %>


            <form method="get" name="repost" action="">
                <input type="hidden" name="locale"/>
            </form>
            <div id="bandeiras">
            <a>
                <img class="idiomas" src="<%= request.getContextPath()%>/image/idiomas/Brazil.png" alt="Português"
                     border="0" title="Português"
                     onclick="javascript:document.repost.locale.value = 'default'; document.repost.submit();" />
            </a>
            <a>
                <img class="idiomas" src="<%= request.getContextPath()%>/image/idiomas/United-States.png" alt="English"
                     border="0" title="English"
                     onclick="javascript:document.repost.locale.value = 'en'; document.repost.submit();"/>
            </a>
                <%--
            <a>
                <img class="idiomas" src="<%= request.getContextPath()%>/image/idiomas/Spain.png" alt="Español"
                     border="0" title="Español"
                     onclick="javascript:document.repost.locale.value = 'es'; document.repost.submit();"/>
            </a>
                --%>
            </div>
            <%
                }
            %>


    </ul>
</div>