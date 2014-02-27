<%--
    Document   : parceiros
    Created on : 10/10/2012, 10:22:46
    Author     : Manoel Afonso
--%>

<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<script type="text/javascript">
    var estilo = {style: 'rounded', stem: true, tipJoint: [ 'left', 'middle' ], target: true };
</script>

<%-- Estilos da barra de parceiros --%>
<link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/parceiros.css" type="text/css" />


<div class="parceiros">
    <br />
    <div><%--Sem padding no primeiro item--%>
        <a href="http://www.dspace.org/" target="_blank">
            <img src="<%= request.getContextPath()%>/image/parceiros/parceiro-dspace.jpg"
                 onmouseover="javascript:Tips.add(this, event, '<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.dspace") %>', estilo);"/>
        </a>
    </div>
    <div class="item">
        <a href="http://creativecommons.org/" target="_blank">
            <img src="<%= request.getContextPath()%>/image/parceiros/parceiro-cc.jpg"
                 onmouseover="javascript:Tips.add(this, event, '<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.cc") %>', estilo);"/>
        </a>
    </div>
    <div class="item">
        <a href="http://www.ibict.br/" target="_blank">
            <img src="<%= request.getContextPath()%>/image/parceiros/parceiro-ibict.jpg"
                 onmouseover="javascript:Tips.add(this, event, '<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.ibict") %>', estilo);"/>
        </a>
    </div>
    <div class="item">
        <a href="http://www.aedi.ufpa.br/" target="_blank">
            <img src="<%= request.getContextPath()%>/image/parceiros/parceiro-aedi.jpg"
                 onmouseover="javascript:Tips.add(this, event, '<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.aedi") %>', estilo);"/>
        </a>
    </div>
    <div class="item">
        <a href="http://repositorio.museu-goeldi.br/jspui/" target="_blank">
            <img src="<%= request.getContextPath()%>/image/parceiros/parceiro-museu.jpg"
                 onmouseover="javascript:Tips.add(this, event, '<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.museu") %>', estilo);"/>
        </a>
    </div>

    <br />

</div>

<div class="redesSociais">
    <a href="<%= request.getContextPath()%>/feed/atom_1.0/site" target="_blank">
        <img id="redes" src="<%= request.getContextPath()%>/image/redes/rss.png" alt="RSS Feed" border="0"
             title="<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.feed") %>" />
    </a>
    <a href="http://www.facebook.com/pages/Reposit%C3%B3rio-Institucional-da-Universidade-Federal-do-Par%C3%A1-RIUFPA/204021229731361" target="_blank">
        <img id="redes" src="<%= request.getContextPath()%>/image/redes/facebook.png" alt="RIUFPA Facebook" border="0"
             title="<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.facebook") %>" />
    </a>
    <a href="https://twitter.com/riufpa" target="_blank">
        <img id="redes" src="<%= request.getContextPath()%>/image/redes/twitter.png" alt="RIUFPA Twitter" border="0"
             title="<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.parceiros.twitter") %>"/>
    </a>
</div>