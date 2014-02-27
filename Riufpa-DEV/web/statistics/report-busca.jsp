<%--
    Document   : report-busca
    Created on : 26/02/2013, 10:11:09
    Author     : Manoel Afonso
--%>


<%@page import="java.util.Arrays"%>
<%@page import="org.apache.lucene.search.Sort"%>
<%@page import="java.util.ArrayList"%>
<%@page import="sun.security.krb5.internal.KDCOptions"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>



<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    class Palavra implements Comparable<Palavra> {
        String palavra;
        String quant;

        public Palavra(String palavra, String quant) {
            this.palavra = palavra;
            this.quant = quant;
        }

            @Override
            public int compareTo(Palavra o) {
                int qtda = Integer.parseInt(this.quant);
                int qtda2= Integer.parseInt(o.quant);
                if(qtda>qtda2){
                   return -1;}
                else if(qtda==qtda2){return 0;}
                 
                      else{return 1;}
                
            }
        
        
        
        String getPalavra(){
         return palavra;
        }
        String getQuant(){
         return quant;
        }
    }

    /*
    String report = (String) request.getAttribute("report");

    String busca = "";
    
    */
    List<Palavra> lista = new ArrayList<Palavra>();  
   
    /*
    //retiramos um pedaço do report que mostrava os termos mais pesquisados
    //e colocamos na string busca...
    int inicio = report.indexOf("<div class=\"reportFloor\">(more than 3 times)");
    //<table class="reportBlock"
    int meio = report.indexOf("<table", inicio);
    int fim = report.indexOf("<div class=\"reportNavigation\"><a href=\"#ge", inicio);

    for (int j = meio; j < fim; j++) {
        busca = busca + report.charAt(j);
    }
*/
    try {
        BufferedReader in = new BufferedReader(new FileReader("/dspace/log/dspace-log-general-2013-8-19.dat"));
            String str;
            while (in.ready()) {
                str = in.readLine();
                System.out.println(str);
            }
            in.close();
    } catch (IOException e) {
    }

%>

<dspace:layout navbar="off" titlekey="jsp.statistics.report.title" >
 <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estatistica.css" type="text/css"/>

    <h1><fmt:message key="estatistica.titulo"/></h1>

    <dspace:include page="/statistics/navbar.jsp" />
    
    <table class="tabela">
        <tr id="tituloTabela">
            <td colspan="2"><fmt:message key="estatistica.palavrasMaispesquisadas"/></td>
        </tr>

        <tr>
            <th><fmt:message key="estatistica.busca"/></th>
            <th><fmt:message key="estatistica.qtde"/></th>
        </tr>
        <% 
        try {
             BufferedReader in = new BufferedReader(new FileReader("/dspace/log/dspace-log-general-last.dat"));
             String str;
             
              while (in.ready()) {
                str = in.readLine();
                if(str.contains("search.")){
                   String palavra = "";
                   String quant = "";
                   int ref = str.lastIndexOf("=");
                   
                   for(int i = 7 ; i < ref; i++){
                       palavra = palavra + str.charAt(i);
                   } 
                   for(int i = ref + 1; i < str.length(); i++){
                       quant = quant + str.charAt(i);
                   } 
                   
                   lista.add(new Palavra(palavra,quant));              
                   
                  }
                
                }
                in.close();
                } catch (IOException e) {
                }
                //int k=0;
                Collections.sort(lista);
                
                for(int k = 0 ; k < lista.size();k++ ){
                
               
                Palavra p = lista.get(k);    
                if( k % 2 == 0){ 
                
                %>

                   <tr>
                       <td><%= p.getPalavra() %></td>
                       <td class="qtde"><%= p.getQuant() %></td>
                   </tr>
                   <%    
                   }
                   else{%>

                   <tr class="stripe">
                       <td><%= p.getPalavra() %></td>
                       <td class="qtde"><%= p.getQuant() %></td>
                   </tr>
                   <%
                   
                   }
                    }
        %>
                
        
    </table>

    <%-- busca --%>

</dspace:layout>