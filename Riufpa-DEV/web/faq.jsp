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
    div p{
        text-align: justify;
        padding-left: 30px;
    }

</style>

<h3 align="center">PERGUNTAS FREQUENTES</h3><br>

<div class="pergunta" id="P1">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R1', 'P1');">
        1. O que é RIUFPA?
    </a>
</div>
<div style="display:none " id="R1">
    <p>
        O Repositório Institucional da Universidade Federal do Pará – RIUFPA é um
        sistema de gerenciamento de material bibliográfico digital produzido pela
        comunidade acadêmica e técnica, avaliado por pares, publicado ou não pela
        UFPA e coordenado pela Biblioteca Central.
    </p>

</div>

<div class="pergunta" id="P2">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R2', 'P2');">
        2. Qual o objetivo do RIUFPA?
    </a>
</div>
<div style="display:none " id="R2">
    <ul>
        <li>
            Ordenar sistematicamente o material bibliográfico científico produzido pelos pesquisadores da UFPA
            e avaliado por pares;
        </li>
        <li>
            Dar visibilidade nacional e internacional à produção técnica e científica da Instituição;
        </li>
        <li>
            Participar ativamente do processo de acesso aberto em parceria com outras instituições;
        </li>
        <li>
            Preservar a memória científica da Universidade Federal do Pará.
        </li>
    </ul>
</div>

<div class="pergunta" id="P3">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R3', 'P3');">
        3. O que é acesso aberto?
    </a>
</div>
<div style="display:none " id="R3">
    <p>
        Movimento internacional recomendado pela CAPES – Coordenação de
        Pessoal de Nível Superior e incentivado pelo IBICT – Instituto Brasileiro de
        Informação Científica e Tecnológica para as Instituições Federais de Ensino
        Superior objetivando o acesso irrestrito e livre de taxas ou assinaturas a
        documentos técnicos e científicos digitais produzidos por essas instituições
        de ensino e pesquisa. Também conhecido como "Acesso Livre".
    </p>
</div>

<div class="pergunta" id="P4">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R4', 'P4');">
        4. O que é autodepósito no RIUFPA?
    </a>
</div>
<div style="display:none " id="R4">
    <p>
        Processo de registro, no RIUFPA, pelo próprio autor da obra, em conformidade com as normas do Repositório.
    </p>
</div>

<div class="pergunta" id="P5">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R5', 'P5');">
        5. Quais direitos de autor são concedidos para a UFPA quanto à publicação de documentos científicos dos seus
        pesquisadores no Repositório?
    </a>
</div>
<div style="display:none " id="R5">
    <p>
        O autor concede à Universidade Federal do Pará, por meio de assinatura do <b>Termo de Autorização</b>,
        uma <b>licença não exclusiva</b> para a Instituição arquivar, distribuir eletronicamente e tornar acessível
        sua obra em formato digital.
    </p>
</div>

<div class="pergunta" id="P6">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R6', 'P6');">
        6. O "Direito Autoral" continua garantido ao detentor da obra quando esta é publicada no RIUFPA?
    </a>
</div>
<div style="display:none " id="R6">
    <p>
        Sim. Os documentos são publicados no Repositório sob uma licença <i>Creative Commons</i>.
        Mais detalhes, no endereço <a href="http://www.creativecommons.org.br">http://www.creativecommons.org.br</a>.
        O uso da licença está vinculado aos termos de uso concedidos pelo autor no ato da sua assinatura no
        <b>Termo de Autorização de Licença Não Exclusiva</b> para a UFPA.
    </p>
</div>

<div class="pergunta" id="P7">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R7', 'P7');">
        7. O que devo fazer para incluir meu trabalho científico no RIUFPA?
    </a>
</div>
<div style="display:none " id="R7">
    <p>
        Na seção "Ajuda", página principal do Repositório, há o "Manual para o Depositante" com o passo a passo.
        Se necessário, a Biblioteca Central oferece treinamentos ou orientações sobre o autodepósito.
        Entrar em contato pelo e-mail <a href="mailto:riufpabc@ufpa.br">riufpabc@ufpa.br</a> ou pelos telefones
        3201-7787 ou 3201-7209 e falar com uma bibliotecária.
    </p>
</div>

<div class="pergunta" id="P8">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R8', 'P8');">
        8. O que é Item no Repositório?
    </a>
</div>
<div style="display:none " id="R8">
    <p>
        Item é cada documento indexado no RIUFPA.
    </p>
</div>

<div class="pergunta" id="P9">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R9', 'P9');">
        9. Que tipos de documentos serão recuperados na pesquisa bibliográfica feita no RIUFPA?
    </a>
</div>
<div style="display:none " id="R9">
    <p>
        Artigos científicos, livros, capítulos de livros, trabalhos apresentados e publicados em Anais de Eventos,
        teses e dissertações dos Programas de Pós-Graduação da UFPA.
    </p>
</div>

<div class="pergunta" id="P10">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R10', 'P10');">
        10. Como localizar os documentos no Repositório?
    </a>
</div>
<div style="display:none " id="R10">
    <p>
        Preenchendo as caixas de busca básica ou avançada (consultar o Manual), ou ainda, navegando no menu a esquerda
        da tela, pelas opções:
        <br>
        <b>Comunidades e Coleções</b> – visualiza as comunidades, subcomunidades e suas respectivas coleções;
        <br><br>
        Ou por meio dos índices:<br>
        <br>
        <b>Títulos</b> – são ordenados alfabeticamente e podem ser visualizados de três formas: lista geral, letra a
        letra ou digitando uma palavra na caixa de pesquisa.
        <br>
        <b>Data de Publicação</b> – apresenta uma lista na ordem cronológica da data de edição do documento.
        Pode ser na ordem ascendente (do mais antigo para o mais recente) ou descendente (do mais recente para o mais
        antigo). A lista pode ainda ser visualizada por um determinado ano e mês de publicação e na ordem alfabética de
        título.
        <br>
        <b>Autor</b> – ordenado alfabeticamente pelo último sobrenome do autor. Pode ser visualizado pela lista geral,
        letra a letra ou digitando o nome ou sobrenome do autor na caixa de pesquisa.
        <br>
        <b>Assunto</b> – ordenado alfabeticamente podendo ser visualizado por meio da lista geral, letra a letra ou
        ainda, digitando o assunto na caixa de pesquisa.
    </p>
</div>

<div class="pergunta" id="P11">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R11', 'P11');">
        11. Qual a diferença entre a busca básica e a busca avançada?
    </a>
</div>
<div style="display:none " id="R11">
    <p>
        A busca básica é realizada em todos os campos de pesquisa, ou seja, o termo <code>amazonas</code> será
        recuperado nos campos de metadados de autor, título, assunto, citação, etc. e na busca avançada, a recuperação
        é feita de acordo com os campos de metadados pré-estabelecidos pelo pesquisador.
        Exemplo: o termo <code>amazonas</code> será recuperado somente no campo de título, se assim preferir o
        pesquisador.
    </p>
</div>

<div class="pergunta" id="P12">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R12', 'P12');">
        12. Como é determinada a relevância de um documento no Repositório?
    </a>
</div>
<div style="display:none " id="R12">
    <p>
        Pelo número de vezes em que o termo digitado, pelo pesquisador, aparece nos documentos recuperados.
    </p>
</div>