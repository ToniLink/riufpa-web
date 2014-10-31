/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servletsRIUFPA.estatisticas.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.eperson.Group;
import org.dspace.handle.HandleManager;
import org.dspace.statistics.Dataset;
import org.dspace.statistics.content.DatasetDSpaceObjectGenerator;
import org.dspace.statistics.content.StatisticsDataVisits;
import org.dspace.statistics.content.StatisticsListing;
import servletsRIUFPA.estatisticas.model.Propriedades;

/**
 * This servlet provides an interface to the statistics reporting for a DSpace repository
 *
 * @author Richard Jones
 * @version $Revision: 3705 $
 */
public class Estatisticas extends org.dspace.app.webui.servlet.DSpaceServlet {

    /**
     * log4j category
     */
    private static Logger log = Logger.getLogger(Estatisticas.class);

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
        
        String publico = (String) request.getParameter("publica");
        if(publico == null){
        if (publicise || admin) {
            showStatistics(c, request, response);
        } else {
            throw new AuthorizeException();
        }
        }
        else{showStatistics(c, request, response);}
    }

    /**
     * show the default statistics page
     *
     * @param context current DSpace context
     * @param request current servlet request object
     * @param response current servlet response object
     */
    private void showStatistics(Context context, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException, AuthorizeException {

        StringBuilder report = new StringBuilder();
        String date = (String) request.getParameter("date");
        String nome = (String) request.getParameter("nome");
        String publico = (String) request.getParameter("publica");
        
        if(publico == null){publico="false";}

        request.setAttribute("date", date);
        request.setAttribute("general", false);

        File reportDir = new File(ConfigurationManager.getProperty("report.dir"));

        File[] reports = reportDir.listFiles();
        File reportFile = null;

        FileInputStream fir = null;
        InputStreamReader ir = null;
        BufferedReader br = null;

        try {
            List monthsList = new ArrayList();

            Pattern monthly = Pattern.compile("report-([0-9][0-9][0-9][0-9]-[0-9]+)\\.html");
            Pattern general = Pattern.compile("report-general-([0-9]+-[0-9]+-[0-9]+)\\.html");

            // FIXME: this whole thing is horribly inflexible and needs serious
            // work; but as a basic proof of concept will suffice

            // if no date is passed then we want to get the most recent general
            // report
            if (date == null) {
                request.setAttribute("general", true);

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'M'-'dd");
                Date mostRecentDate = null;

                for (int i = 0; i < reports.length; i++) {
                    Matcher matchGeneral = general.matcher(reports[i].getName());
                    if (matchGeneral.matches()) {
                        Date parsedDate = null;

                        try {
                            parsedDate = sdf.parse(matchGeneral.group(1).trim());
                        } catch (ParseException e) {
                            // FIXME: currently no error handling
                        }

                        if (mostRecentDate == null) {
                            mostRecentDate = parsedDate;
                            reportFile = reports[i];
                        }

                        if (parsedDate != null && parsedDate.compareTo(mostRecentDate) > 0) {
                            mostRecentDate = parsedDate;
                            reportFile = reports[i];
                        }
                    }
                }
            }

            // if a date is passed then we want to get the file for that month
            if (date != null) {
                String desiredReport = "report-" + date + ".html";

                for (int i = 0; i < reports.length; i++) {
                    if (reports[i].getName().equals(desiredReport)) {
                        reportFile = reports[i];
                    }
                }
            }

            if (reportFile == null) {
                JSPManager.showJSP(request, response, "statistics/no-report.jsp");
            }

            // finally, build the list of report dates
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy'-'M");
            for (int i = 0; i < reports.length; i++) {
                Matcher matchReport = monthly.matcher(reports[i].getName());
                if (matchReport.matches()) {
                    Date parsedDate = null;

                    try {
                        parsedDate = sdf.parse(matchReport.group(1).trim());
                    } catch (ParseException e) {
                        // FIXME: currently no error handling
                    }

                    monthsList.add(parsedDate);
                }
            }

            Date[] months = new Date[monthsList.size()];
            months = (Date[]) monthsList.toArray(months);

            Arrays.sort(months);

            request.setAttribute("months", months);

            try {
                fir = new FileInputStream(reportFile.getPath());
                ir = new InputStreamReader(fir, "UTF-8");
                br = new BufferedReader(ir);
            } catch (IOException e) {
                // FIXME: no error handing yet
                throw new RuntimeException(e.getMessage(), e);
            }

            // FIXME: there's got to be a better way of doing this
            String line;
            while ((line = br.readLine()) != null) {
                report.append(line);
            }

            // set the report to be displayed
            request.setAttribute("report", report.toString());

            if (nome.toString().equalsIgnoreCase("csc")) {
                int totalComu = Propriedades.getQtdeComunidades(context);
                int totalSubComu = Propriedades.getQtdeSubcomunidade(context);
                int totalCol = Propriedades.getQtdeColecao(context);

                Community[] comunidades = Community.findAllTop(context);
                Community[] subComunidades = Propriedades.getSubcomunidades(context, comunidades);
                Collection[] colecoes = Collection.findAll(context);
                
                request.setAttribute("total_comunidades", totalComu);
                request.setAttribute("total_sub_comunidades", totalSubComu);
                request.setAttribute("total_colecoes", totalCol);
                request.setAttribute("comunidades", comunidades);
                request.setAttribute("sub_comunidades", subComunidades);
                request.setAttribute("colecoes", colecoes);
                
                if(publico.equalsIgnoreCase("true")){
                    
                JSPManager.showJSP(request, response, "estatistica-publica/csc-publica.jsp");
                }
                else{JSPManager.showJSP(request, response, "statistics/report-csc.jsp");}
            }

            if (nome.toString().equalsIgnoreCase("itens")) {
                int totalItens = Propriedades.getQtdeItens(context);
                int totalTrabalho = Propriedades.getQtdeTipoDocumento(context, Propriedades.CONFERENCE_OBJECT);
                int totalArtigo = Propriedades.getQtdeTipoDocumento(context, Propriedades.ARTICLE);
                int totalTese = Propriedades.getQtdeTipoDocumento(context, Propriedades.DOCTORAL_THESIS);
                int totalDissertacao = Propriedades.getQtdeTipoDocumento(context, Propriedades.MASTER_THESIS);
                int totalResenha = Propriedades.getQtdeTipoDocumento(context, Propriedades.REVIEW);

                Community[] comunidades = Community.findAllTop(context);
                Community[] subComunidades = Propriedades.getSubcomunidades(context, comunidades);
                Collection[] colecoes = Collection.findAll(context);

                request.setAttribute("total_itens", totalItens);
                request.setAttribute("total_trabalho", totalTrabalho);
                request.setAttribute("total_artigo", totalArtigo);
                request.setAttribute("total_tese", totalTese);
                request.setAttribute("total_dissertacao", totalDissertacao);
                request.setAttribute("total_resenha", totalResenha);
                request.setAttribute("comunidades", comunidades);
                request.setAttribute("sub_comunidades", subComunidades);
                request.setAttribute("colecoes", colecoes);
                
                ArrayList<Resultado> itensMais = getItensMaisAcessados(context);
                request.setAttribute("itens", itensMais);

                if(publico.equalsIgnoreCase("true")){
                   JSPManager.showJSP(request, response, "estatistica-publica/itens-publica.jsp"); 
                }
                else{JSPManager.showJSP(request, response, "statistics/report-items.jsp");
                
                }
            }

            if (nome.toString().equalsIgnoreCase("view-csc")) {
                Community[] comunidades = Community.findAllTop(context);
                Community[] subComunidades = Propriedades.getSubcomunidades(context, comunidades);
                Collection[] colecoes = Collection.findAll(context);

                String[] aceComu = getAcessos(context, comunidades, Constants.COMMUNITY);
                String[] aceSubComu = getAcessos(context, subComunidades, Constants.COMMUNITY);
                String[] aceCole = getAcessos(context, colecoes, Constants.COLLECTION);

                request.setAttribute("aceComu", aceComu);
                request.setAttribute("aceSubComu", aceSubComu);
                request.setAttribute("aceCole", aceCole);
                request.setAttribute("comunidades", comunidades);
                request.setAttribute("sub_comunidades", subComunidades);
                request.setAttribute("colecoes", colecoes);
                
                if(publico.equalsIgnoreCase("true")){
                  JSPManager.showJSP(request, response, "/statistics/report-view-csc.jsp");
                }
                else{JSPManager.showJSP(request, response, "/statistics/report-view-csc.jsp");}
            }

            if (nome.toString().equalsIgnoreCase("downloads-itens")) {
                /*
                * Arquivos mais baixados: Constants.BITSTREAM
                * Coleções mais acessadas: Constants.COLLECTION
                */
                ArrayList<Resultado> itensMais = getItensMaisBaixados(context);
                request.setAttribute("itens", itensMais);
                
                if(publico.equalsIgnoreCase("true")){
                JSPManager.showJSP(request, response, "/estatistica-publica/downloads-publica.jsp");
                }
                else{JSPManager.showJSP(request, response, "/statistics/report-view-items.jsp");}
            }

            if (nome.toString().equalsIgnoreCase("usuarios")) {
                int qtdeUsuarios = Propriedades.getQtdeusuarios(context);
                request.setAttribute("qtdeUsuarios", qtdeUsuarios);
                JSPManager.showJSP(request, response, "statistics/report-usuarios.jsp");
            }

            if (nome.toString().equalsIgnoreCase("buscas")) {
                JSPManager.showJSP(request, response, "statistics/report-busca.jsp");
            }
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException ioe) {
                }
            }

            if (ir != null) {
                try {
                    ir.close();
                } catch (IOException ioe) {
                }
            }

            if (fir != null) {
                try {
                    fir.close();
                } catch (IOException ioe) {
                }
            }
        }


    }


    private String[] getAcessos(Context context, DSpaceObject[] dsobject, int tipo) {
        String[] dados = new String[dsobject.length];
        DSpaceObject comp;

        try {
            comp = HandleManager.resolveToObject(context, dsobject[0].getHandle());

            for (int i = 0; i < dsobject.length -1; i++) {
                StatisticsListing statListing = new StatisticsListing(new StatisticsDataVisits(comp));
                
                DatasetDSpaceObjectGenerator dsoAxis = new DatasetDSpaceObjectGenerator();
                dsoAxis.addDsoChild(tipo, 50, false, -1);
                statListing.addDatasetGenerator(dsoAxis);
                Dataset dataset = statListing.getDataset();

                if (dataset == null) {
                    dataset = statListing.getDataset(context);
                }

                if (dataset != null) {
                    String[][] matrix = dataset.getMatrix();
                    dados[i] = matrix[0][0];

                    /*
                     * Nome, url e hits.
                     */
//                    List<String> colLabels = dataset.getColLabels();
//                    List<Map<String, String>> rowLabelsAttrs = dataset.getColLabelsAttrs();
//                    System.out.println("+++++++++++++++++++++++");
//                    for (int j = 0; j < matrix.length; j++) {
//                        String[] row = matrix[j];
//                        for (int k = 0; k < row.length; k++) {
//                            String cell = row[k];
//                            System.out.println(colLabels.get(k) + "\t" + cell + "\t" + rowLabelsAttrs.get(k).get("url"));
//                        }
//                    }
//                    System.out.println("+++++++++++++++++++++++");

                }
                comp = HandleManager.resolveToObject(context, dsobject[i + 1].getHandle());
            }
        } catch (Exception ex) {
            log.error("Erro ao criar estatísticas.", ex);
        }

        // Substitui os null por valores padrões.
        for (int i = 0; i < dados.length; i++) {
            if (dados[i] == null) {
                dados[i] = "0";
            }
        }

        return dados;
    }


    private ArrayList<Resultado> getItensMaisAcessados(Context context){
        ArrayList<Resultado> acessos = new ArrayList<Resultado>();

        StatisticsListing statListing = new StatisticsListing(new StatisticsDataVisits());
        DatasetDSpaceObjectGenerator dsoAxis = new DatasetDSpaceObjectGenerator();
        dsoAxis.addDsoChild(Constants.ITEM, 10, false, -1);
        statListing.addDatasetGenerator(dsoAxis);
        Dataset dataset = statListing.getDataset();

        try{
            if (dataset == null) {
                    dataset = statListing.getDataset(context);
            }
            if (dataset != null) {
                String[][] matrix = dataset.getMatrix();

                List<String> colLabels = dataset.getColLabels();
                List<Map<String, String>> rowLabelsAttrs = dataset.getColLabelsAttrs();
                for (int j = 0; j < matrix.length; j++) {
                    String[] row = matrix[j];
                    for (int k = 0; k < row.length; k++) {
                        String cell = row[k];
                        acessos.add(new Resultado(colLabels.get(k), rowLabelsAttrs.get(k).get("url"), cell));
                    }
                }
            }
        } catch (Exception ex) {
            log.error("Erro ao obter os Itens mais visitados.", ex);
        }

        return acessos;
    }
    
    private ArrayList<Resultado> getItensMaisBaixados(Context context){
        ArrayList<Resultado> acessos = new ArrayList<Resultado>();

        StatisticsListing statListing = new StatisticsListing(new StatisticsDataVisits());
        DatasetDSpaceObjectGenerator dsoAxis = new DatasetDSpaceObjectGenerator();
        dsoAxis.addDsoChild(Constants.BITSTREAM, 10, false, -1);
        statListing.addDatasetGenerator(dsoAxis);
        Dataset dataset = statListing.getDataset();

        try{
            if (dataset == null) {
                    dataset = statListing.getDataset(context);
            }
            if (dataset != null) {
                String[][] matrix = dataset.getMatrix();

                List<String> colLabels = dataset.getColLabels();
                List<Map<String, String>> rowLabelsAttrs = dataset.getColLabelsAttrs();
                String urlAux = ""; 
                for (int j = 0; j < matrix.length; j++) {
                    String[] row = matrix[j];
                    for (int k = 0; k < row.length; k++) {
                        String cell = row[k];
                        urlAux = rowLabelsAttrs.get(k).get("url");
                        if(urlAux.indexOf("handle") != -1){
                        urlAux = "http://repositorio.ufpa.br/jspui/" + urlAux.substring(urlAux.indexOf("handle"), urlAux.lastIndexOf("/"));
                        }
                        
                        acessos.add(new Resultado(colLabels.get(k),urlAux , cell));
                    }
                }
            }
        } catch (Exception ex) {
            log.error("Erro ao obter os Itens mais visitados.", ex);
        }

        return acessos;
    }


    public class Resultado{
        private String nome;
        private String url;
        private String visitas;

        public Resultado(String nome, String url, String visitas){
            this.nome = nome;
            this.url = url;
            this.visitas = visitas;
        }

        /**
         * @return the nome
         */
        public String getNome() {
            return nome;
        }

        /**
         * @param nome the nome to set
         */
        public void setNome(String nome) {
            this.nome = nome;
        }

        /**
         * @return the url
         */
        public String getUrl() {
            return url;
        }

        /**
         * @param url the url to set
         */
        public void setUrl(String url) {
            this.url = url;
        }

        /**
         * @return the visitas
         */
        public String getVisitas() {
            return visitas;
        }

        /**
         * @param visitas the visitas to set
         */
        public void setVisitas(String visitas) {
            this.visitas = visitas;
        }
    }

}