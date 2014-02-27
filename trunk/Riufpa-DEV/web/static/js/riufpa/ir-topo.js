/*
 * Script para exibir e ocultar o botão de ir para o topo.
 */

/*
 * Id do componente que armazena o botão de ir para o topo.
 */
var id_comp = 'ir_topo';

/*
 * Id do componente que serve como referência para exibir o botão.
 * Assim, quando este componente sair da área de visualização, o botão aparece.
 */
var id_referencia = 'barraLocalizacao';

/*
 * Id do componente que representa o topo do site. É com base nele que as distâncias
 * serão calculadas, logo, deve ser um elemento que esteja o mais próximo possível do topo
 * do layout da página.
 */
var id_topo = 'topo';

/*
 * Exibe o botão.
 */
function mostrar(){
    Effect.Appear(id_comp, {
        duration: 0.2
    });
    return false;
}

/*
 * Oculta o botão.
 */
function ocultar(){
    Effect.Fade(id_comp, {
        duration: 0.2
    });
    return false;
}

/*
 * Toda vez que um evento scroll é disparado, está função é executada.
 * Ela calcula as distâncias e exibe/oculta o botão de acordo com elas.
 */
var ir_topo = function principal(){
    var scroll_vert = window.scrollY;
    var dist_elem   = document.getElementById(id_topo).offsetTop;
    var distancia   = (dist_elem - scroll_vert);
    if(distancia < 0 && ($(id_referencia).getStyle("display") !== "none")){
        t = setTimeout(mostrar, 300);
    } else if(distancia === 0){
        t = setTimeout(ocultar, 500);
    }
};

//Registra o evento 'scroll' na função 'ir_topo'.
window.addEventListener('scroll', ir_topo, false);