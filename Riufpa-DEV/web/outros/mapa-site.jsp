<%--
    Document   : mapa-site
    Created on : 28/09/2012, 11:23:43
    Author     : portal
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="off" navbar="off" title="Mapa do site">

    <link rel="stylesheet" type="text/css" media="screen,print" href="<%= request.getContextPath()%>/static/css/mapa-site.css" />

    <div style="text-align: center; font-size: 16pt; color: #0332B2; font-weight: bold;">
        <fmt:message key="jsp.home.sitemap"/>
    </div>


    <div class="sitemap">

        <ul id="primaryNav" class="col4">
            <li id="home">
                <a href="<%= request.getContextPath()%>/">
                    <fmt:message key="jsp.layout.navbar-default.home"/>
                </a>
            </li>
            <li>
                <a href="javascript:void(0);">
                    <fmt:message key="jsp.navbar.indexes"/>
                </a>
                <ul>
                    <li>
                        <a href="<%= request.getContextPath()%>/community-list">
                            <fmt:message key="jsp.layout.navbar-default.communities-collections"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/browse?type=dateissued">
                            <fmt:message key="browse.menu.dateissued"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/browse?type=author">
                            <fmt:message key="browse.menu.author"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/browse?type=title">
                            <fmt:message key="browse.menu.title"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/browse?type=subject">
                            <fmt:message key="browse.menu.subject"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/browse?type=orientadorEcoorientador">
                            <fmt:message key="browse.menu.orientadorEcoorientador"/>
                        </a>
                    </li>
                </ul>
            </li>
            <li>
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
            <li>
                <a href="javascript:void(0);">
                    <fmt:message key="jsp.navbar.links"/>
                </a>
                <ul>
                    <li>
                        <a href="http://dspace.ibict.br/index.php?option=com_content&task=view&id=51&Itemid=94" target="_blank">
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
            <li>
                <a href="javascript:void(0);">
                    <fmt:message key="jsp.home.sitemap.services"/>
                </a>
                <ul>
                    <li>
                        <a href="<%= request.getContextPath()%>/mydspace">
                            <fmt:message key="navbar.mydspace.home"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/faleConosco">
                            <fmt:message key="jsp.navbar.contact"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/register">
                            <fmt:message key="jsp.navbar.signup"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/">
                            <fmt:message key="jsp.home.sitemap.search"/>
                        </a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath()%>/advanced-search">
                            <fmt:message key="jsp.home.sitemap.advancedsearch"/>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0);">
                            <fmt:message key="navbar.help.main"/>
                        </a>
                        <ul>
                            <li>
                                <a href="javascript:void(0);" onclick="TINY.box.show({iframe:'<%= request.getContextPath() %>/manual-busca.jsp', width: largura, height: altura, animate:false});">
                                    <fmt:message key="navbar.help.search"/>
                                </a>
                            </li>
                            <li>
                                <a href="javascript:void(0);" onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/manual-deposito.jsp', width: largura, height: altura, animate: false});">
                                    <fmt:message key="navbar.help.guia"/>
                                </a>
                            </li>
                            <li>
                                <a onclick="TINY.box.show({iframe:'<%= request.getContextPath()%>/faq.jsp', width: largura, height: altura, animate:false});" href="javascript:void(0);">
                                    <fmt:message key="navbar.help.faq"/>
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </li>
            <li>
                <a href= "<%=request.getContextPath()%>/Estatistica?nome=csc&publica=true">
                    <fmt:message key="jsp.layout.navbar-admin.statistics"/>
                </a> 
            </li>

        </ul>

    </div>

</dspace:layout>