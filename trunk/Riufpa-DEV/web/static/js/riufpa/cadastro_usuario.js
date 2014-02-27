/*
* Script de validação de dados do formulário de cadastro de
* novo usuário.
*/

/*
 * Texto descrevendo os tipos de conta.
 */
var anonymous = "Use esta conta caso você queira apenas se inscrever nas coleções do repositório.";

var depositante = "Conta recomendada para pesquisadores que querem submeter seus trabalhos no repositório.";

var catalogador = "Conta utilizada por bibliotecários.";

var revisor = "Conta utilizada por bibliotecários que farão a revisão dos trabalhos submetidos.";

/*
 * Id da área em que será exibida a descrição de cada conta.
 */
var id_area_descricao = "descricao_conta";

/*
 * Array com os estilos da tooltip.
 */
var estilo = {
                style: 'rounded',
                showOn: "creation",
                target: true,
                stem: true,
                tipJoint: [ 'left', 'middle' ],
                targetJoint: [ 'right', 'middle' ]
            };

/*
 * Exibe a decrição do tipo de conta no campo id_area_descricao.
 * Parâmetros:
 * id - [Anonymous | Depositante | Catalogador | Revisor]
 */
function mostrarTexto(id){
    var texto = document.getElementById(id_area_descricao);
    if(id == "Anonymous"){
        texto.innerHTML = anonymous;
    } else if(id == "Depositante"){
        texto.innerHTML = depositante;
    } else if(id == "Catalogador"){
        texto.innerHTML = catalogador;
    } else if(id == "Revisor"){
        texto.innerHTML = revisor;
    }

}

/*
 * Função de validação do formulário de cadastro de novo usuário.
 * Caso algum campo esteja vazio ou mal formatado, uma tooltip é exibida ao lado do campo em questão.
 */
function validarFormulario(){
    var nome = document.forms["cadastro_usuario"]["nome"].value;
    var sobrenome = document.forms["cadastro_usuario"]["sobrenome"].value;
    var email = document.forms["cadastro_usuario"]["email"].value;
    var senha1 = document.forms["cadastro_usuario"]["senha"].value;
    var senha2 = document.forms["cadastro_usuario"]["confirmar_senha"].value;

    if(nome == "" || nome == null){
        $('nome').addTip('Você precisa preencher o nome!', estilo);
        return false;
    }
    if(sobrenome == "" || sobrenome == null){
        $('sobrenome').addTip('Você precisa preencher o sobrenome!', estilo);
        return false;
    }
    if(email == "" || email == null){
        $('email').addTip('Você precisa preencher o email!', estilo);
        return false;
    }
    if(!validateEmail(email)){
        $('email').addTip('Digite um e-mail válido.', estilo);
        return false;
    }
    if(senha1.length < 6){
        $('senha').addTip('Devem haver no mínimo 6 caracteres!', estilo);
        return false;
    }
    if(senha1 != senha2){
        $('confirmar_senha').addTip('As senhas não batem!', estilo);
        return false;
    }
    if(senha1 == "" || senha1 == null){
        $('senha').addTip('Você deve especificar uma senha!', estilo);
        return false;
    }

    return true;
}

/*
 * Função para validação de emails.
 */
function validateEmail(email){
    var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    return emailPattern.test(email);
}