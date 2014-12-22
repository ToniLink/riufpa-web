<%-- 
    Document   : politicas
    Created on : 28/11/2014, 09:40:37
    Author     : jefferson
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>



<dspace:layout>
    <div class="areaHome">    
      
    
 <%
   String politica = (String) request.getParameter("politica");   
   
   if(politica.equalsIgnoreCase("conteudo")){%>
   <h1>Conteúdo:</h1>
   <p align ="justify">
      São documentos passiveis de depósito no RIUFPA:<br>
      <ul style="list-style-type:disc"> 
          <li>Artigos publicados em revista científica, na qual haja processo de seleção por
           meio de revisão por pares;</li><br>
          <li>Trabalhos apresentados em eventos acadêmicos/científicos, nos quais haja
           processo de seleção por meio de revisão por pares e publicados em Anais;</li><br>
          <li>Dissertações e teses, após avaliadas por banca específica;</li><br>
          <li>Livros ou capítulos de livros, editados e publicados pela Editora da UFPA;</li><br>
          <li>Outros tipos de documentos que venham a ser considerados relevantes pela
           equipe técnica do RIUFPA.</li><br>
          
      </ul>    
   </p> <br>
 <%      
   }else if(politica.equalsIgnoreCase("gerenciamento")){%>
   <h1>Gerenciamento:</h1>
   <p>
       Atores do RIUFPA e suas respectivas funções:<br>
   <ul style="list-style-type:disc">
       <li><strong>Gestor (bibliotecário):</strong> responsável pela gestão e políticas do repositório.</li><br>
       <li><strong>Administrador (bibliotecário/informático):</strong> responsável pela customização de
        software, revisão de metadados, liberação do arquivo para acesso público e pela 
        manutenção do repositório;</li><br>
       <li><strong>Depositante (bibliotecário/Docente/discente autor):</strong> responsável pela submissão de
        conteúdos científicos no repositório.</li><br>
       
   </ul>    
   </p> <br>
 <%
   }else if(politica.equalsIgnoreCase("direitos")){%>
   <h1>Direitos autorais:</h1>
   <p>
      Todos os direitos de autor/copyright são do(s) autor(es), a menos que este(s) os 
      tenha(m) transmitido/cedido formalmente e explicitamente a terceiros. As condições em 
      que o(s) autor(es) cede(m) os seus direitos (geralmente aos editores) são variáveis.<br>
      Em muitos casos, eles continuam a permitir o autoarquivamento de uma cópia do
      trabalho em servidores institucionais ou pessoais.<br>
      A simples publicação de um trabalho (nos anais de uma conferência, numa
      revista entre outros) sem essa explícita transferência de direitos não afeta a integridade 
      dos direitos do(s) autor(es), nomeadamente o direito de autoarquivamento do seu 
      trabalho em repositórios, ou de difundirem-no por outros meios. O uso da Licença 
      <i>Creative Commons</i> (CC) tem como objetivo permitir o uso irrestrito, distribuição e 
      reprodução em qualquer meio, desde que o autor original e fonte sejam creditados<sub>1</sub>.<br>
      Para consultar a permissão de depósito de publicações científicas nos Repositórios, acessar o portal Diadorim <a href="www.diadorim.ibict.br">(www.diadorim.ibict.br)</a> para periódicos 
      brasileiros que seguem a mesma política do sistema de classificação do <i>Sherpa/Romeo</i>, 
      portal para consulta de revistas estrangeiras <a href="http://www.sherpa.ac.uk/romeo/">(http://www.sherpa.ac.uk/romeo/)</a>.<br>
      Caso o autor não encontre a Licença <i>Creative Commons</i> nesses portais ou no site da
      revista e não se lembre do tipo de licença concedido ao editor, pode solicitar autorização 
      à editora para autoarquivar o seu documento no repositório.
      <br>
      <br>
      <br>
      1 Mais informações sobre a Licença Creative Commons podem ser consultadas no site Disponível em:
      <a href="http://creativecommons.org/">http://creativecommons.org/</a>.
   </p> <br>
 <%
  }else if(politica.equalsIgnoreCase("subdep")){%>
  <h1>Submissão/Depósito:</h1> 
  <p>
       O RIUFPA é composto pelo depósito da produção intelectual gerada na UFPA pela
       autoria ou co-autoria de docentes, discentes de mestrado e doutorado, pesquisadores e 
       técnicos.<br>
       A submissão de qualquer arquivo deverá ser realizada pelo autor, co-autor ou por um
       mediador, aderindo a Licença Creative Commons e a Licença de Distribuição Não-
       Exclusiva disponibilizadas no site do RIUFPA.<br>
       O autor deve acessar o site do RIUFPA, realizar a submissão e inserir os metadados
       correspondentes para efetuar o depósito do arquivo. Os autores serão os responsáveis 
       pelo conteúdo que irão submeter, bem como verificar questões legais de depósito junto 
       aos editores.
   </p><br>
 <%
 }else if(politica.equalsIgnoreCase("preservacao")){%>
 <h1>Preservação:</h1> 
 <p>
      Dentro do contexto digital, torna-se oportuna a implementação de técnicas e políticas
      para garantir a longevidade e a acessibilidade dessa informação. Níveis de preservação 
      digital no RIUFPA:
      <br>
  <ul style="list-style-type:square">
      <li>Preservação dos Bits: para garantir que o arquivo continue exatamente o mesmo
       com o passar do tempo, mesmo que a mídia física evolua com o passar dos anos;</li> <br>
      <li>Backup do banco de dados: para garantir a integridade e segurança das
       informações armazenadas, em casos fortuitos;</li><br>
      <li>URL persistentes - uma das características dos repositórios digitais é garantir
       acesso perpétuo aos documentos depositados, assim o identificador persistente 
       irá assegurar, por intermédio de links sempre acionáveis, o acesso a recursos que 
       tenham sido movidos.</li>
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
