/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * Função para a tradução das palavras chaves para o Português.
 * Regras para o uso dos modificadores de busca:
 * 1- O usuário não pode pesquisar usando as palavras 'AND', 'NOT' ou 'OR', mas pode usar 'and', 'not' ou 'or'.
 * 2- O usuário pode pesquisar só pelas palavras 'E'/'e', 'NÃO'/'não' ou 'OU'/'ou'.
 * Exemplo de pesquisa:
 * Inserido                         Representação Interna (sempre em Inglês)
 * "Saúde E educação"               "Saúde AND educação"
 * "Superior OR educação"           "Superior OR educação"
 * "Superior OU educação"           "Superior OR educação"
 * @param campoTexto ID do campo em que o usário digitou a sua busca.
 * @param verdadeiro ID do campo no qual será inserida a busca (com os operadores booleanos já traduzidos).
 *                   *O servlet irá receber o valor contido neste campo*.
 */
function validarBusca(campoTexto, verdadeiro){
    var elemento = $(campoTexto);
    var busca = elemento.value;

    //O usuário não pode pesquisar usando somente as palavras 'AND', 'NOT' ou 'OR', mas pode usar
    //'and', 'not' ou 'or'.
    if(busca === 'AND' || busca === 'NOT' || busca === 'OR'){
        $(verdadeiro).value = busca.toLowerCase();
        return true;
    }
    //O usuário pode pesquisar só pelas palavras 'E', 'NÃO' ou 'OU'.
    if(busca === 'E' || busca === 'NÃO' || busca === 'OU'){
        $(verdadeiro).value = busca;
        return true;
    }
    //resto dos casos
    var novo = busca.replace(/\bE\b/g, "AND");
    novo = novo.replace(/\bNÃO\b/g, "NOT");
    novo = novo.replace(/\bOU\b/g, "OR");
    $(verdadeiro).value = novo;
    return true;
}

/*
 * Quando algum item mudar a opção de ordenação chame logo este método
 * assim o usuário não perde tempo clicando no botão de 'atualizar'.
 */
function ordenar(){
    if(validarBusca('texto_busca', 'texto_busca_verdadeiro')){

        var formulario = $("ordenar");
        formulario.submit();
    }
}

/* Procura pelas tags <sup> e <sub> e as renderiza. Por padrão, elas são mostradas pelo browser, como
 * &lt;sup&gt; ou &lt;sub&gt;
 */
function supSubescrito(){
    var vals = $$('td');
    for (var i = 0; i < vals.length; i++){
        var t = vals[i].innerHTML.replace(/(&lt;(su(p|b))&gt;(.*?)&lt;\/(su(p|b))&gt;)/gi, "<$2>$4</$5>");
        vals[i].innerHTML = t;
    }
}
document.observe('dom:loaded', supSubescrito);