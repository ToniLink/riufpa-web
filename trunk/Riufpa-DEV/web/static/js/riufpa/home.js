/*
 * Scripts para a página inicial (home).
 */

/*
 *SCRIPT PARA TRADUZIR OS OPERADORES BOOLEANOS PARA INGLÊS
 *Na página inicial, no campo de busca simples, o usuário pode entrar com operadores booleanos em
 *Portugês (E, OU, NÃO). Porém, devemos convertê-los para os operadores em Inglês.
 *Este método retorna false caso o usuário não tenha preenchido nada no campo de texto.
 */
function validarBusca(){
    var entrada = $('texto_busca');
    var busca = entrada.value;
    if(!busca.match(/([0-9a-zA-Z]+)/)){
        return false;
    }

    var novo = "";

    //O usuário não pode pesquisar usando somente as palavras 'AND', 'NOT' ou 'OR', mas pode usar
    //'and', 'not' ou 'or'.
    if(busca === 'AND' || busca === 'NOT' || busca === 'OR'){
        novo = busca.toLowerCase();
        $('tquery').value = novo;
        return true;
    }

    //O usuário pode pesquisar só pelas palavras 'E', 'NÃO' ou 'OU'.
    if(busca === 'E' || busca === 'NÃO' || busca === 'OU'){
        novo = busca;
        $('tquery').value = novo;
        return true;
    }

    novo = busca.replace(/\bE\b/g, "AND");
    novo = novo.replace(/\bNÃO\b/g, "NOT");
    novo = novo.replace(/\bOU\b/g, "OR");
    $('tquery').value = novo;
    return true;
}