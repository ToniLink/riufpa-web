/*
 * Script para tradução do nome do tipo de documento que por padrão está
 * em inglês e a submissão de formulários toda vez que uma opção de filtro
 * é
 */
function tradutor(){
var td = document.getElementsByTagName("strong");
for (var i = 0; i < td.length; i++) {

    var tex = td[i].innerHTML;

    if(trim(tex) === "article") {
        td[i].innerHTML = 'Artigo(s) de periódico';
    }
    if(trim(tex) === "masterThesis") {
        td[i].innerHTML = 'Dissertação(ões) (mestrado)';
    }
    if(trim(tex) === "All Items") {
        td[i].innerHTML = 'Todos os Items';
    }
    if(trim(tex) === "doctoralThesis") {
        td[i].innerHTML = 'Tese(s) (doutorado)';
    }
    if(trim(tex) === "conferenceObject") {
        td[i].innerHTML = 'Artigo(s) de evento';
    }
    if(trim(tex) === "review") {
        td[i].innerHTML = 'Resenha(s) de livro ou de artigo';
    }
}
}

/*
 * Retira os espaços em branco que estão no fim ou no início da string.
 */
function trim(str) {
    return str.replace(/^\s+|\s+$/g, "");
}

/*
 * Submete o formulário para alterar a ordem dos resultados.
 */
function alterarOrdem(){
    var form = document.getElementById("ordenacao");
    form.submit();
}

/*
 * Submete o formulário para alterar o tipo de documento que é exibido nos resultados.
 */
function alterarTipoDoc(){
    var form = document.getElementById("tipo_doc");
    form.submit();
}

/*
 * O primeiro passo é obter todas as tabelas, mas a que queremos é a qual cuja classe é 'miscTable', que é definida
 * pelo Dspace. Assim aplicamos a função de coloração nessas tabelas.
 */
function fgetAllDataTables() {
    if (!document.getElementsByTagName) {return false;}

    var eleTables = document.getElementsByTagName("table");
    for (var i=0; i < eleTables.length; i++) {
        if (eleTables[i].className === "miscTable") {
            fStripes(eleTables[i]);
        }
    }
    return true;
}

/*
 * Colore a tabela 'eleTable' de forma listrada (striped). Verifique no CSS os estilos que você deseja.
 */
function fStripes(eleTable) {
    eleTable.className = "tabela";

    /*Faz a listragem da tabela.*/
    var eleTableRows = eleTable.getElementsByTagName("tr");
    for (var i=0; i < eleTableRows.length; i+=2) {
        eleTableRows[i].className = "stripe";
    }

    var ths = $$('.tabela th', '.tabela td');
    for (var i = 0; i < ths.length; i++){
        removerClasses(ths[i]);
    }
}

/*
 * Remove todas as classe do elemento dado.
 * @param {type} elem
 * @returns {undefined}
 */
function removerClasses(elem){
    var classes = $w(elem.className);
    for(var j = 0; j < classes.length; j++){
        elem.removeClassName(classes[j]);
    }
}

document.observe('dom:loaded', fgetAllDataTables);
document.observe('dom:loaded', tradutor);