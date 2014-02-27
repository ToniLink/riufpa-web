<%--
    Document   : manual-busca
    Created on : 11/07/2013, 09:59:09
    Author     : andrec
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<script type="text/javascript" src="<%= request.getContextPath()%>/utils.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/prototype.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/effects.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/builder.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/static/js/scriptaculous/controls.js"></script>

<script type="text/javascript">
    function mostrarSubComu(nome, perg) {
        if (document.getElementById(nome) !== null) {
            Effect.toggle(nome, 'appear', {duration: 0.4});
            Effect.ScrollTo(perg, { duration:'0.4'});
        }
    }
</script>

<style type="text/css">
    body {
        font-family: "verdana", Arial, Helvetica, sans-serif;
        font-size: 12pt;
        font-style: normal;
        color: #000000;
        background: white;
        padding: 0px;
        width: 95%;
        line-height: 25px;
    }

    .pergunta{
        background-color: #EBF0FD;
        font-family: "verdana", "Arial", "Helvetica", sans-serif;
    }
    .pergunta:hover{
        background-color: #D6E1FF;
    }
    .pergunta a{
        text-decoration: none;
        padding: 10px;
        display: block;
    }

    #img{
        position: relative;
        left: 25%;
    }

    #img2{
        position: relative;
        left: 5%;
    }

    #img3{
        position: relative;
        left: 15%;
    }

    #img4{
        position: relative;
        left: 10%;
    }

</style>

<h3 align="center">MANUAL DE PESQUISA DO RIUFPA</h3><br>

<div class="pergunta" id="P1">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R1', 'P1');">
        Como pesquisar no RIUFPA
    </a>
</div>
<div style="display:none " id="R1">
    <p>
        O processo de pesquisa no RIUFPA – Repositório Institucional da UFPA
        pode ser executado com o preenchimento do campo específico para a Busca Básica ou
        para a Busca Avançada localizado na página inicial do repositório.
    </p>
</div>

<div class="pergunta" id="P2">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R2', 'P2');">
        Busca Básica
    </a>
</div>
<div style="display:none " id="R2">
    <p>
        Digitar uma palavra ou texto na caixa de busca da página principal do <b>RIUFPA</b> e clicar em
        "Buscar"
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem2.jpg"/>

    <p>
        A partir da página de resultados, a busca básica pode ser redefinida por:
    </p>

    <ul>
        <li>Comunidade, Sub-comunidade e Coleção;</li>
        <li>Número de documentos apresentados por página;</li>
        <li>Relevância, data da publicação, título e data de publicação;</li>
        <li>Organizar os itens na ordem crescente ou decrescente;</li>
        <li>Número de autores por registro a serem visualizados.</li>
    </ul>

    <img id="img2" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem3.jpg"/>

</div>

<div class="pergunta" id="P3">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R3', 'P3');">
        Otimizar e racionalizar a estratégia de busca
    </a>
</div>
<div style="display:none " id="R3">

    <p>
        Para otimizar e racionalizar a estratégia de busca, seguir as regras:
    </p>

    <ul>
        <li>
            <b>Não usar</b>: artigos, preposições e conjunções.
        </li>
        <li>
            <b>Utilizar asterisco (*)</b> após parte da palavra digitada, indicando que a busca deve ser executada a partir daquele fragmento de palavra.
        </li>
    </ul>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem4.jpg"/>

    <p align="center">
        <i>
            Serão recuperados os documentos que contêm os termos:
            Inter<b>disciplinaridade</b>, Inter<b>ação</b>, Inter<b>textualidade</b>...
        </i>
    </p>

    <ul>
        <li>
            <b>Digitar</b> apenas a raiz da palavra como <code>amazon</code> e serão recuperadas suas
            variações <code>"<b>Amazôn</b>ia"</code>, <code>"<b>amazon</b>as"</code>,
            <code><b>amazon</b>ense</code>, etc.
        </li>
        <li>
            <b>Usar</b> entre aspas <b>("...")</b> termos compostos, frase ou várias palavras formando
            uma frase.
        </li>
    </ul>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem5.jpg"/>

    <p>
        <b>Usar o sinal (+)</b> antes da palavra a ser <b>obrigatoriamente</b> recuperada no resultado.
    </p>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem6.jpg"/>

    <p align="center">
        <i>
            Para o resultado da busca, a palavra <code>rio</code> é obrigatória, mas <code>madeira</code>
            é opcional.
        </i>
    </p>

    <ul>
        <li>
            <b>Usar o sinal (-)</b> antes da palavra que <b>não</b> deverá aparecer no resultado da busca.
            Alternativamente, para obter o mesmo resultado, pode-se utilizar o operador lógico <code>NÃO</code>.
        </li>

    </ul>


    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem7.jpg"/>

    <p align="center">
        ou
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem8.jpg"/>

    <p align="center">
        <i>
            Os itens na lista de resultado devem conter o termo <code>desenvolvimento</code>, exceto
            aqueles que contêm o termo <code>econômico</code>.
        </i>
    </p>


    <h3> <p> <strong>OPERADORES LÓGICOS</strong> </p></h3>


    <p>
        <b>Utilizar</b> operadores lógicos <code>E</code>, <code>OU</code> e <code>NÃO</code> para
        relacionar os termos de busca. É necessário que estejam em <b>CAIXA ALTA</b>.
    </p>

    <p>
        <strong><code>E</code></strong> - indica termos agrupados. A lista de resultados conterá todos os itens
        que possuem os dois termos.
    </p>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem9.jpg"/>

    <p align="center">
        <i>
            A lista de resultado contém os termos <code>rio</code> e <code>madeira</code>.
        </i>
    </p>

    <p>
        <strong><code>OU</code></strong> – usa-se para recuperar um termo ou outro, além daqueles itens que
        possuem os dois termos.
    </p>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem10.jpg"/>

    <p align="center">
        <i>
            A lista de resultado contêm os termos <code>rio</code> ou <code>madeira</code> ou os dois.
        </i>
    </p>

    <p>
        <strong><code>NÃO</code></strong> – A lista de resultado <b>não</b> deve conter o termo seguinte.
    </p>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem11.jpg"/>

    <p align="center">
        <i>
            Os itens na lista de resultado devem conter o termo <code>rio</code>, mas não <code>madeira</code>.
        </i>
    </p>

    <p>
        <b>Usar</b> parênteses para agrupar termos usando diferentes operadores. Fazer a
        união ou interseção ou exclusão de vários termos em única estratégia de busca.
    </p>

    <p>
        Exemplo:
    </p>

    <img id="img" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem12.jpg"/>

    <p align="center">
        <i>
            Os itens na lista de resultado devem conter o termo <code>rio</code>, mas não <code>madeira</code>
            e, conter o termo <code>navegabilidade</code> ou <code>poluição</code> ou os dois.
        </i>
    </p>

</div>



<div class="pergunta" id="P4">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R4', 'P4');">
        Busca Avançada
    </a>
</div>
<div style="display:none " id="R4">
    <p>
        <b>Clicar</b> na opção <b>Busca Avançada</b> localizada à direita da página inicial do RIUFPA.
    </p>

    <img width="100%" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem13.jpg"/>

    <p>
        A busca avançada <b>permite</b> especificar campos (palavras-chave, autor, título, assunto, resumo,
        série, órgão patrocinador, número identificador, idioma (ISO) e tipo de documento) a serem
        pesquisados e fazer combinações entre eles utilizando operadores lógicos <code>E</code>,
        <code>OU</code> ou <code>NÃO</code>.
    </p>

    <p>
        É possível restringir a pesquisa a uma comunidade, selecionando as opções de "buscar" na seta à direita
        da caixa superior. Para que a pesquisa possa abranger todo o Repositório, é necessário deixar a caixa
        na posição padrão "Em todo o repositório".
    </p>

    <p>
        <b>Selecionar</b> o campo desejado nas opções da coluna à esquerda da caixa de busca e digitar o termo
        no campo de busca à direita. Para utilizar mais de um campo, escolher o operador lógico entre campos.
    </p>

    <img id="img4" src="<%= request.getContextPath()%>/layout/imagens_manual_pesquisa/imagem14.jpg"/>

</div>