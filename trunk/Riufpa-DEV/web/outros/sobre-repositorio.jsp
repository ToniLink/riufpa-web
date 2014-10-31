<%-- 
    Document   : sobre-repositorio
    Created on : 01/10/2014, 09:19:28
    Author     : Jefferson
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>



<dspace:layout>
    <div class="areaHome">    
      
    
 <%
   String sobre = (String) request.getParameter("sobre");   
   
   if(sobre.equalsIgnoreCase("missao")){%>
   <h1>Missão:</h1>
   <p align ="justify">
      
       O RIUFPA tem como missão: reunir, organizar, armazenar, preservar e disponibilizar na Internet,
       textos completos de acesso aberto e livre de custos financeiros e que resultem da produção científica 
       e técnica dos docentes, pesquisadores, alunos de pós-graduação e técnicos da Instituição.
    
   </p> <br>
 <%      
   }else if(sobre.equalsIgnoreCase("objetivo")){%>
   <h1>Objetivos:</h1>
   <p>
       <br>
   <ul style="list-style-type:disc">
       <li>Organizar de forma sistemática os documentos digitais resultantes da produção
           científica e técnica da UFPA.</li><br>
       <li>Contribuir para dar visibilidade e aumentar o impacto da investigação desenvolvida na UFPA.</li><br>
       <li>Permitir o acesso aberto e livre de custos financeiros, através da Internet, da produção científica
       e técnica produzida na UFPA.</li><br>
       <li>Preservar a produção científica e técnica da UFPA.</li><br>
       <li>Participar ativamente, no esforço conjunto da comunidade científica nacional e internacional, no domínio do acesso
           livre a repositórios institucionais.</li> 
   </ul>    
   </p> <br>
 <%
   }else if(sobre.equalsIgnoreCase("conteudos")){%>
   <h1>Conteúdos:</h1>
   <p>
       Documentos digitais de trabalhos científicos e técnicos, avaliados
       por pares, produzidos pelos docentes, pesquisadores, alunos de pós-graduação e técnicos da UFPA:<br>
   <ul style="list-style-type:disc">
       <li>Artigos publicados em revista científica</li><br>
       <li>Dissertações</li><br>
       <li>Teses</li><br>
       <li>Livros</li><br>
       <li>Capítulos de livros</li><br>
       <li>Trabalhos apresentados em eventos e publicados em anais</li>
   </ul>
    </p> <br>
 <%
  }else if(sobre.equalsIgnoreCase("direitos")){%>
  <h1>Direitos de autor:</h1> 
  <p>
       Todas as obras submetidas no Repositório, após avaliação pela Biblioteca Central,
       serão disponibilizadas para acesso de acordo com autorização assinada pelo autor e sob uma licença Creative Commons,
       disponibilizadas no endereço <a href="http://www.repositório.ufpa.br">http://www.repositório.ufpa.br.</a> 
   </p><br>
 <%
 }else if(sobre.equalsIgnoreCase("organizacao")){%>
 <h1>Organização:</h1> 
 <p>
      O RIUFPA está organizado em comunidades, sub-comunidades e coleções.
      <br>
  <ul style="list-style-type:square">
      <li>As Comunidades correspondem às Unidades Orgânicas da UFPA</li> <br>
      <li>As sub‐comunidades correspondem aos Programas de Pós-Graduação e Faculdades</li><br>
      <li>As coleções correspondem aos tipos de documentos digitais passíveis de arquivamento no repositório.</li>
  </ul>
  
 </p> <br>
 <%
  } 
 %>
</div>   
 <dspace:sidebar>
        <dspace:include page="/layout/parceiros.jsp" />
 </dspace:sidebar>  
    
</dspace:layout>