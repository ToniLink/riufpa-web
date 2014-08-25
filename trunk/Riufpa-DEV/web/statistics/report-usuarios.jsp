<%--
    Document   : report-items
    Created on : 18/09/2012, 11:36:23
    Author     : Jefferson
--%>

<%@page import="org.dspace.storage.rdbms.TableRow"%>
<%@page import="org.dspace.storage.rdbms.TableRowIterator"%>
<%@page import="org.dspace.storage.rdbms.DatabaseManager"%>
<%@page import="org.dspace.core.Context"%>
<%--
  - Renders a page containing a statistical summary of the repository usage
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    String report = (String) request.getAttribute("report");
    Context contexto = new Context();

    String nomeCompleto = "";
    String primeiroNome = "";
    String ultimoNome = "";
    String email = "";
    String acesso = "";
    String query = "";
    String query2 = "";
    String query3 = "";
    String query4 = "";
    String consulNome = "";
    long submetidos = 0;
    long aprovados = 0;
    long reprovados = 0;
%>

<dspace:layout navbar="off" titlekey="jsp.statistics.report.title">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>

    <h1><fmt:message key="estatistica.titulo"/></h1>

    <dspace:include page="/statistics/navbar.jsp" />


    <table class="tabela">

        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.usuarios"/></td>
        </tr>

        <tr>
            <td><b><fmt:message key="estatistica.totalUsuarios"/></b></td>
            <td class="qtde"><b>${requestScope.qtdeUsuarios}</b></td>
        </tr>

    </table>


        <table id="usuarios" class="tabela">

        <tr id="tituloTabela">
            <td colspan="5"><fmt:message key="estatistica.detalhesUsuarios"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.usuarioNome"/></th>
            <th><fmt:message key="estatistica.usuarioAcessos"/></th>
            <th><fmt:message key="estatistica.usuarioItensSub"/></th>
            <th><fmt:message key="estatistica.usuarioItensApr"/></th>
            <th><fmt:message key="estatistica.usuarioItensRepr"/></th>
        </tr>
        <%
            int cont = 0;
            //Essa consulta obtem as informações de nome e email dos usuarios
            //String query = "select firstname, lastname, email from eperson order by firstname, lastname";
              query = "select firstname , lastname, email from eperson where email not like '%new%' and email not like 'edisangel@gmail.com' and email not like 'paulo.malcher@icen.ufpa.br' order by firstname , lastname";
            if (contexto != null) {
                //é usado query quando as consultas retornam mais de uma linha
                //é necessario criar o iterator para ficar alternando as linhas
                TableRowIterator tr = DatabaseManager.query(contexto, query);
                //que é feito pelo .next()
                //o .hasNext() verifica se existe um próxima linha
                while (tr.hasNext()) {

                    TableRow tr2 = tr.next();
                    primeiroNome = tr2.getStringColumn("firstname");
                    ultimoNome = tr2.getStringColumn("lastname");
                    nomeCompleto = primeiroNome + " " + ultimoNome;
                    email = tr2.getStringColumn("email");
                    if(primeiroNome.equalsIgnoreCase("Albirene")){
                      consulNome = tr2.getStringColumn("firstname");   
                    }
                    else{consulNome = nomeCompleto; }
                    //esse consulta retorna a quantidade de items submetidos de acordo com primeiro nome
                    query2 = "select count(text_value) as total from metadatavalue where metadata_field_id = 28 and text_value like '%Submitted by " + consulNome + "%'";
                    TableRow tr3 = DatabaseManager.querySingle(contexto, query2);
                    submetidos = tr3.getLongColumn("total");
                    //esse consulta retorna a quantidade de items aprovados de acordo com primeiro nome
                    //query2 = "select count(text_value) as total from metadatavalue where metadata_field_id = 28 and text_value like '%Approved for%' and text_value like '%" + tr2.getStringColumn("firstname") + "%'";
                    //query2 = "select count(text_value) as total from metadatavalue where metadata_field_id = 28 and text_value like '%Approved for%' and text_value like '%by " + tr2.getStringColumn("firstname") + "%'";
                    query3 = "select count(text_value) as total from metadatavalue where metadata_field_id = 28 and text_value like '%Approved for entry into archive by " + consulNome + "%'";

                    tr3 = DatabaseManager.querySingle(contexto, query3);
                    aprovados = tr3.getLongColumn("total");
                    //esse consulta retorna a quantidade de items rejeitados de acordo com primeiro nome
                    query4 = "select count(text_value) as total from metadatavalue where metadata_field_id = 28 and text_value like '%Rejected by " + consulNome + "%'";
                    tr3 = DatabaseManager.querySingle(contexto, query4);
                    reprovados = tr3.getLongColumn("total");


                    //como não tem informações no banco de dados sobre acessos dos usuarios
                    //retiramos essa informação do report que é uma string
                    //partindo do ponto onde se encontra email do usuario na string report
                    //retornando um valor inteiro que representa o inicio da string
                    int inicio = report.indexOf(email);
                    //<table class="reportBlock"
                    //a partir desse ponto procuramos pela string abaixo que sera nosso meio
                    int meio = report.indexOf("<td class=", inicio);
                    // e desse meio procuramos o próximo termo que será o fim
                    int fim = report.indexOf("</tr>", meio);
                    acesso = "";
                    //do meio até o fim encontra-se o número de acesso do usuario em questão
                    for (int j = meio + 23; j < fim - 6; j++) {
                        acesso = acesso + report.charAt(j);
                    }
                    if(email.equalsIgnoreCase("")){acesso="0";}
                    
                    if (cont % 2 == 0) {

         if(inicio == -1){               
        %>
        
        <tr id="zero">
        <% }
                 else{
           %>    
        <tr>
            <%       }    
                    
                    } else {
             if(inicio == -1) {          
            %>
        <tr id="zero" class="stripe">
            <%      }  
             else{ %>
                          
        <tr class="stripe">             
            <%         
                     }
                    }
            %>
            <td><%out.println(nomeCompleto);%></td>
            <% if (inicio != -1) {%>
            <td class="qtde"><%out.println(acesso);%></td>
            <% } else {%>
            <td class="qtde">0</td>
            <%}%>
            <td class="qtde"> <%out.println(submetidos);%> </td>
            <td class="qtde"> <%out.println(aprovados);%> </td>
            <td class="qtde"> <%out.println(reprovados);%> </td>
        </tr>
        <%
                    cont++;
                }
            }

        %>
    </table>

    <table class="tabela">
        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.acessoExterno"/></td>
        </tr>

        <tr>
            <td><fmt:message key="estatistica.acessoExterno"/></td>
            <td class="qtde">—</td>
        </tr>
    </table>

    <%
            contexto.complete();
     %>
     
     <script>
         while(document.getElementById("zero")!==null){
         var tr = document.getElementById("zero");
          tr.parentNode.removeChild(tr);
         }
     </script>
</dspace:layout>