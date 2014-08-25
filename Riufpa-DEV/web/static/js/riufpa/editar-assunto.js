/*
 * Script para a validação de dados fale conosco.
 */

// Mensagens de alerta
var msg_nome = "Você precisa preencher a nova palavra-chave";
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
function validaCampo2(form) {
    
    
    if(form.palavraNova.value === ""){
       $('tassunto').addTip(msg_nome, estilo);
       
       return false;
    }

    return true;
}



function setAlertas(nome, email, assunto, comentario){
    msg_nome = nome;
    msg_email = email;
    msg_assunto = assunto;
    msg_comentario = comentario;
}