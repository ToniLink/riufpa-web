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
import org.dspace.app.webui.submit.JSPStep;
import org.dspace.app.webui.submit.JSPStepManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.DCValue;
import org.dspace.content.InProgressSubmission;
import org.dspace.content.Item;
import org.dspace.core.Context;

/**
 * Classe responsável por inicializar e chamar a página JSP que permite ao usuário escolher o tipo de documento.
 * @author Manoel Afonso
 */
public class EscolherTipoDocJspui extends JSPStep {

    /**
     * Endereço da página JSP referente a escolha do tipo de documento.
     */
    public static final String PAGINA_JSP = "/submissao/escolher-tipo.jsp";

    /**
     * Inicialização da JSP. Aqui, o tipo de documento (metadado dc.type) é analizado e repassado para a JSP, através do
     * atributo {@link EscolherTipoDoc#TIPO_DOCUMENTO EscolherTipoDoc.TIPO_DOCUMENTO}. O valor repassado é uma das opções
     * disponíveis em {@link EscolherTipoDoc.TipoDoc EscolherTipoDoc.TipoDoc}.
     * @param context
     * @param request
     * @param response
     * @param subInfo
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    public void doPreProcessing(Context context, HttpServletRequest request, HttpServletResponse response, SubmissionInfo subInfo) throws ServletException, IOException, SQLException, AuthorizeException {
        System.out.println("===================================================");
        System.out.println("PRÉ-PROCESSAMENTO EM " + this.getClass().getName());

        //Obtém o Item sendo submetido
        InProgressSubmission submissionItem = subInfo.getSubmissionItem();
        submissionItem.update();
        Item item = submissionItem.getItem();
        //Obtem o metadado do tipo (dc.type) em qualquer idioma.
        DCValue[] metadata = item.getMetadata("dc", "type", null, Item.ANY);

        String tipo = null;

        if(metadata != null && metadata.length > 0){
            tipo = metadata[0].value;
        }

        //Configura o parâmetro para a JSP.
        if(tipo != null){
            if(tipo.equals("article")){
                request.setAttribute(EscolherTipoDoc.TIPO_DOCUMENTO, EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO.toString());
            } else if(tipo.equals("doctoralThesis")){
                request.setAttribute(EscolherTipoDoc.TIPO_DOCUMENTO, EscolherTipoDoc.TipoDoc.TESE.toString());
            } else if(tipo.equals("masterThesis")){
                request.setAttribute(EscolherTipoDoc.TIPO_DOCUMENTO, EscolherTipoDoc.TipoDoc.DISSERTACAO.toString());
            } else if(tipo.equals("conferenceObject")){
                request.setAttribute(EscolherTipoDoc.TIPO_DOCUMENTO, EscolherTipoDoc.TipoDoc.TRABALHO.toString());
            } else{ //Outro tipo qualquer.
                request.setAttribute(EscolherTipoDoc.TIPO_DOCUMENTO, EscolherTipoDoc.TipoDoc.OUTRO.toString());
            }
        } else{
            request.setAttribute(EscolherTipoDoc.TIPO_DOCUMENTO, EscolherTipoDoc.TipoDoc.OUTRO.toString());
        }

        System.out.println("Tipo de documento (dc.type): " + tipo);

        //Carrega a JSP.
        JSPStepManager.showJSP(request, response, subInfo, PAGINA_JSP);
    }

    /**
     *
     * @param context
     * @param request
     * @param response
     * @param subInfo
     * @param status
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    public void doPostProcessing(Context context, HttpServletRequest request, HttpServletResponse response, SubmissionInfo subInfo, int status) throws ServletException, IOException, SQLException, AuthorizeException {
        System.out.println("\nPÓS-PROCESSAMENTO EM " + this.getClass().getName());
        DCValue[] metadata = subInfo.getSubmissionItem().getItem().getMetadata("dc", "type", null, Item.ANY);
        String tipo = null;

        if(metadata != null && metadata.length > 0){
            tipo = metadata[0].value;
        }
        System.out.println("Tipo de documento (dc.type): " + tipo);

        InProgressSubmission submissionItem = subInfo.getSubmissionItem();
        submissionItem.update();
    }

    /**
     * Não há página de revisão para este passo, portanto este método retorna null.
     * @param context
     * @param request
     * @param response
     * @param subInfo
     * @return
     */
    @Override
    public String getReviewJSP(Context context, HttpServletRequest request, HttpServletResponse response, SubmissionInfo subInfo) {
        return null;
    }

}
