/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package submissao.fim;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.dspace.app.util.SubmissionInfo;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.DCValue;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.submit.AbstractProcessingStep;
import submissao.EscolherTipoDoc;

/**
 * Garante que o metadado dc.type esteja configurado corretamente no Item.
 * @author Manoel Afonso
 */
public class InserirTipo extends AbstractProcessingStep {

    @Override
    public int doProcessing(Context context, HttpServletRequest request, HttpServletResponse response, SubmissionInfo subInfo) throws ServletException, IOException, SQLException, AuthorizeException {
        System.out.println("\nPROCESSAMENTO EM " + this.getClass().getName());

        Item item = subInfo.getSubmissionItem().getItem();
        DCValue[] metadata = item.getMetadata("dc", "type", null, Item.ANY);

        String tipo = null;

        if(metadata != null && metadata.length > 0){
            tipo = metadata[0].value;
        }

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

        System.out.println("Tipo de documento (dc.type): " + valor);

        return STATUS_COMPLETE;
    }

    @Override
    public int getNumberOfPages(HttpServletRequest request, SubmissionInfo subInfo) throws ServletException {
        return 1;
    }

}
