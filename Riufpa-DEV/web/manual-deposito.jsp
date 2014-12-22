<%-- 
    Document   : manual-deposito
    Created on : 05/12/2014, 11:27:01
    Author     : Jefferson
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

<h3 align="center">MANUAL DE DEPÓSITO DO RIUFPA</h3><br>

<div class="pergunta" id="P1">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R1', 'P1');">
        Apresentação
    </a>
</div>
<div style="display:none " id="R1">
    <p>
        O funcionamento do repositório caracteriza-se por um conjunto de ações, que aliado às
práticas informacionais, estabelecem, consubstanciam e enriquecem os serviços oferecidos,
O depósito de conteúdos, descreve os elementos de cada documento no repositório.
Passos e instruções para o depósito de documentos no repositório da UFPA.

    </p>
</div>

<div class="pergunta" id="P2">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R2', 'P2');">
        Descrever, carregar e licenciar um Item no RIUFPA

    </a>
</div>
<div style="display:none " id="R2">
    <p>
        Ações determinadas para apresentação dos elementos de cada documento na <strong>Coleção</strong>
        designada, a partir do <strong>preenchimento dos metadados, carregamento do arquivo</strong> e <strong>atribuição
            da licença</strong>.

    </p>
    <ul>
        <li>Autoarquivamento: depósito executado pelo próprio autor da obra, vinculado à UFPA.</li>
        <li>Catalogador: bibliotecário designado para submeter, revisar, editar ou remover os
metadados até o envio ao administrador ou pessoa designada para publicar, revisar e liberar o
conteúdo para acesso.</li>
    </ul>    


</div>

<div class="pergunta" id="P3">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R3', 'P3');">
        Sistema de depósito
    </a>
</div>
<div style="display:none " id="R3">

    <p>
        Usuário novo deve preencher o Cadastro e criar uma senha de acesso ao repositório.
    </p>

    <img width="100%" src="<%= request.getContextPath()%>/layout/imagens_manual_deposito/imagem1.jpeg"/>
    
    
    <p>
        A partir das permissões e do <i>link</i> <strong>Meu Espaço</strong>, conecte-se com o sistema. Desta forma, é
necessário, digitar o e-mail e a senha de acesso e então, habilitar uma das caixas de entrada:
<strong>Iniciar submissão</strong>, ver as <strong>submissões aceitas, Veja suas assinaturas, Submissões em
    andamento</strong> e ainda, acompanhar as <strong>Submissões em processo de publicação, revisão e
        liberação</strong>.<br>
        A opção <strong>Abrir</strong> ao lado do título do documento abrirá a <strong>Área de Trabalho do Item</strong> para
        <strong>Editar, Visualizar</strong> ou <strong>Remover</strong> algum item.

    </p>

    
</div>



<div class="pergunta" id="P4">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R4', 'P4');">
        Adiar depósito
    </a>
</div>
<div style="display:none " id="R4">
    <p>
        As opções <strong>Cancelar/salvar</strong> em qualquer ponto do fluxo de trabalho, adia o processo de
        <strong>Submissão</strong>. A próxima página permite: <strong>Continuar submissão, Remover submissão</strong> ou
        confirmar a tarefa, <strong>Salvar e terminar mais tarde</strong>. As informações serão armazenadas até o
        retorno do catalogador ao <strong>Meu espaço</strong> e na opção <strong>Editar</strong>, completar o processo de depósito do
documento.

    </p>

</div>

 <div class="pergunta" id="P5">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R5', 'P5');">
        Fluxo de Trabalho
    </a>
</div>
<div style="display:none " id="R5">
    <p>
        É a sequência das funções de <strong>Descrever o item, Escolher o tipo de documento</strong> e
        <strong>Descrever, Carregar, Revisar, Licenciar</strong> e <strong>Concluir</strong> o depósito do conteúdo digital em
determinada coleção. Pode ser visualizado nos botões de navegação no topo da página. Com um
clique sobre cada um deles podem ser movidos para qualquer página de trabalho.


    </p>

</div>
    
<div class="pergunta" id="P6">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R6', 'P6');">
        Iniciar depósito
    </a>
</div>
<div style="display:none " id="R6">
    <p>
        Siga para o <strong>Meu espaço</strong> e habilite a função <strong>Iniciar Submissão</strong>

    </p>

</div>
    
<div class="pergunta" id="P7">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R7', 'P7');">
        Coleção
    </a>
</div>
<div style="display:none " id="R7">
    <p>
        Selecione a <strong>Coleção</strong> que corresponde ao conteúdo a ser submetido. Clique na opção, <strong>Próximo</strong>
        para prosseguir. Se preferir, ative o <strong>Índice de Comunidades e Coleções</strong> na barra lateral à
        esquerda, entre na Coleção desejada e clique na opção, <strong>Iniciar submissão</strong>.

    </p>

</div>    
<div class="pergunta" id="P8">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R8', 'P8');">
        Item
    </a>
</div>
<div style="display:none " id="R8">
    <p>
        Selecione na(s) caixa(s) à esquerda a(s) opção(ões) adequada(s) ao conteúdo e publicação do
        <strong>Item</strong>.

    </p>
    <ul>
        <li><strong>O Item possui mais de um título</strong> – um título equivalente, em outro idioma, abreviado
ou acrônimo, entre outros.</li>
        <li><strong>O Item apresenta mais de um arquivo</strong> – um arquivo para carregar/upload, em outro
idioma ou formato, imagens externas como vídeos, anexos e etc.
</li>
    </ul>

</div>
    
<div class="pergunta" id="P9">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R9', 'P9');">
        Tipo de documento
    </a>
</div>
<div style="display:none " id="R9">
    <p>
        Identifique a natureza do conteúdo do documento de acordo com as opções
correspondentes.
    </p>

</div> 
<div class="pergunta" id="P10">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R10', 'P10');">
        Descrição dos Metadados
    </a>
</div>
<div style="display:none " id="R10">
    <p>
        A busca nos índices de Título e Autor deve ser executada, antes de incluir os dados em
determinada Coleção para confirmar a existência ou não do documento no Repositório e assim,
evitar as duplicidades.

    </p>
    <ul>
            <li><strong>Autor</strong> <br> Pessoa física ou entidade, responsável pela criação do conteúdo intelectual do documento.
                Utilize a tecla <i>tab</i> ou o <i>mouse</i> para mover o cursor à direita e preencha os dados solicitados.
        Clique na opção <strong>Adicionar mais</strong>, se o documento apresentar mais de um autor.
            <ul>
                <li><strong>Autor pessoa física</strong>: preencha no primeiro espaço o SOBRENOME do autor em
        maiúsculas e o(s) prenome(s) no segundo espaço.
        </li>
        <li>descreva neste espaço <strong>todos os autores</strong> do documento, independente da quantidade (não
            utilize o termo, <i>et al</i>.);

        </li>
        <li>
            <strong>não</strong> inclua o ponto após o nome de autor;
        </li>
        <li>
            entre com o <strong>nome completo</strong> do autor;
        </li>
        <li>
            para manter a padronização do <strong>Índice de Autor</strong>, consulte o <i>Pergamum</i>, o <i>Currículo Lattes</i>, o
            <i>site</i> da UFPA, ou outras fontes confiáveis.

        </li>

            </ul>
        </li>
    <li>
        <strong>Orientador</strong><br>
        Descreva na caixa de entrada o nome do <strong>Orientador</strong> da tese ou dissertação. Siga as
        instruções do campo de Autor, para preencher esta informação.

    </li>
    <li>
        <strong>Coorientador</strong><br>
       Descreva o nome do <strong>Coorientador</strong> da tese ou dissertação. Para acrescentar este
       elemento, siga as recomendações do campo de Autor.
    </li>
    <li>
        <strong>Título</strong><br>
       Digite o <strong>Título</strong> pelo qual o documento é conhecido.
       <ul>
           <li>
               transcreva o título com a <strong>letra inicial</strong> em maiúscula e as demais de acordo com as <strong>regras
                   gramaticais</strong>;
        </li>
           <li>
               após o título, acrescente os <strong>dois pontos</strong> e adicione o <strong>subtítulo</strong> (título+dois
pontos+espaço+subtítulo) em letras minúsculas, exceto os nomes próprios, siglas, entre
outros, em acordo com as <strong>regras gramaticais</strong>;

        </li>
           <li>
               <strong>não</strong> inclua o ponto no final do título ou subtítulo ao preencher o formulário de
            metadados.

        </li>
       </ul>
    </li>
    
    <li>
        <strong>Outro(s) título(s)</strong><br>
        Acrescente neste espaço outro título relacionado à obra, como, um título em outro idioma. Para
        adicionar mais de um título alternativo, clique na opção <strong>Adicionar mais</strong>.
    </li>
    <li>
        <strong>Data de defesa</strong><br>
        dentifique o mês à direita da caixa e digite o dia e o ano de defesa da tese ou dissertação.
Adicione pelo menos, o ano da defesa.

    </li>
    <li>
        <strong>Data da publicação</strong><br>
        Selecione o mês na seta ao lado e digite o dia e ano da publicação. É obrigatório, preencher
pelo menos, o ano de publicação do documento.

    </li>
    <li>
        <strong>Referência</strong><br>
        Adicione os elementos que descrevem a <strong>Referência</strong> do documento. Para a descrição deste
elemento no RIUFPA, utilize a NBR 6023. Dependendo da relevância, qualquer informação
adicional, pertinente ao Item que está sendo depositado, deve ser descrito neste campo, como um
elemento complementar.

    </li>
    <li>
        <strong>Idioma</strong><br>
        Selecione na lista o <strong>Idioma</strong> principal do documento ou clique na opção <strong>Outros</strong> se a lista não
        contempla a língua do texto. Utilize a opção <strong>N/A</strong>, caso a relação não apresente uma língua
aplicável ao documento, pode ser um documento não textual (imagem, vídeo e etc.).
    </li>
    <li>
        <strong>Palavras-chave</strong><br>
        Digite neste campo os termos, relacionados ao conteúdo do documento. Ative o comando
        <strong>Adicionar mais</strong> na caixa lateral para indexar cada <strong>Assunto</strong>. Se preferir, utilize um vocabulário
específico para refinar a seleção dos termos sobre o conteúdo analisado.<br>
Para efeitos de padronização, antes de incluir qualquer <strong>termo</strong> no formulário de metadados,
pesquise no <strong>Índice de Assunto</strong> do RIUFPA a existência ou não do assunto.

    </li>
    <li>
        <strong>Resumo</strong><br>
       Copie e cole ou digite no formulário de depósito o <strong>Resumo</strong> na língua vernácula. Clique em
       <strong>Adicionar mais</strong> e inclua o Resumo em outro idioma, iniciando o texto na caixa de entrada com a
tradução da palavra Resumo em caixa alta, seguido por dois pontos. Exemplo: ABSTRACT: ou
RÉSUMÉ: ou RESUMEN: Inclua o ponto no final do Resumo.
    </li>
    <li>
        <strong>Agência financiadora</strong><br>
       Informações sobre o patrocinador ou o financiador da pesquisa. O preenchimento desta
       informação é livre. Se for pertinente, inclua este metadado no final da <strong>Referência</strong> como um
elemento complementar.

    </li>
    <li>
        <strong>Descrição</strong><br>
       Qualquer informação adicional, pertinente ao Item que está sendo submetido pode ser informada
neste campo. O preenchimento desta informação é livre. Dependendo da relevância, acrescentar
esta informação no final da <strong>Referência</strong>, como um elemento complementar.
    </li>
    <li>
        <strong>Editora</strong><br>
        Inclua o nome da Editora no campo de <strong>Referência</strong>.
    </li>
    <li>
        <strong>Série</strong><br>
        Digite o Nome e Número da Série quando o documento apresentar no final da <strong>Referência</strong>.
    </li>
    
    </ul>
</div>
    
<div class="pergunta" id="P11">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R11', 'P11');">
        Carregar arquivo
    </a>
</div>
<div style="display:none " id="R11">
    <p>
    <ul>
        <li>
            <strong>Enviar arquivo</strong><br>
            Clique sobre a caixa de entrada ou na opção <strong>Selecionar arquivo</strong> e siga até a lista dos
arquivos contidos no disco local, pastas ou diretórios do computador. Com dois cliques sobre o
arquivo escolhido, o mesmo é enviado e exibido na caixa de entrada. A caixa <strong>Descrição do
    Arquivo</strong> é para informação curta e objetiva sobre um arquivo. Clique em <strong>Próximo</strong> para
prosseguir com o Depósito.
        </li>
        <li>
            <strong>Arquivo carregado</strong><br>
            Para assegurar a autenticidade do <strong>Arquivo carregado com sucesso</strong>, na tela são exibidos
mais detalhes sobre o arquivo: executar download e confirmar o conteúdo do arquivo carregado,
remover ou substituir o arquivo, adicionar outro arquivo, alterar a descrição do arquivo, alterar o
formato do arquivo e calcular o checksum (verificador da integridade do arquivo pela comparação
da soma do documento submetido com a soma gerada pelo sistema no disco local). Clique em
<strong>Próximo</strong> para <strong>Revisar a submissão</strong> ou escolha outra opção para continuar.

        </li>
        <li>
            <strong>Carregar mais de um arquivo</strong><br>
            Para carregar outro(s) arquivo(s) tecle a opção <strong>Adicionar outro arquivo</strong>. Esta caixa de
            entrada será apresentada se a opção, <strong>Item apresenta mais de um arquivo</strong> for selecionada na
primeira página do formulário de metadados. Se o (s) arquivo(s) referente(s) ao Item for(am)
<strong>Carregado(s) com Sucesso</strong>, escolha a opção <strong>Próxima</strong> para executar a <strong>Revisão</strong> dos dados
depositados.

        </li>
        <li>
            <strong>Formatos de arquivos</strong><br>
            O Formato de um arquivo carregado será identificado em uma lista sugerida pelo Sistema.
            Caso o formato não seja reconhecido, clique na opção <strong>Alterar Formato</strong> e em seguida, digite as
            informações solicitadas. Prossiga com um clique na opção <strong>Depositar</strong>.

        </li>
        <li>
            <strong>Nomear arquivo</strong><br>
            Para nomear um arquivo no RIUFPA, inicie pelo tipo de documento seguido de <i>underline</i>
(traço baixo), em seguida, transcreva as três primeiras palavras do título do documento iniciadas
com letras maiúsculas. Evite o uso de artigos, contrações, acentuações, sinais de <i>cedilha</i> (ç) e til (~),
caracteres especiais, símbolos, fórmulas, equações, diagramas, entre outros.<br>
Exemplos: 1) Dissertacao_AvaliacaoCompreensaoLeitora;<br>
          2) Artigo_HermeneuticaGestalticaViolencia.

        </li>
        <li>
            <strong>Opções de segurança</strong><br>
            É necessário bloquear o arquivo de teses e dissertações, antes de submetê-lo no RIUFPA.
Libere o conteúdo somente para a impressão e extração de conteúdo para acessibilidade.

        </li>
    </ul>
    </p>

</div>
    
<div class="pergunta" id="P12">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R12', 'P12');">
        Revisar submissão
    </a>
</div>
<div style="display:none " id="R12">
    <p>
        Acione a opção, <strong>Corrigir um destes</strong>, para alterar um elemento ou revisar e confirmar as
informações que descrevem o conteúdo do Item submetido e ainda: checar o arquivo submetido,
mudar o formato do arquivo, substituir o arquivo submetido, carregar um arquivo diferente. Siga
para o <strong>Próximo</strong> passo.

    </p>

</div> 
<div class="pergunta" id="P13">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R13', 'P13');">
        Licenciar
    </a>
</div>
<div style="display:none " id="R13">
    <p>
        Utilize a licença <strong>Creative Commons</strong> para publicar um Item no RIUFPA em acordo com os
Direitos e a Autorização do Autor, sob as condições: não permitir uso comercial e nem executar
qualquer alteração na referida obra e a indicação da área de jurisdição. Siga as instruções e reveja
as opções selecionadas de acordo com a licença <i>CC</i>. Pressione o botão <strong>Escolha uma licença</strong> e
na próxima tela, ative o botão <strong>Prosseguir</strong>.
    <ul>
        <li>
            <strong>Licença de distribuição do Repositório</strong><br>
            Para submeter e disponibilizar qualquer documento no RIUFPA é necessário concordar com
            os termos da <strong>Licença de distribuição não exclusiva do repositório</strong>. Leia a licença,
            atenciosamente, e clique na opção <strong>Aceitar a licença</strong> para concluir o Depósito e a mesma entrar
no processo de publicação, revisão e liberação do Item no RIUFPA.

        </li>
    </ul>
    </p>

</div> 
    
<div class="pergunta" id="P14">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R14', 'P14');">
        Depósito completo
    </a>
</div>
<div style="display:none " id="R14">
    <p>
        Último passo para <strong>Concluir o Depósito</strong> do documento na Coleção escolhida. Pode ser
        visualizado na sequência de tarefas do <i>workflow</i> e então, aguardar o processo de publicação e
aprovação no RI. Um e-mail será enviado ao submetedor quando o Item se tornar parte da
Coleção ou por algum problema no depósito dos metadados. Para acompanhar o andamento da
submissão, retorne ao <strong>Meu espaço</strong> na área de trabalho e ative os botões das <strong>Submissões em
    processo de publicação, revisão e liberação</strong>. Ou ainda, na mesma tela, seguir para as
    <strong>Comunidades e coleções</strong> ou <strong>Submeter outro Item na mesma coleção</strong>.
    </p>

    
</div> 
<div class="pergunta" id="P15">
    <a href="javascript:void(0);" onclick="mostrarSubComu('R15', 'P15');">
        Handle
    </a>
</div>
<div style="display:none " id="R15">
    <p>
        Identificador único e persistente. Para cada documento armazenado é atribuído um URL,
para garantir a persistência dos objetos digitais na Internet. Os serviços devem ser solicitados ao
órgão internacional CNRI Handle System,<a href="http://www.handle.net/"> http://www.handle.net/</a>.<br>
<br>
Informações, dúvidas ou esclarecimentos, mantenha contato com a administração do RIUFPA


    </p>

    
</div> 