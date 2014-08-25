/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servletsRIUFPA.autocomplete;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.dspace.app.webui.servlet.AbstractBrowserServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.browse.*;
import org.dspace.core.Context;

/**
 *
 * @author portal
 */
public class AutoComplete extends AbstractBrowserServlet {

    private int qtdeResultados = 50;

    @Override
    protected void doDSGet(Context context, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, AuthorizeException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();

        try {
            //Autor
            BrowserScope escopoAutor = new BrowserScope(context);
            escopoAutor.setBrowseIndex(BrowseIndex.getBrowseIndex("author"));
            escopoAutor.setOrder("ASC");
            escopoAutor.setStartsWith(request.getParameter("starts_with"));
            escopoAutor.setResultsPerPage(this.qtdeResultados);

            //Orientador e coorientador
            BrowserScope escopoOrientador = new BrowserScope(context);
            escopoOrientador.setBrowseIndex(BrowseIndex.getBrowseIndex("orientadorEcoorientador"));
            escopoOrientador.setOrder("ASC");
            escopoOrientador.setStartsWith(request.getParameter("starts_with"));
            escopoOrientador.setResultsPerPage(this.qtdeResultados);

            //Assunto
            BrowserScope escopoAssunto = new BrowserScope(context);
            escopoAssunto.setBrowseIndex(BrowseIndex.getBrowseIndex("subject"));
            escopoAssunto.setOrder("ASC");
            escopoAssunto.setStartsWith(request.getParameter("starts_with"));
            escopoAssunto.setResultsPerPage(this.qtdeResultados);
            
            //Título
            BrowserScope escopoTitulo = new BrowserScope(context);
            escopoTitulo.setBrowseIndex(BrowseIndex.getBrowseIndex("title"));
            escopoTitulo.setOrder("ASC");
            escopoTitulo.setStartsWith(request.getParameter("starts_with"));
            escopoTitulo.setResultsPerPage(this.qtdeResultados);

            String t = request.getParameter("tipo");
            
              
            
            boolean usarAutores = false;
            boolean usarAssunto = false;
            boolean usarTitulo = false;

            if(t.equals("autor")){ //autor e [co]orientador
                usarAutores = true;
            } 
            else if (t.equals("assunto")){
                usarAssunto = true;
            }
            else if (t.equals("titulo")){
                usarTitulo = true;
            }

            BrowseEngine be = new BrowseEngine(context);

            if (usarAutores){
                BrowseInfo binfo = be.browse(escopoAutor);
                BrowseInfo binfo2 = be.browse(escopoOrientador);

                ArrayList<String> resultados = new ArrayList<String>();

                String[][] autores = binfo.getStringResults();
                String[][] orientadores = binfo2.getStringResults();

                for (int i = 0; i < autores.length; i++) {
                    resultados.add(autores[i][0]);
                }
                for (int i = 0; i < orientadores.length; i++) {
                    String tmp = orientadores[i][0];
                    if(!resultados.contains(tmp)){
                        resultados.add(tmp);
                    }
                }

                Collections.sort(resultados, Collator.getInstance(new Locale ("pt", "BR")));

                this.imprimir(resultados, out);
            }

            if(usarAssunto){
                BrowseInfo binfo = be.browse(escopoAssunto);
                this.imprimir(binfo.getStringResults(), out);
            }
            
            if(usarTitulo){
                BrowseInfo binfo = be.browse(escopoTitulo);
                ArrayList <String> listaTitulos = new ArrayList<String>();
                BrowseItem titulos[] = binfo.getBrowseItemResults();  
                
                for (int i = 0; i < binfo.getBrowseItemResults().length; i++) {
                    listaTitulos.add(titulos[i].getName());
                }
                 
                this.imprimir(listaTitulos, out);
               
          
            }

        } catch (BrowseException ex) {
            Logger.getLogger(AutoComplete.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();
        }

    }

    private void imprimir(String[][] resultados, PrintWriter out){
        for (int i = 0; i < resultados.length; i++) {
            out.print((i+1));
            out.print("###");
            out.print(resultados[i][0]);
            if(i < resultados.length - 1)
                out.print("|");
        }
    }

    private void imprimir(ArrayList<String> resultados, PrintWriter out){
        for (int i = 0; i < resultados.size(); i++) {
            out.print((i+1));
            out.print("###");
            out.print(resultados.get(i).toString());
            if(i < resultados.size() - 1)
                out.print("|");
        }
    }

    @Override
    protected void doDSPost(Context context, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException, AuthorizeException {
        doDSGet(context, request, response);
    }

    /**
     * Display the error page
     *
     * @param context
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    protected void showError(Context context, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {
        JSPManager.showJSP(request, response, "/browse/error.jsp");
    }

    /**
     * Display the No Results page
     *
     * @param context
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    protected void showNoResultsPage(Context context, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {

        JSPManager.showJSP(request, response, "/browse/no-results.jsp");
    }

    /**
     * Display the single page.  This is the page which lists just the single values of a
     * metadata browse, not individual items.  Single values are links through to all the items
     * that match that metadata value
     *
     * @param context
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    protected void showSinglePage(Context context, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {

        JSPManager.showJSP(request, response, "/browse/single.jsp");
    }

    /**
     * Display a full item listing.
     *
     * @param context
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    @Override
    protected void showFullPage(Context context, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {

        JSPManager.showJSP(request, response, "/browse/full.jsp");
    }
}
