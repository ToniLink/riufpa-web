/*
 * Script para trocar as imagens de "expandir" e "encolher" da lista de comunidades, além de exibir
 * as subcomunidades.
 * Funcionamento:
 * Durante a criação da listagem de comunidades e coleções, algumas id's devem ser atribuídas aos elementos
 * da lista.
 * A imagem de expandir/recolher deve possuir um id único no seguinte formato:
 * expandir<número>.
 *
 * A div que contém apenas coleções (oculta por padrão) deve possuir um id único no seguinte formato:
 * <nome da comunidade pai>=a
 *
 * Já a div que contém as subcomunidades (oculta por padrão) deve possuir um id único no seguinte formato:
 * <nome da comunidade pai>=b
 *
 * O link que contém a imagem deve chamar o método mostrarSubComu da seguinte forma:
 * mostrarSubComu(<nome da comunidade pai>, <id da comunidade pai>)
 *
 * Assim, é possível exibir as div's correspondentes ao id fornecido e trocar a imagem de expandir/recolher.
 */

//Caminho da imagem de expandir
var caminho_imagem_expandir = 'image/expandir.png';

//Caminho da imagem de encolher
var caminho_imagem_recolher = 'image/encolher.png';

//Título que aparecerá sobre a imagem de expandir.
var expandir_titulo = 'Expandir';

//Título que aparecerá sobre a imagem de recolher.
var recolher_titulo = 'Recolher';

//Não altere as seguintes variáveis, pois são calculadas automaticamente.

//Apenas o nome da imagem de expandir (calculado automaticamente).
var imagem_expandir = caminho_imagem_expandir.substring(caminho_imagem_expandir.lastIndexOf("/") + 1, caminho_imagem_expandir.length);

//Apenas o nome da imagem de encolher (calculado automaticamente).
var imagem_recolher = caminho_imagem_recolher.substring(caminho_imagem_recolher.lastIndexOf("/") + 1, caminho_imagem_recolher.length);;

/*
 * Mostra a div das subcomunidades/coleções.
 * Parâmetros:
 * nome - Nome da comunidade pai
 * id_com - Id da comunidade pai
 */
function mostrarSubComu(nome, id_com){
    if(document.getElementById(nome + '=a') != null)
        Effect.toggle(nome + '=a', 'appear', {
            duration: 0.3
        });
    if(document.getElementById(nome + '=b') != null)
        Effect.toggle(nome + '=b', 'appear', {
            duration: 0.3
        });

    trocarImagem(id_com);
}

/*
 * Troca a imagem de 'expandir' para a imagem de 'recolher' e vice-versa.
 * Parâmetros:
 * id_img - Id da comunidade pai
 */
function trocarImagem(id_img) {
    var imagem = document.getElementById('expandir' + id_img);

    var theImg = imagem.src;
    var x = theImg.split("/");
    var t = x.length - 1;
    var y = x[t];

    if(y == imagem_expandir) {
        imagem.src = caminho_imagem_recolher;
        imagem.title = recolher_titulo;
    }
    if(y == imagem_recolher) {
        imagem.src = caminho_imagem_expandir;
        imagem.title = expandir_titulo;
    }
}