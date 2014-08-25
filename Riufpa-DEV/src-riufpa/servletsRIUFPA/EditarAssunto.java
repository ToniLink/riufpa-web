/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servletsRIUFPA;

import edu.harvard.hul.ois.mets.Show;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.Group;
import org.dspace.event.Event;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;


/**
 *
 * @author Jefferson
 */
public class EditarAssunto extends org.dspace.app.webui.servlet.DSpaceServlet {
    
    private static Logger log = Logger.getLogger(EditarAssunto.class);
    
    private String nome = "dspace";
    private String senha = "dspace";
    private String url = "jdbc:postgresql://127.0.0.1:5432/dspace";
    private Connection con;
    private Statement stat;
    private String driver = "org.postgresql.Driver";
    
    
   
    
    @Override
    protected void doDSGet(Context c, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, AuthorizeException {

        doDSPost(c, request, response);
    }
    
    @Override
    protected void doDSPost(Context c, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, AuthorizeException {

        // check to see if the statistics are restricted to administrators
        boolean publicise = ConfigurationManager.getBooleanProperty("report.public");

        // determine the navigation bar to be displayed
        String navbar = (publicise == false ? "admin" : "default");
        request.setAttribute("navbar", navbar);

        // is the user a member of the Administrator (1) group
        boolean admin = Group.isMember(c, 1);
        
        String  palavraAntiga = request.getParameter("palavraAntiga");
        String  palavraNova = request.getParameter("palavraNova");
        System.out.println("Palavra Antiga - "+ palavraAntiga);
        System.out.println("Palavra Nova - "+ palavraNova);
        
        if(palavraAntiga == null || palavraNova == null ){
           
            JSPManager.showJSP(request, response, "dspace-admin/editar-assunto.jsp");
        }
        else{
        try {
                    try {
                        Class.forName(driver);
                    } catch (ClassNotFoundException ex) {
                        java.util.logging.Logger.getLogger(EditarAssunto.class.getName()).log(Level.SEVERE, null, ex);
                    }
            con = DriverManager.getConnection(url,nome,senha);
            stat = con.createStatement();
            
            String query = "update metadatavalue set text_value = '"+palavraNova+"' where metadata_field_id = 57 and text_value = '"+palavraAntiga+"'";
            stat.executeUpdate(query);
            con.close();
            
            
            JSPManager.showJSP(request, response, "dspace-admin/editar-assunto.jsp");
            
           } catch (SQLException e) {
               log.error(LogManager.getHeader(c, "Error while updating text_value for metadata", "Item: " ));
        }
        
    }
    }
   
    
    }
    
       

    


