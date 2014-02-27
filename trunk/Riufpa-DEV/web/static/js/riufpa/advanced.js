/*
 * Scripts para a página de busca avançada.
 */

function TipoDoc () {
    this.article = "";
    this.masterThesis = "";
    this.doctoralThesis = "";
    this.review = "";
    this.conferenceObject = "";
    this.getInfo = function (){
        return "";
    };
}

/*
 *Quando uma comboBox 'sel', muda de item selecionado esta função verifica se tal item tem value='type' (Tipo de Documento),
 *e se tiver, exibe o componente select dos tipos de documento 'listaTipoDoc' adequada,
 *e oculta o seu campo de pesquisa 'campoPesquisa' correspondente. O valor inicial para os tipos de documentos é Artigo.
 */
function exibirBusca(sel, listaTipoDoc, campoPesquisa) {
    var value = sel.options[sel.selectedIndex].value;
    if (value === 'type') { //se for tipo de documento.
        $(listaTipoDoc).up().show();
        Effect.toggle(listaTipoDoc, 'appear', {duration: 0.3});
        $(campoPesquisa).style.display = 'none';
        $(listaTipoDoc).options[0].selected = true;
        $(campoPesquisa).value = "article";
    } else {
        $(listaTipoDoc).up().hide();
        $(listaTipoDoc).style.display = 'none';
        $(campoPesquisa).value = "";
        $(campoPesquisa).style.display = 'block';
    }
}

/*
 *Preenche o 'campo' com o valor correspondente ao item selecionado na comboBox 'sel', a qual deve possuir a
 *listagem dos tipos de documentos.
 */
function preencherCampo(sel, campo) {
    var texto = $(sel).options[$(sel).selectedIndex].text;

    if (texto === TipoDoc.article) {
        preenche("article", campo);
    } else if (texto === TipoDoc.masterThesis) {
        preenche("masterThesis", campo);
    } else if (texto === TipoDoc.doctoralThesis) {
        preenche("doctoralThesis", campo);
    } else if (texto === TipoDoc.review) {
        preenche("review", campo);
    } else if (texto === TipoDoc.conferenceObject) {
        preenche("conferenceObject", campo);
    }
}

/*
 *Preenche um campo de pesquisa 'campo' com 'str'. Em geral, porque foi selecionado um tipo de documento, logo,
 *a palavra-chave deve ser uma chave do Dspace, e não uma palavra qualquer.
 */
function preenche(str, campo) {
    $(campo).value = str;
}

/*
 *Limpa os campos de pesquisa. Não usamos o botão do Dspace, mas sim este script porque assim os estados dos
 *comboBoxes não são alterados.
 */
function limpar() {
    //Combobox's com os tipos de busca.
    var tipo1 = $("tfield1");
    var tipo2 = $("field2");
    var tipo3 = $("field3");

    //Campos de busca.
    var campo1 = $("tquery1");
    var campo2 = $("query2");
    var campo3 = $("query3");

    //Combobox's com os tipos de documentos.
    var combobox1 = $("tipo_doc");
    var combobox2 = $("tipo_doc2");
    var combobox3 = $("tipo_doc3");

    //Combobox's com as conjunções (E/OU)
    var conj1 = $("conjunction1");
    var conj2 = $("conjunction2");

    //Apaga todos os textos dos campos.
    campo1.value = "";
    campo2.value = "";
    campo3.value = "";

    //Oculta as combobox's com os tipos de documento se estiverem visíveis e
    //exibe os campos de busca.
    if (combobox1.style.display !== "none") {
        combobox1.up().hide();
        combobox1.style.display = "none";
        campo1.style.display = "block";
    }
    if (combobox2.style.display !== "none") {
        combobox2.up().hide();
        combobox2.style.display = "none";
        campo2.style.display = "block";
    }
    if (combobox3.style.display !== "none") {
        combobox3.up().hide();
        combobox3.style.display = "none";
        campo3.style.display = "block";
    }

    //Reseta os tipos de busca
    tipo1.selectedIndex = 0;
    tipo2.selectedIndex = 0;
    tipo3.selectedIndex = 0;

    //Reseta as conjunções
    conj1.selectedIndex = 0;
    conj2.selectedIndex = 0;

}