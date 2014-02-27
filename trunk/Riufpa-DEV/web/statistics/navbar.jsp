<%--
    Document   : navbar
    Created on : 24/05/2013, 09:24:05
    Author     : portal
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style type="text/css">
    .fixed{
        /* fixed position a zero-height full width container */
        position: fixed !important;
        top: 0;
        left: 0;
        right: 0;
        height: 0;
        /* center all inline content */
        text-align: center;
        width: 90%;
        -webkit-box-shadow: 7px 7px 5px rgba(50, 50, 50, 0.75);
        -moz-box-shadow:    7px 7px 5px rgba(50, 50, 50, 0.75);
        box-shadow:         7px 7px 5px rgba(50, 50, 50, 0.75);
    }
    .fixed > ul {
        /* make the block inline */
        display: inline-block;
        /* reset container's center alignment */
        text-align: left;
    }

    .floating_menu{
        margin-left: auto;
        margin-right: auto;
    }
    .floating_menu ul{
        line-height: 15px;
        list-style-type: none;
        overflow: hidden;
        padding: 0;
        margin: 0 auto;
        background: #2E6AB1;
        width: 90%;
        border-bottom: 3px #C9D8FF solid;
    }
    .floating_menu ul li{
        float: left;

    }
    .floating_menu ul li a{
        position:relative;
        background: #2E6AB1;
        color:white;
        font-weight: bold;
        display: block;
        padding: 10px 20px;
        text-decoration: none;
    }
    .floating_menu ul li a:hover{
        background: #C9D8FF;
        color:black;
    }

    #sub_item{

    }
</style>

<div class="floating_menu">
    <ul id="side_tabs" >
        <li>
            <a href="<%= request.getContextPath()%>/Estatistica?nome=csc">
                <fmt:message key="estatistica.menu.comuSubcomuCol"/>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath()%>/Estatistica?nome=itens">
                <fmt:message key="estatistica.menu.items"/>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath()%>/Estatistica?nome=downloads-itens">
                <fmt:message key="estatistica.menu.downloads"/>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath()%>/Estatistica?nome=view-csc">
                <fmt:message key="estatistica.menu.views"/>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath()%>/Estatistica?nome=usuarios">
                <fmt:message key="estatistica.menu.users"/>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath()%>/Estatistica?nome=buscas">
                <fmt:message key="estatistica.menu.search"/>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath()%>/dspace-admin">
                <fmt:message key="estatistica.menu.back"/>
            </a>
        </li>
    </ul>
    <!--
    <ul id="sub_itens">
        <li><a href="#">Subitem 1</a></li>
        <li><a href="#">Subitem 2</a></li>
        <li><a href="#">Subitem 3</a></li>
    </ul>
    -->
</div>

<div id="copia"></div>

<script type="text/javascript">
    var floatingMenu = Class.create({
        initialize: function(elm, options) {
            elm.each(function(elm) {
                var copia;
                var menu = elm;
                var topOfMenu = menu.cumulativeOffset().top;
                Event.observe(window, 'scroll', function(evt) {
                    var y = document.viewport.getScrollOffsets().top;
                    if (y >= topOfMenu) {
                        copia = menu.clone(true);
                        $('copia').appendChild(copia);
                        copia.addClassName('fixed');
                    } else {
                        $('copia').update();
                    }
                });
            }.bind(this));
            this.options = Object.extend({}, options || {});
        }
    });

    document.observe("dom:loaded", function() {
        new floatingMenu($$('.floating_menu'));
    });
</script>