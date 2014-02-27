<%--
  - home.jsp
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
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>

<%
    //Community[] communities = (Community[]) request.getAttribute("communities");

    //Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    //String topNews = ConfigurationManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    //String sideNews = ConfigurationManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

    //boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    //String feedData = "NONE";
    //if (feedEnabled) {
    //    feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    //}

    //ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<dspace:layout locbar="off" titlekey="jsp.home.title">

    <%-- Estilos --%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/home.css" type="text/css" />

    <%-- Script para validação (tradução) da busca e detecção de navegadores antigos. --%>
    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/home.js"></script>

    <%-- Alerta para quando o usuário não está com o Javascript ativado. --%>
    <noscript>
    <div class="alerta">
        <p>
            O Javascript está desabilitado no seu navegador. Ative-o para tirar o máximo proveito do site.<br /><br />
            Se você usa o navegador Firefox:<br />
            Vá em <b>Opções > Conteúdo</b> e selecione a opção <b>Ativar Javascript</b>.<br /><br />
            Se você usa o navegador Chrome:<br />
            Vá em <b>Configurações > Mostrar Configurações Avançadas > Configurações de Conteúdo</b> e selecione a opção
            <b>Permitir que todos os sites executem JavaScript</b>.<br /><br />
            Se você usa o navegador Internet Explorer:<br />
            Vá em <b>Ferramentas > Opções da Internet > Segurança > Nível Personalizado > Script > Script Ativo</b>
            e marque a opção <b>Habilitar</b>.
        </p>
    </div>
    </noscript>

    <table class="areaHome">
        <tr>
            <td>
                <p style="color: #0332B2; text-align: center; font-size: 16pt; font-weight: bold; font-family: OxygenBold;">
                    <fmt:message key="jsp.home.header"/>
                </p>

                <p style="text-align: center;">
                    <fmt:message key="jsp.home.desc1"/>
                </p>
                <p align="justify">
                    <fmt:message key="jsp.home.desc2"/>
                </p>
            </td>
        </tr>
    </table>

    <br />

    <table class="areaHome">
        <tr>
            <td>

                <form class="formulariodemo cf" action="<%= request.getContextPath()%>/simple-search" method="get" onsubmit="return validarBusca();">
                    <table align="center">
                        <tr>
                            <td align="center">
                                <h3><label for="tquery"><fmt:message key="jsp.home.search2"/></label></h3>
                                <p>
                                    <input type="hidden" name="query" size="40" id="tquery" />
                                    <input type="text" maxlength="250" title="<fmt:message key="jsp.home.search.title"/>" id="texto_busca" required/>
                                    <button type="submit" id="btn_busca"><fmt:message key="jsp.home.search"/></button>
                                </p>
                            </td>
                        </tr>
                    </table>
                </form>


                <button style="float: right; margin: 10px;" type="button" onclick="parent.location='<%= request.getContextPath()%>/advanced-search';" class="button">
                    <img style="float: left;" src="<%= request.getContextPath()%>/layout/imagens/busca.png"></img>
                    <a style="line-height: 30px;" href="<%= request.getContextPath()%>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
                </button>
            </td>
        </tr>
    </table>
                    
    <dspace:sidebar>
        <dspace:include page="/layout/parceiros.jsp" />
    </dspace:sidebar>


</dspace:layout>