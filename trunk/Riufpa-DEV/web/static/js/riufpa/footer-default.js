/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * Script para remover a parte ":8080" dos links do repositório, pois se o usuário logado no site sem a porta
 * for redirecionado para uma página do site com a porta, ele perde o login.
 */

var labels = document.getElementsByTagName("a"); //vai atrÃ¡s dos links
for ( var i = 0; i < labels.length; i++ ) {
    if (labels[i].href != null &&  labels[i].href.match("(http://)?(www\.)?repositorio\.ufpa\.br:8080.*") ){
        var nova = labels[i].href.replace(":8080", "");
        labels[i].href = nova;
        labels[i].innerHTML = nova;
    }
}

/////////////////////////////////
//var labels = document.getElementsByTagName("td"); //vai atrás dos links
//for ( i = 0; i < labels.length; i++ ) {
//    var txt = labels[i].innerHTML;
//    if (txt != null && labels[i].className == 'metadataFieldValue'){
//        var ini = linkify(txt);
//        labels[i].innerHTML = ini;
//    }
//}
//
//function linkify(text){
//    if (text) {
//        text = text.replace(/((https?\:\/\/)|(www\.))(\S+)(\w{2,4})(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/gi,
//            function(url){
//                var full_url = url;
//                if (!full_url.match('^https?://')) {
//                    full_url = 'http://' + full_url;
//                }
//                return '<a href="' + full_url + '">' + url + '</a>';
//            }
//            );
//    }
//    return text;
//}
