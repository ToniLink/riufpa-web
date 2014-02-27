/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servletsRIUFPA.json;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author portal
 */
public class DadosGrafico extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        try {
            JSONObject obj = new JSONObject();

            JSONArray list = new JSONArray();

            JSONArray series = new JSONArray();

            JSONArray valores = new JSONArray();
            valores.put(0);
            valores.put(6);

            JSONArray valores2 = new JSONArray();
            valores2.put(7);
            valores2.put(8);

            JSONArray valores3 = new JSONArray();
            valores3.put(5);
            valores3.put(10);

            series.put(valores);
            series.put(valores2);
            series.put(valores3);

            list.put(series);


            //opções
            JSONObject opcoes = new JSONObject();

            JSONObject mouse = new JSONObject();
            mouse.put("track", true);

            JSONObject xaxis = new JSONObject();
            xaxis.put("noTicks", 10);
            xaxis.put("tickDecimals", 1);

            opcoes.put("mouse", mouse);
            opcoes.put("xaxis", xaxis);


            obj.put("series", list);
            obj.put("options", opcoes);

            System.out.println(obj.toString());
            out.print(obj.toString());
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
