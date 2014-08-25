<%-- 
    Document   : editar-assunto
    Created on : 04/08/2014, 11:12:30
    Author     : Jefferson
--%>


<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<dspace:layout titlekey="jsp.dspace-admin.authorize-advanced.advanced"
               navbar="admin"
               locbar="link"
               parentlink="/dspace-admin"
               parenttitlekey="jsp.administer">
    
    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/editar-assunto.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/editar-assunto.css" type="text/css"/>
    
    
    <h1>Editar Palavra-chave</h1>
    <form id="editarAssunto" action="<%=request.getContextPath()%>/EditarAssunto" class="tabela" method="post" onsubmit="return validaCampo2(this);">
       
       
        <table >
            
         <tr>
             <td>          
        <h2>Informe a antiga palavra-chave : </h2>
             </td>
         </tr>
        <tr>
            <td>
        <input type="text" name="palavraAntiga" onkeyup="sugerirTitulo(this, event);" autocomplete="off" > <br>
            </td>
        </tr>
        <tr>
            <td>
                <h2>Informe a nova palavra-chave : </h2>
            </td>
         </tr>
         <tr>
             
             <td>
                 <input type="text" id="tassunto" name="palavraNova"> <br> <br>
             </td>
         </tr>    
         
         <tr>
             <td>
                    <input type="submit" class="button">
             </td>
         </tr>
        </table>
    </form>
    
    
     <script type="text/javascript">
                    
                        
                        
                        function sugerirTitulo(input, e) {   
                                
                        ajax_showOptions(input, 'starts_with', e, null, null, null, 'assunto');
                                
                        }

                        
                      

               </script>
    
</dspace:layout>
