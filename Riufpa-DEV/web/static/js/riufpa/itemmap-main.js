/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


var msg = "Você deve digitar o nome de um autor";

/*
 * Array com os estilos da tooltip.
 */
var estilo = {
    style: 'rounded',
    showOn: "creation",
    target: true,
    stem: true,
    tipJoint: ['right', 'middle'],
    targetJoint: ['left', 'middle']
};

function validarAutor() {
    var txt = $('namepart').value;
    txt = trim(txt);
    $('namepart').value = txt;
    if (txt === '') {
        $('namepart').focus();
        $('namepart').addTip(msg, estilo);
        return false;
    } else {
        return true;
    }
}

function trim(str) {
    return str.replace(/^\s+|\s+$/g, "");
}

function setAlertas(alerta) {
    msg = alerta;
}