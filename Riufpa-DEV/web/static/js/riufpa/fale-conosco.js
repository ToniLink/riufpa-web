/*
 * Script para a validação de dados fale conosco.
 */

// Mensagens de alerta
var msg_nome = "Você precisa preencher o nome";
var msg_email = "Digite um e-mail válido";
var msg_assunto = "Por favor, escolha um assunto";
var msg_comentario = "Por favor, escreva um comentário";

/*
 * Array com os estilos da tooltip.
 */
var estilo = {
    style: 'rounded',
    showOn: "creation",
    target: true,
    stem: true,
    tipJoint: ['left', 'middle'],
    targetJoint: ['right', 'middle']
};

/*
 *Função para validar os dados dos campos do formulário.
 */
function validaCampo(form) {
    if (form.nome.value === "") {
        $('tnome').addTip(msg_nome, estilo);
        return false;
    }

    if (!validateEmail(form.email.value)) {
        $('temail').addTip(msg_email, estilo);
        return false;
    }

    if (form.assunto.value === "") {
        $('assunto').addTip(msg_assunto, estilo);
        return false;
    }

    if (form.feedback.value === "") {
        $('tfeedback').addTip(msg_comentario, estilo);
        return false;
    }

    return true;
}

/*
 * Função para validação de emails.
 */
function validateEmail(email) {
    var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return emailPattern.test(email);
}

/*
 * Troca o captcha.
 */
function trocarCaptcha() {
    $('img_captcha').src = 'kaptcha.jpg?' + Math.floor(Math.random() * 100);
}

function setAlertas(nome, email, assunto, comentario){
    msg_nome = nome;
    msg_email = email;
    msg_assunto = assunto;
    msg_comentario = comentario;
}