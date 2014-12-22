/*
* Conjunto de scripts para a formatação e correção da página 'display-item'.
*/

/* Procura pelas tags <sup> e <sub> e as renderiza. Por padrão, elas são mostradas pelo browser, como
 * &lt;sup&gt; ou &lt;sub&gt;
 */
function supSubescrito(){
    var vals = $$('td.metadataFieldValue');
    for (var i = 0; i < vals.length; i++){
        var t = vals[i].innerHTML.replace(/(&lt;(su(p|b))&gt;(.*?)&lt;\/(su(p|b))&gt;)/gi, "<$2>$4</$5>");
        vals[i].innerHTML = t;
    }
}

/*SCRIPT PARA SEPARAR O RESUMO DE OUTROS ABSTRACTS POR UMA LINHA */
function separarAbstracts(){
    var url = document.URL; /*A linha de separação só deve aparecer no modo simples*/
    var reg = /.*?mode=full.*/; /*O trecho mode=full na URL indica que estamos vendo o registro completo do item*/
    if(!url.match(reg)){ /*Não deve haver mode=full na URL*/
        var vals = $$('td.metadataFieldValue');
        for (var i = 0; i < vals.length; i++ ) { /*Percorre pelas td da página. */
            /*Se a classe da td for metadataFieldValue E o seu texto tiver uma quebra de linha seguida por uma palavra
            em caixa alta e dois pontos, como em <br>ABSTRACT: então é aí que estão todos os resumos do item.
            Note que temos que especificar algumas letras com acentos por causa de outros idiomas como é o caso
            do Francês: Résumé.*/
            if (vals[i].innerHTML.match(/.*?<br ?\/?>[A-ZÉÈ]+\s*:/)){
                /*O Dspace separa os abstracts por uma quebra de linha. Basta tirar todas e colocar a linha. */
                var t = vals[i].innerHTML.replace(/<br ?\/?>/g,'<br/><br/><hr/><br/>');
                vals[i].innerHTML = t;
            }
        }
    }
}

/*
 * Transforma os links de texto em links clicáveis, como links para o doi, revistas, etc.
 * @returns {undefined}
 */
/*function inserirLinks(){
    var vals = $$('td.metadataFieldValue');
    var regex = /(.*?&lt;)([^ ]+)(&gt;.*)/;
    for (var i = 0; i < vals.length; i++){
        var t = vals[i].innerHTML;
        while(t.match(regex)){
            t = unescape(t.replace(regex, "$1<a href='$2' target='_blank'>$2</a>$3"));
            vals[i].innerHTML = t;
        }
    }
}*/


/*SCRIPT PARA CONFIGURAR O FORMATO DAS DATAS PARA DIA-MÊS-ANO.*/
function configurarDatas(){
    var vals = $$('td.metadataFieldValue');
    for (var i = 0; i < vals.length; i++ ) {
        var pattern = /([0-9]{4})-[0-9]{1,2}-[0-9]{1,2}\b/;  /*Acha metadados da data no formato ano-mês-dia.*/
        if(vals[i].innerHTML.match(pattern)){
            var ddmmaa = vals[i].innerHTML.substring(8) + "-" + vals[i].innerHTML.substring(5, 7) + "-" + vals[i].innerHTML.substring(0, 4);
            vals[i].innerHTML = ddmmaa;
        }

    //pattern = /([0-9]{4})-[0-9][0-9]/;  Acha metadados da data no formato ano-mês (Acontece em Artigos).
    //if(meta[i].className == "metadataFieldValue" && meta[i].innerHTML.match(pattern)){
    //    var ddmmaa = meta[i].innerHTML.substring(5) + "-" + meta[i].innerHTML.substring(0, 4);
    //    meta[i].innerHTML = ddmmaa;
    //}
    }
}

/*SCRIPT PARA CONSERTAR A URI QUE NÃO POSSUI O PREFIXO '/handle/'
Exemplo:
Antes: http://www.repositorio.ufpa.br/jspui/2011/1709 (ERRADO)
Depois: http://www.repositorio.ufpa.br/jspui/handle/2011/1709 (CORRETO)*/
function configurarHandle(){
    var vals = $$('td.metadataFieldValue');
    for (var i = 0; i < vals.length; i++ ) {
        var novo = vals[i].innerHTML.replace(/((http:\/\/)?(www.)?repositorio.ufpa.br\/jspui\/)([0-9]+\/[0-9]+)/g, "$1handle/$4");
        vals[i].innerHTML = novo;
    }
}


/*O primeiro passo é obter todas as tabelas, mas a que queremos é a qual cuja classe é 'miscTable', que é definida
pelo DSpace. Assim aplicamos a função de coloração nessas tabelas.*/
function fgetAllDataTables() {
    if (!document.getElementsByTagName) {
        return false;
    }

    var eleTables = $$("table .miscTable");
    for (var i=0; i < eleTables.length; i++) {
            fStripes(eleTables[i]);
    }
    return true;
}

/*Colore a tabela 'eleTable' de forma listrada (striped). Verifique no CSS os estilos que você deseja.*/
function fStripes(eleTable) {
    eleTable.className = "tabelaItem";
}

/*Roda os scripts só quando a página terminar de carregar */
document.observe('dom:loaded', supSubescrito); //deve estar antes de inserirLinks
document.observe('dom:loaded', inserirLinks);
document.observe('dom:loaded', separarAbstracts);
document.observe('dom:loaded', configurarDatas);
document.observe('dom:loaded', configurarHandle);
document.observe('dom:loaded', fgetAllDataTables);