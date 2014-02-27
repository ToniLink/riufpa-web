/*
 * Script para a validação dos metadados de acordo com o tipo de documento selecionado.
 * O uso deste script é preferencial para que se possa aplicar efeitos de tooltip nos campos
 * que não foram preenchidos ou foram preenchidos de maneira incorreta.
 * Ainda que o processo de submissão faça a validação também no servidor, ainda há algumas incoerências
 * nas especificações de campos obrigatórios por parte do 'input-forms.xml' o que inviabiliza a validação no lado
 * do servidor. Portanto, todas as especificações de metadados obrigatórios estão presentes neste script para
 * evitar as incoerências no servidor.
 * Atualmente, a incoerência é que o campo 'orientador' tem que ser obrigatório para as teses e dissertações, mas
 * se isso for especificado no 'input-forms.xml', os outros tipos de documentos também terão de preencher o campo
 * 'orientador', o que não é desejado. Portanto, o campo 'orientador' não está descrito como obrigatório no
 * 'input-forms.xml'.
 */

/*
 * Altera os estilos dos botões que adicionam ou removem novos campos.
 */
var form = $('edit_metadata');
var arr = form.getElements();
arr.each(function(item) {
    var nome = item.name;
    if (endsWith(nome, "add")){
        item.addClassName('button');
        //Não é preciso validar o formulário quando se replica um campo.
        Element.writeAttribute(item, 'onClick', 'naoValidar();');
    }
    if (nome.indexOf("remove_") !== -1){
        item.addClassName('button');
        //Não é preciso validar o formulário quando se exclui um campo.
        Element.writeAttribute(item, 'onClick', 'naoValidar();');
    }
});

/*
 * Retorna true se se 'str' termina com 'suffix', false caso contrário.
 */
function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}


//Insere uma id igual ao name do elemento, caso este elemento tenha id nulo.
arr = form.getElements();
arr.each(function(item) {
    var nome = item.name;
    var id = item.readAttribute('id');
    if(id == null){
        Element.writeAttribute(item, 'id', nome);
    }
});

/*
 * Valida um campo de data. Só deve aceitar dígitos.
 */
function validarData(event) {
    event = event || window.event;
    var charCode = event.which || event.keyCode;
    var charTyped = String.fromCharCode(charCode);
    if(charTyped.match(/[a-zA-Z]/)){
        return false;
    } else{
        return true;
    }
}


var novoTexto = "";

/*
 * Definições de tipos de documentos. Devem ser os mesmos valores especificados na classe 'EscolherTipoDoc'.
 */
var TIPO_ARTIGO = "ARTIGO_CIENTIFICO";
var TIPO_TESE = "TESE";
var TIPO_DISSERTACAO = "DISSERTACAO";
var TIPO_TRABALHO = "TRABALHO";
var TIPO_OUTRO = "OUTRO";

/*
 * Configura os nomes dos tipos de documentos com base no array 'tipos' na seguinte ordem:
 * 0- Artigo Científico
 * 1- Tese
 * 2- Dissertação
 * 3- Trabalho
 * 4- Outro
 */
function setTiposDoc(tipos){
    TIPO_ARTIGO = tipos[0];
    TIPO_TESE = tipos[1];
    TIPO_DISSERTACAO = tipos[2];
    TIPO_TRABALHO = tipos[3];
    TIPO_OUTRO = tipos[4];
}

function configurarCamposObrigatorios(tipo_documento){
switch (tipo_documento) {

    case TIPO_ARTIGO:
        configObrigArtigo();
        break;

    case TIPO_TESE:
        configObrigTeseDissertacao();
        break;

    case TIPO_DISSERTACAO:
        configObrigTeseDissertacao();
        break;

    case TIPO_TRABALHO:
        configObrigTrabalho();
        break;

    case TIPO_OUTRO:
        configObrigOutro();
        break;
}
obrigatorioAssunto();
obrigatorioResumo();
}

/*
* Chame este método quando um botão submit (voltar) não precisar fazer a validação do formulário.
*/
function naoValidar(){
    var form = $('edit_metadata');
    Element.writeAttribute(form, 'onsubmit', 'null');
}


function configObrigArtigo(){
    obrigatorioTitulo();
    obrigatorioAutores();
    obrigatorioReferencia();
    obrigatorioData();
}

function configObrigTeseDissertacao(){
    obrigatorioTitulo();
    obrigatorioAutores();
    obrigatorioReferencia();
    obrigatorioOrientadores();
    obrigatorioData();
}

function configObrigTrabalho(){
    obrigatorioTitulo();
    obrigatorioAutores();
    obrigatorioReferencia();
    obrigatorioData();
}

function configObrigOutro(){
    obrigatorioTitulo();
    obrigatorioAutores();
    obrigatorioReferencia();
    obrigatorioData();
}

/*
         * Verifica se o componente select, responsável por conter os tipos de documentos, possui um item selecionado.
         * Retorna true se houver um tipo de documento selecionado, false caso contrário.
         */
function verificarTipoDocumento(){
    var ok = true;
    var indice = $(tipo_documento).selectedIndex;
    if(indice === -1){
        alertar(tipo_documento, "Por favor, escolha um tipo de documento.");
        ok = false;
    }
    return ok;
}

function obrigatorioTitulo(){
    if($('dc_title')){
        inserir_obrigatoriedade('dc_title', /.*/i, 'Insira o título', 'Título inválido', true);
    }
}

function obrigatorioAutores(){
    if($('dc_contributor_author_last_1')){ //Já existe mais de um autor.
        inserir_obrigatoriedade('dc_contributor_author_last_1', /.*/i, 'Insira o último nome', 'Nome inválido', true);
        inserir_obrigatoriedade('dc_contributor_author_first_1', /.*/i, 'Insira os primeiros nomes', 'Nome inválido', true);
    } else if($('dc_contributor_author_last')){
        inserir_obrigatoriedade('dc_contributor_author_last', /.*/i, 'Insira o último nome', 'Nome inválido', true);
        inserir_obrigatoriedade('dc_contributor_author_first', /.*/i, 'Insira os primeiros nomes', 'Nome inválido', true);
    }
}

function obrigatorioOrientadores(){
    if($('dc_contributor_advisor_last_1')){ //Já existe mais de um orientador.
        inserir_obrigatoriedade('dc_contributor_advisor_last_1', /.*/i, 'Insira o último nome', 'Nome inválido', true);
        inserir_obrigatoriedade('dc_contributor_advisor_first_1', /.*/i, 'Insira os primeiros nomes', 'Nome inválido', true);
    } else if($('dc_contributor_advisor_last')){
        inserir_obrigatoriedade('dc_contributor_advisor_last', /.*/i, 'Insira o último nome', 'Nome inválido', true);
        inserir_obrigatoriedade('dc_contributor_advisor_first', /.*/i, 'Insira os primeiros nomes', 'Nome inválido', true);
    }
}

function obrigatorioData(){

    //Data de defesa
//    if($('dc_date_submitted_day')){
//        inserir_obrigatoriedade('dc_date_submitted_day', /(^$|[0-9]{1,2})?/i, 'Insira o dia', 'Digite um dia válido', false);
//    }
    if($('dc_date_submitted_year')){
        inserir_obrigatoriedade('dc_date_submitted_year', /[0-9]+/i, 'Insira pelo menos o ano da defesa', 'Digite um ano válido', true);
    }
    //Data de publicação
    if($('dc_date_issued_year')){
        inserir_obrigatoriedade('dc_date_issued_year', /[0-9]+/i, 'Insira pelo menos o ano da publicação', 'Digite um ano válido', true);
    }
//    if($('dc_date_issued_day')){
//        inserir_obrigatoriedade('dc_date_issued_day', /(^$|[0-9]{1,2})?/i, 'Insira o dia', 'Digite um dia válido', false);
//    }
}

function obrigatorioReferencia(){
    if($('dc_identifier_citation')){
        inserir_obrigatoriedade('dc_identifier_citation', /.*/i, 'Insira a referência', 'Digite uma referência válida', true);
    }
}

function obrigatorioIdentificador(){
    if($('dc_identifier_value')){
        inserir_obrigatoriedade('dc_identifier_value', /.*/i, 'Insira ao identificador', 'Digite um identificador válido', true);
    }
}

function obrigatorioAssunto(){
    if($('dc_subject_1')){
        inserir_obrigatoriedade('dc_subject_1', /.*/i, 'Insira uma palavra-chave', 'Digite uma palavra-chave válida', true);
    }
}

function obrigatorioResumo(){
    if($('dc_description_abstract_1_id')){ //Já existe mais de um abstract.
        inserir_obrigatoriedade('dc_description_abstract_1_id', /.*/i, 'Insira o resumo', 'Nome inválido', true);
    } else if($('dc_description_abstract_id')) {
        inserir_obrigatoriedade('dc_description_abstract_id', /.*/i, 'Insira o resumo', 'Nome inválido', true);
    }
}

function inserir_obrigatoriedade(id, padrao, msg_erro, msg_fora_padrao, presenca){
    var titulo = new LiveValidation( id, {
        validMessage: "",
        wait: 500,
        onlyOnSubmit: true
    } );

    if(presenca === true){
        titulo.add( Validate.Presence, {
            failureMessage: msg_erro
        } );
    }

    titulo.add( Validate.Format, {
        pattern: padrao,
        failureMessage: msg_fora_padrao
    } );
}


/*
 * Verifica se o componente select, responsável por conter os tipos de documentos, possui um item selecionado.
 * Retorna true se houver um tipo de documento selecionado, false caso contrário.
 */
function verificarTipoDocumento(){
    var ok = true;
    var indice = $(tipo_documento).selectedIndex;
    if(indice === -1){
        alertar(tipo_documento, "Por favor, escolha um tipo de documento.");
        ok = false;
    }
    return ok;
}

/*
 *
 */
function adicionarDescricao(elemento, descricao){

    var formulario = document.forms[0];
    var alvo;
    var target = true;

    if (elemento === "dc_contributor_author"){
        alvo = "dc_contributor_author_last";
        target = formulario.elements['submit_dc_contributor_author_add'];
    } else if (elemento === "dc_contributor_advisor"){
        alvo = "dc_contributor_advisor_last";
        target = formulario.elements['submit_dc_contributor_advisor_add'];
    } else if (elemento === "dc_contributor_other"){
        alvo = "dc_contributor_other_last";
        target = formulario.elements['submit_dc_contributor_other_add'];
    } else if (elemento === "dc_title"){
        alvo = "dc_title";
    } else if (elemento === "dc_date_submitted"){
        alvo = "dc_date_submitted_year";
    } else if (elemento === "dc_date_issued"){
        alvo = "dc_date_issued_year";
    } else if (elemento === "dc_publisher"){
        alvo = "dc_publisher";
    } else if (elemento === "dc_identifier_citation"){
        alvo = "dc_identifier_citation";
    } else if (elemento === "dc_relation_ispartofseries"){
        alvo = "dc_relation_ispartofseries_series_1";
        target = formulario.elements['submit_dc_relation_ispartofseries_add'];
    } else if (elemento === "dc_identifier"){
        alvo = "dc_identifier_value";
        target = formulario.elements['submit_dc_identifier_add'];
    } else if (elemento === "dc_type"){
        alvo = "dc_type";
    } else if (elemento === "dc_language_iso"){
        alvo = "dc_language_iso";
    }

    var el = formulario.elements[alvo];

    console.log(elemento);
    console.log(descricao);
    console.log(el);

    if(el !== undefined){

        $(el).addTip(descricao, {
            style: 'rounded',
            target: target,
            stem: false,
            tipJoint: [ "left", "middle" ],
            showOn: "focus",
            hideOn: "blur"
        });
    }
}


//=================================================================================================


/*
 * Alerta se o título do documento está no padrão [Artigo] [Letra maiúscula].
 * A única exceção é quando a segunda palavra é um nome próprio.
 * Exemplos:
 * Valor recebido       Valor sugerido
 * A Educação no Pará       A educação no Pará
 * Um história vaga         -
 * Um Brasil mais bonito    Um brasil mais bonito (É permitido que o usuário acate a sugestão)
 */
function verificarPadraoTitulo(){
    //Artigos seguidos de uma palavra com letra maiúscula.
    var regex = /(As?|Os?|Uma?|Umas?|Uns|The|An?) ([A-Z])(.*)/g;
    titulo = document.forms["edit_metadata"]["dc_title"].value;
    if(titulo.match(regex)){
        window.location.hash="dc_title";
        novoTexto = titulo.replace(regex, cnvrt);
        var alerta = "Parece que o título<br>" +
        "<b>\"" + titulo + "\"</b><br>" +
        "está formatado incorretamente.<br>" +
        " O correto é<br>" +
        "<b>\"" + novoTexto + "\"</b><br>" +
        "<button onclick=\"consertar(true)\" type=\"button\">CORRIGIR o texto</button><br>" +
        "<button onclick=\"consertar(false)\" type=\"button\">NÃO CORRIGIR o texto, sei o que estou fazendo. Pode ser um nome próprio.</button>";

        $('dc_title').addTip(alerta, {
            style: 'rounded',
            target: true,
            stem: true,
            tipJoint: [ "left", "middle" ],
            showOn: "creation",
            hideOn: "change"
        });

        return false;
    }

    return true;
}

function consertar(vai){
    if(vai){
        document.forms["edit_metadata"]["dc_title"].value = novoTexto;
    }
    document.forms["edit_metadata"].submit();
}

function cnvrt(){
    return arguments[1] + " " + arguments[2].toLowerCase() + arguments[3];
}