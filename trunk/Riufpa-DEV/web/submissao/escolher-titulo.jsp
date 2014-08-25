<%--
    Document   : escolher-tipo
    Created on : 19/03/2014, 10:07:07
    Author     : Jefferson
--%>


<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.submit.AbstractProcessingStep"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);
    //Indica se uma opção estará marcada (checked='checked').
    
    String teste = "o loco meu";
    
%>



<dspace:layout locbar="off"
               navbar="off"
               title="Escolher Título"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>
<%--action="<%= request.getContextPath()%>/mydspace" --%>
    <form  action="<%= request.getContextPath()%>/mydspace"  method="post">

        <div class="formularioDesc">

            <h3>Digite o Título</h3>
            
            <table id="tabelaMetadados">
                <td>
                    <strong>Título</strong>
                </td>    
        <!--   <input id="dc_title" type="text" name="dc_title" size="15" onkeyup="ajax_showOptions(this, 'starts_with', event, teste2, 'dc_title', 'null', 'titulo')" autocomplete="off" > -->
        <td>
            <input id="dc_title1" type="text"  value="" name="dc_title1" size="70" onkeyup="sugerirTitulo(this, event);" autocomplete="off" onclick="escreverTitulo()">
        </td>
        <td>
            
            <a class="button" href="javascript:void(0);" onclick="TINY.box.show({iframe: '<%= request.getContextPath()%>/browse?type=title&bt=true&starts_with='+ document.getElementById('dc_title1').value, width: largura, height: altura, animate: false});">
                                Verificar Título
            </a>
        </td>    
            </table>          
            <div id="controles">
                
                <div class="esquerda">
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE%>" />
                    <input type="submit" class="button" name="submit_new" value="<fmt:message key="jsp.submit.general.next"/>" />
                    
                </div>
            </div>

        </div>
    </form>
    
    
    <%  
        //request.setAttribute("titulo", request.getParameter("dc_title"));
       
     %>            
                <script type="text/javascript">
                    
                        
                        
                        function sugerirTitulo(input, e) {   
                                
                        ajax_showOptions(input, 'starts_with', e, null, null, null, 'titulo');
                                
                               
                        }
                        function escreverTitulo(){
                            var t2 = document.getElementById('dc_title1');
                            alert(t2.value);
                            
                        }
                         
               </script>

</dspace:layout>