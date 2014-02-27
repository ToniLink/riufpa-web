/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package submissao;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.dspace.app.util.SubmissionInfo;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.DCValue;
import org.dspace.content.InProgressSubmission;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.submit.AbstractProcessingStep;

/**
 * Classe para a inserção do metadado dc.type no Item sendo submetido após a escolha do tipo na página JSP referente a
 * este passo ({@link EscolherTipoDocJspui#PAGINA_JSP EscolherTipoDocJspui.PAGINA_JSP}).
 * @author Manoel Afonso
 */
public class EscolherTipoDoc extends AbstractProcessingStep {

    /**
     * Representa os tipos específicos:
     * Artigo Científico, Tese, Dissertação, Trabalho apresentado em eventos e Outros.
     */
    public enum TipoDoc {
        ARTIGO_CIENTIFICO, TESE, DISSERTACAO, TRABALHO, OUTRO
    }

    /**
     * Nome do atributo que representa o tipo do documento sendo submetido.
     */
    public static String TIPO_DOCUMENTO = "tipo_documento";

    /**
     * Nome do atributo (usado no request.getParameter() e no formulário de escolha de tipo de documento) que
     * representa o tipo de documento que o usuário acabou de escolher.
     */
    public static String NAME_ESCOLHA_TIPO = "tipo_doc_escolhido";

    /**
     * Método de processamento principal deste passo. É responsável por adicionar o valor correto do metadado dc.type ao
     * Item sendo submetido.
     * @param context
     * @param request
     * @param response
     * @param subInfo
     * @return
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    public int doProcessing(Context context, HttpServletRequest request, HttpServletResponse response, SubmissionInfo subInfo) throws ServletException, IOException, SQLException, AuthorizeException {
        System.out.println("\nPROCESSAMENTO EM " + this.getClass().getName());

        //Tipo de documento escolhido pelo usuário
        String tipo = request.getParameter(EscolherTipoDoc.NAME_ESCOLHA_TIPO);

        // Insere o metadado dc.type no item.
        InProgressSubmission submissionItem = subInfo.getSubmissionItem();
        submissionItem.update();
        Item item = submissionItem.getItem();
        //Por garantia, apagamos todos os metadados, pois o usuário já pode ter inserido alguns referentes a outro tipo.
        item.clearMetadata("dc", "type", null, Item.ANY); //Não queremos duplicatas.

        String schema = "dc";
        String element = "type";
        String qualifier = null;
        String lang = "pt_BR";
        String valor = null;

        if(EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO.toString().equals(tipo)){
            valor = "article";
        } else if (EscolherTipoDoc.TipoDoc.TESE.toString().equals(tipo)){
            valor = "doctoralThesis";
        } else if (EscolherTipoDoc.TipoDoc.DISSERTACAO.toString().equals(tipo)){
            valor = "masterThesis";
        } else if (EscolherTipoDoc.TipoDoc.TRABALHO.toString().equals(tipo)){
            valor = "conferenceObject";
        }

        //Adiciona o metadado referente ao tipo de documento
        if(valor != null){
            item.addMetadata(schema, element, qualifier, lang, valor);
        }

        System.out.println("Tentou inserir: " + valor);

        item.update();
        context.commit();

        return STATUS_COMPLETE;
    }

    /**
     * Este passo possui apenas 1 (uma) página para o usuário.
     * @param request
     * @param subInfo
     * @return
     * @throws ServletException
     */
    @Override
    public int getNumberOfPages(HttpServletRequest request, SubmissionInfo subInfo) throws ServletException {
        return 1;
    }

    /**
     * Obtém o tipo de documento (dc.type) de um Item.
     * @param item Item sendo submetido.
     * @return Uma String representando o tipo de documento, de acordo com {@link TipoDoc TipoDoc}.
     * Assim, uma tese é representada como "TESE" (TipoDoc.TESE.toString()).
     */
    public static String tipoDocumento(Item item){
        String tipoDoc = EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO.toString();
        DCValue[] metadata = item.getMetadata("dc", "type", null, Item.ANY);
        if(metadata != null && metadata.length > 0){
            String temp = metadata[0].value;
            if(temp.equals("article")){
                tipoDoc = EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO.toString();
            } else if(temp.equals("doctoralThesis")){
                tipoDoc = EscolherTipoDoc.TipoDoc.TESE.toString();
            } else if(temp.equals("masterThesis")){
                tipoDoc = EscolherTipoDoc.TipoDoc.DISSERTACAO.toString();
            } else if(temp.equals("conferenceObject")){
                tipoDoc = EscolherTipoDoc.TipoDoc.TRABALHO.toString();
            }
        } else if(metadata != null && metadata.length == 0){
            tipoDoc = EscolherTipoDoc.TipoDoc.OUTRO.toString();
        }

        return tipoDoc;
    }

}
