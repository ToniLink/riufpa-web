/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servletsRIUFPA.estatisticas.model;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import org.dspace.content.Community;
import org.dspace.core.Context;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;

/**
 *
 * @author portal
 */
public class Propriedades {

    public static final String CONFERENCE_OBJECT = "conferenceObject";
    public static final String ARTICLE = "article";
    public static final String DOCTORAL_THESIS = "doctoralThesis";
    public static final String MASTER_THESIS = "masterThesis";
    public static final String REVIEW = "review";

    public static int getQtdeComunidades(Context context) throws SQLException{
        String query = "select distinct count(community_id)  as total from community where community_id not in (select child_comm_id from community2community)";
        TableRow tr = DatabaseManager.querySingle(context, query);
        return (int) tr.getLongColumn("total");
    }

    public static int getQtdeSubcomunidade(Context context) throws SQLException{
        String query = "select count(child_comm_id) as total from community2community";
        TableRow tr = DatabaseManager.querySingle(context, query);
        return (int) tr.getLongColumn("total");
    }

    public static int getQtdeColecao(Context context) throws SQLException{
        String query = "select count(collection_id) as total from collection";
        TableRow tr = DatabaseManager.querySingle(context, query);
        return (int) tr.getLongColumn("total");
    }

    public static int getQtdeItens(Context context) throws SQLException{
        String query = "select count(item_id) as total from item where in_archive = true";
        TableRow tr = DatabaseManager.querySingle(context, query);
        return (int) tr.getLongColumn("total");
    }

    public static int getQtdeusuarios(Context context) throws SQLException{
        String query = "select count(eperson_id) as total from eperson";
        TableRow tr = DatabaseManager.querySingle(context, query);
        return (int) tr.getLongColumn("total");
    }

    public static int getQtdeTipoDocumento(Context context, String tipo) throws SQLException{
        //String query = "select count(text_value) as total from metadatavalue where text_value='" + tipo + "'";
        String query = "select count(text_value) as total from metadatavalue m, item i where text_value= '" + tipo +"' and i.item_id = m.item_id and in_archive = true";
        TableRow tr = DatabaseManager.querySingle(context, query);
        return (int) tr.getLongColumn("total");
    }

    public static Community[] getSubcomunidades(Context context, Community[] comunidades) throws SQLException{
        Community[] subComunidades;
        ArrayList<Community> arrSubcom = new ArrayList<Community>();
        for (int i = 0; i < comunidades.length; i++) {
            Community[] temp = comunidades[i].getSubcommunities();
            arrSubcom.addAll(Arrays.asList(temp));
        }
        subComunidades = new Community[arrSubcom.size()];
        for (int i = 0; i < arrSubcom.size(); i++) {
            subComunidades[i] = arrSubcom.get(i);
        }
        return subComunidades;
    }

}
