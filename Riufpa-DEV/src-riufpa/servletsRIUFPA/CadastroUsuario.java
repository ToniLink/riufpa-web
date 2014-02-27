/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package servletsRIUFPA;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.MessagingException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.Email;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.EPersonDeletionException;
import org.dspace.eperson.Group;

/**
 *
 * @author portal
 */
public class CadastroUsuario extends HttpServlet {

    public static String PASSO = "passo";
    public static String PASSO_INICIAL = "0";
    public static String ID_USUARIO = "id";
    public static String PASSO_APROVAR = "Aprovar Cadastro";
    public static String PASSO_REPROVAR = "Confirmar Reprovação de Cadastro";

    public static String PASSO_ALTERAR_GRUPO = "Alterar Grupo";
    public static String NOVO_GRUPO = "Novo Grupo";

    public static int GRUPO_ADMINISTRADOR = 1;
    public static int GRUPO_CATALOGADOR = 105;
    public static int GRUPO_GESTOR = 113;

    private static HashMap<Integer, Integer> original = new HashMap<Integer, Integer>();

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
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String temp = (String) request.getParameter(PASSO);
            //Como o parâmetro pode ter acentos, vamos convertê-lo para UTF-8.
            String opcao = new String(temp.getBytes(), "UTF-8");
            System.out.println("opção: "+opcao);
            if(opcao.equals(PASSO_INICIAL)){
                cadastrarUsuario(request, response);
            } else if (opcao.equals(PASSO_APROVAR)){
                aprovar(request, response, Integer.parseInt(request.getParameter(ID_USUARIO)));
            } else if (opcao.equals(PASSO_REPROVAR)){
                reprovar(request, response, Integer.parseInt(request.getParameter(ID_USUARIO)));
            } else if (opcao.equals(PASSO_ALTERAR_GRUPO)){
                alterarGrupo(request, response, request.getParameter(NOVO_GRUPO), Integer.parseInt(request.getParameter(ID_USUARIO)));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } catch (AuthorizeException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();
        }
    }

    public static void cadastrarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, AuthorizeException, ServletException, IOException{
        String kaptchaExpected = (String) request.getSession().getAttribute(com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);
        String kaptchaReceived = request.getParameter("kaptcha");

        if (kaptchaReceived == null || !kaptchaReceived.equalsIgnoreCase(kaptchaExpected)) {
            request.setAttribute("cod_errado", "true");
            JSPManager.showJSP(request, response, "/register/new-user.jsp");
            return;
        }

        Context context = new Context();

        //Pega os dados do usuário
        String nome = request.getParameter("nome");
        String sobrenome = request.getParameter("sobrenome");
        String email = request.getParameter("email");
        String telefone = request.getParameter("telefone");
        String senha = request.getParameter("senha");
        //Escolhe o tipo de grupo ao qual vai pertencer
        /*String conta = request.getParameter("tipo_conta");
        Group group = null;
        if(conta.equals("Catalogador")){
            group = Group.findByName(context, "Catalogador");
        } else if(conta.equals("Gestor")){
            group = Group.findByName(context, "Gestor");
        } else if(conta.equals("Administrador")){
            group = Group.findByName(context, "Administrador");
        }*/
        Group group = Group.find(context, 0); //por enquanto, todos são Anonymous

        //Se o e-mail já está cadastrado, então encerra o cadastro e diz que já tem conta para o e-mail.
        EPerson temp = EPerson.findByEmail(context, email);
        if(temp != null){
            JSPManager.showJSP(request, response, "/register/already-registered.jsp");
            context.complete();
            return ;
        }

        //Para criar o eperson temos que ter autorização
        context.setIgnoreAuthorization(true); //liga

        EPerson eperson;
        eperson = EPerson.create(context);
        eperson.setFirstName(nome);
        eperson.setLastName(sobrenome);
        eperson.setEmail(email);
        eperson.setLanguage("pt_BR");
        eperson.setMetadata("phone", telefone); //os argumentos são: coluna da tabela eperson, e valor a inserir.
        //eperson.setCanLogIn(false); //O usuário ainda NÃO pode logar até ser aprovado.
        eperson.setCanLogIn(true); //O usuário, na verdade, pode logar até até termos o sistema de permissões pronto.
        eperson.setSelfRegistered(true);
        eperson.setPassword(senha);
        eperson.update(); //salva no banco de dados.

        context.setIgnoreAuthorization(false); //desliga

        request.setAttribute("eperson", eperson);
        JSPManager.showJSP(request, response, "/register/registered.jsp");

        group.addMember(eperson);
        group.update();

        original.put(eperson.getID(), group.getID());

        //envia um email pro usuário
        Email usu = ConfigurationManager.getEmail("/dspace/config/emails/confirmacao_cadastro.txt");
        usu.addRecipient(email);
        usu.addArgument(request.getContextPath() + "/password-login");
        try{
            usu.send();
        } catch(MessagingException ex){
            System.err.println("Erro ao enviar e-mail. Será que ele existe?");
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        }

        //ENVIAR EMAILS PARA  OS ADMINISTRADORES (AINDA NÃO)
        /*
        EPerson[] groupadmin = Group.findByName(context, "Administrador").getMembers();
        Email emailadmin = ConfigurationManager.getEmail("/dspace/config/emails/novo_cadastro.txt");
        //Enviaremos para todos os administradores
        for (int i = 0; i < groupadmin.length; i++) {
            emailadmin.addRecipient(groupadmin[i].getEmail());
        }
        emailadmin.addArgument(nome + " " + sobrenome);
        emailadmin.addArgument(email);
        emailadmin.addArgument(telefone);
        emailadmin.addArgument(group.getName());
        emailadmin.addArgument("http://localhost:8080/jspui/register/aprovacao.jsp?id_user="+eperson.getID()+"&grupo="+group.getName()+"&original=true");
        try {
            emailadmin.send();
        } catch (MessagingException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        }
        */

        context.complete();
    }

    private void aprovar(HttpServletRequest request, HttpServletResponse response, int id) throws SQLException{
        Context cont = new Context();
        try {
            EPerson eperson = EPerson.find(cont, id);
            if(eperson != null){

                String grupoOriginal = null;
                if(original.containsKey(id)){
                    grupoOriginal = Group.find(cont, original.get(id)).getName();
                }

                //Para editar o eperson temos que ter autorização
                cont.setIgnoreAuthorization(true); //liga :)
                eperson.setCanLogIn(true);
                eperson.update();
                cont.setIgnoreAuthorization(false);

                RequestDispatcher rd = getServletConfig().getServletContext().getRequestDispatcher("/register/aprovado.jsp?id_user="+id);

                if(original == null){
                    Email emailuser = ConfigurationManager.getEmail("/dspace/config/emails/cadastro_liberado.txt");
                    emailuser.addRecipient(eperson.getEmail());
                    emailuser.addArgument(eperson.getFullName());
                    emailuser.addArgument(request.getContextPath() + "/password-login");
                    emailuser.send();
                } else{ //seu grupo foi alterado.

                }

                rd.forward(request, response);

            } else{
                System.out.println("Inexistente");
            }
        } catch (Exception ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } finally{
            cont.complete();
        }
    }

    private void reprovar(HttpServletRequest request, HttpServletResponse response, int id) throws SQLException{
        Context cont = new Context();
        try {
            EPerson eperson = EPerson.find(cont, id);
            if(eperson != null){
                RequestDispatcher rd = getServletConfig().getServletContext().getRequestDispatcher("/register/reprovado.jsp?id_user=" + id);

                Email emailuser = ConfigurationManager.getEmail("/dspace/config/emails/cadastro_reprovado.txt");
                emailuser.addRecipient(eperson.getEmail());
                emailuser.addArgument(eperson.getFullName());
                emailuser.addArgument(request.getParameter("justificativa"));
                emailuser.send();

                //Para deletar o eperson temos que ter autorização
                cont.setIgnoreAuthorization(true);
                eperson.delete();
                cont.setIgnoreAuthorization(false);

                rd.forward(request, response);

            } else{
                System.out.println("Inexistente");
            }
        }catch (ServletException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } catch (AuthorizeException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } catch (EPersonDeletionException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            cont.complete();
        }
    }

    private void alterarGrupo(HttpServletRequest request, HttpServletResponse response, String grupo, int id) throws SQLException{
        Context cont = new Context();
        try {
            EPerson eperson = EPerson.find(cont, id);

            if(eperson != null){

                //Retira o eperson de todos os outros grupos exceto o 'Anonymous'.
                Group[] allMemberGroups = Group.allMemberGroups(cont, eperson);
                for (int i = 0; i < allMemberGroups.length; i++) {
                    if(!allMemberGroups[i].getName().equals("Anonymous")){ //não mexemos no Anonymous
                        allMemberGroups[i].removeMember(eperson); //Tira o eperson de qualquer outro grupo.
                        allMemberGroups[i].update();
                    }
                }

                Group novoGrupo = Group.findByName(cont, grupo); //Pega o novo grupo
                novoGrupo.addMember(eperson); //troca o eperson de grupo
                novoGrupo.update(); //grava as informações

                response.sendRedirect(request.getContextPath() + "/register/aprovacao.jsp?id_user=" + id);

            } else{
                System.out.println("Inexistente");
            }

        } catch (IOException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } catch (AuthorizeException ex) {
            Logger.getLogger(CadastroUsuario.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            cont.complete();
        }
    }

    private int getGrupo(EPerson eperson, Context cont){
        try{
            Group[] allMemberGroups = Group.allMemberGroups(cont, eperson);
            System.out.println("Presente em:");
            for (int i = 0; i < allMemberGroups.length; i++) {
                int id = allMemberGroups[i].getID();
                if(id == GRUPO_ADMINISTRADOR || id == GRUPO_CATALOGADOR || id == GRUPO_GESTOR){
                    return id;
                }
            }
        } catch(Exception ex){

        }
        return -1;
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
