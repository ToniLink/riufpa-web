<%--
  - header-home.jsp
  -
  - Version: $Revision: 4646 $
  -
  - Date: $Date: 2009-12-23 06:42:08 +0000 (Wed, 23 Dec 2009) $
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

<%@page import="edu.harvard.hul.ois.mets.helper.parser.Context"%>
<%--
  - HTML header for main home page
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>
<%@ page import="org.dspace.eperson.EPerson" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String) request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List) request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String) request.getAttribute("dspace.layout.head");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace " + dsVersion;

    //Se há um usuário loggado pega o seu nome.
    String usuario = (String) session.getAttribute("nome_usuario");
    String nome = null;
    if (usuario != null) {
        nome = usuario;
    }

    //NAVEGADORES
    Integer minimumFirefox = 24;
    Integer minimumSafari = 51; /* This number is 10 times the actual version number */
    Integer minimumChrome = 30;
    Integer minimumIE = 9;

    String ua = request.getHeader("User-Agent");

    boolean isMSIE = (ua != null && ua.indexOf("MSIE") != -1);
    boolean isChrome = (ua != null && ua.indexOf("Chrome/") != -1);
    boolean isSafari = (!isChrome && (ua != null && ua.indexOf("Safari/") != -1));
    boolean isFirefox = (ua != null && ua.contains("Firefox"));

    String version = "1";
    if (isFirefox) {
        // Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0
        version = ua.replaceAll("^.*?Firefox/", "").replaceAll("\\.\\d+", "");
    } else if (isChrome) {
        // Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.52 Safari/536.5
        version = ua.replaceAll("^.*?Chrome/(\\d+)\\..*$", "$1");
    } else if (isSafari) {
        // Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2
        version = ua.replaceAll("^.*?Version/(\\d+)\\.(\\d+).*$", "$1$2");
    } else if (isMSIE) {
        // Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/5.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; .NET4.0C; .NET4.0E)
        version = ua.replaceAll("^.*?MSIE\\s+(\\d+).*$", "$1");
    }
    boolean unsupportedBrowser = (isFirefox && Integer.parseInt(version) < minimumFirefox)
    || (isChrome && Integer.parseInt(version) < minimumChrome)
    || (isSafari && Integer.parseInt(version) < minimumSafari)
    || (isMSIE && Integer.parseInt(version) < minimumIE);

%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= siteName%>: <%= title%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator%>" />
        <meta name="Description" content="Acesso à produção científica e acadêmica da Universidade Federal do Pará." />
        <link rel="stylesheet" href="<%= request.getContextPath()%>/styles.css.jsp" type="text/css" />
        <link rel="stylesheet" href="<%= request.getContextPath()%>/print.css" media="print" type="text/css" />
        <link rel="shortcut icon" href="<%= request.getContextPath()%>/image/favicon-riufpa.png" type="image/x-icon"/>
        <%
            if (!"NONE".equals(feedRef)) {
                for (int i = 0; i < parts.size(); i += 3) {
        %>
        <link rel="alternate" type="application/<%= (String) parts.get(i)%>" title="<%= (String) parts.get(i + 1)%>" href="<%= request.getContextPath()%>/feed/<%= (String) parts.get(i + 2)%>/<%= feedRef%>"/>
        <%
                }
            }

            if (osLink) {
        %>
        <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath()%>/<%= osCtx%>description.xml" title="<%= osName%>"/>
        <%
            }

            if (extraHeadData != null) {%>
        <%= extraHeadData%>
        <%
            }
        %>

        <%-- Prototype --%>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/prototype.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/scriptaculous.js?load=effects,slider"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/builder.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/controls.js"></script>

        <%-- Dspace --%>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/choice-support.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/utils.js"></script>

        <%-- Barra do governo --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/barra-brasil.css" type="text/css"/>

        <%-- Área de Alertas --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/header-default.css" type="text/css"/>

        <%-- Biblioteca para os Tooltips --%>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/opentip/opentip.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/js/opentip/opentip.css" type="text/css"/>
        <!--[if lt IE 9]><script src="<%= request.getContextPath()%>/static/js/opentip/excanvas.js"></script><![endif]-->

        <link rel="stylesheet" href="<%= request.getContextPath()%>/layout/menu_dropdown/menu_style.css" type="text/css"/>

        <%-- Botões --%>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/botoes.css" type="text/css"/>

        <%-- Biblioteca para a janela modal --%>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/tinybox/tinybox.js"></script>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/static/js/tinybox/style.css" type="text/css"/>

        <%-- Biblioteca para o botão "Ir para o topo da página"
        <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/riufpa/ir-topo.js"></script>--%>

        <%-- Biblioteca para o menu lateral (sidebar) --%>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/layout/menu/Menu.css"/>

        <%-- Estilos para os componentes Select. Não usar em IE8 ou anteriores.--%>
        <!--[if gt IE 9]><!-->
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/select.css"/>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/select.js"></script>
        <!--<![endif]-->

        <%-- Autocomplete. --%>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/js/autocomplete/autocomplete.css"/>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/autocomplete/ajax.js"></script>
        <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/autocomplete/ajax-dynamic-list.js"></script>
        <script type="text/javascript">
            set_caminho_servidor('<%= request.getContextPath() %>/sugerir');
        </script>

        <%-- Estilo do Painel --%>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/painel.css"/>

        <%-- Biblioteca para o menu de idiomas --%>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/static/css/idiomas.css"/>

    </head>

    <body>

        <script type="text/javascript">
            var viewport = document.viewport.getDimensions(); // Gets the viewport as an object literal
            var w = viewport.width; // Usable window width
            var h = viewport.height; // Usable window height

            var largura = w * 0.7;
            var altura = h * 0.85;
        </script>

        <%--Barra: Os componentes devem ser inseridos da direita para a esquerda pois float:right. --%>
        <div class="barraBrasil" id="topo">
            <%-- Apenas o fundo azul --%>
            <div class="completar"></div>
            <%-- Logo do governo --%>
            <a href="http://www.brasil.gov.br" title="Portal Brasil" target="_blank">
                <img src="<%= request.getContextPath()%>/layout/barraBrasil/logo_brasil.png"/>
            </a>
            <a href="http://www.acessoainformacao.gov.br" title="Acesso à Informação" target="_blank">
                <img src="<%= request.getContextPath()%>/layout/barraBrasil/acesso_info.png"/>
            </a>
            <%-- Listras --%>
            <div class="listras"></div>
        </div>

        <%-- Alerta de browsers antigos.--%>
        <%
        if(unsupportedBrowser){
            %>
        <div class="alerta" id="alerta">
            <p>
                <span class="mensagem">
                    <fmt:message key="jsp.header.browser"/>
                </span>
                <a href="https://www.google.com/chrome/" target="_blank" title="Google Chrome">
                    <img src="<%= request.getContextPath()%>/image/browsers/icone_chrome.png"/>
                </a>
                <a href="http://windows.microsoft.com/pt-BR/internet-explorer/downloads/ie" target="_blank" title="Internet Explorer">
                    <img src="<%= request.getContextPath()%>/image/browsers/icone_ie.png"/>
                </a>
                <a href="http://br.mozdev.org/download/" target="_blank" title="Mozilla Firefox">
                    <img src="<%= request.getContextPath()%>/image/browsers/icone_firefox.png"/>
                </a>
            </p>
        </div>
                <%
                }
                %>

        
        <div class="banner">
            <map name="mapa_banner">
                <area title="Página Inicial" shape="rect" coords="0,29,580,147" href="<%= request.getContextPath()%>/" />
            </map>
            <img usemap="#mapa_banner" src="<%= request.getContextPath()%>/image/banner_riufpa.jpg"/>
        </div>
        
        <%-- Banner do RIUFPA
        <div class="bannerteste">
            <div id="titulo">
                <a href="<%= request.getContextPath()%>/">
                    Repositório Institucional da Universidade Federal do Pará
                </a>
            </div>
        </div>
        --%>

        <div class="barraLocalizacao" id="barraLocalizacao">
            <%
                if (locbar) //se tiver a barra de localização, exibe.
                {
            %>
            <dspace:include page="/layout/location-bar.jsp" />
            <%    }
            %>
            <div class="menu">
                <ul>
                    <%
                        if (nome != null) { //alguém logado.
                    %>
                    <li>
                        <a href="<%= request.getContextPath()%>/mydspace"><%= nome%></a>
                        <ul>
                            <li>
                                <a href="<%= request.getContextPath()%>/mydspace">
                                    <fmt:message key="navbar.mydspace.home"/>
                                </a>
                            </li>
                            <li>
                                <a href="<%= request.getContextPath()%>/profile">
                                    <fmt:message key="navbar.mydspace.edit"/>
                                </a>
                            </li>
                            <li>
                                <a href="<%= request.getContextPath()%>/subscribe">
                                    <fmt:message key="navbar.mydspace.subscribed"/>
                                </a>
                            </li>
                            <li>
                                <a href="<%= request.getContextPath()%>/logout">
                                    <fmt:message key="navbar.mydspace.logout"/>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <%
                    } else { //visitante.
                    %>
                    <li>
                        <a href="<%= request.getContextPath()%>/mydspace">
                            <fmt:message key="navbar.mydspace.home"/>
                        </a>
                    </li>
                    <%
                        }
                    %>
                    <li>
                        <a href="javascript:void(0);" target="_self" >
                            <fmt:message key="navbar.help.main"/>
                        </a>
                        <ul>
                            <li>
                                <a href="javascript:void(0);" onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/manual-busca.jsp', width: largura, height: altura, animate: false});">
                                    <fmt:message key="navbar.help.search"/>
                                </a>
                            </li>
                            <li>
                                <a href="<%= request.getContextPath()%>/outros/em-construcao.jsp">
                                    <fmt:message key="navbar.help.site"/>
                                </a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/faq.jsp', width: largura, height: altura, animate: false});">
                                    <fmt:message key="navbar.help.faq"/>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>

        <%-- Localization --%>
        <%--  <c:if test="${param.locale != null}">--%>
        <%--   <fmt:setLocale value="${param.locale}" scope="session" /> --%>
        <%-- </c:if> --%>
        <%--        <fmt:setBundle basename="Messages" scope="session"/> --%>

        <%-- Page contents --%>

        <%-- HACK: width, border, cellspacing, cellpadding: for non-CSS compliant Netscape, Mozilla browsers --%>
        <table class="centralPane">

            <%-- HACK: valign: for non-CSS compliant Netscape browser --%>
            <tr valign="top">

                <%-- Navigation bar --%>
                <%
                    if (!navbar.equals("off")) {
                %>
                <td class="navigationBar">
                    <dspace:include page="<%= navbar%>" />
                </td>
                <%
                    }
                %>
                <%-- Page Content --%>

                <%-- HACK: width specified here for non-CSS compliant Netscape 4.x --%>
                <%-- HACK: Width shouldn't really be 100%, but omitting this means --%>
                <%--       navigation bar gets far too wide on certain pages --%>
                <td class="pageContents">