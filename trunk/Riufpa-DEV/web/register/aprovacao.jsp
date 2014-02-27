<%-- 
    Document   : aprovacao
    Created on : 04/04/2012, 11:31:13
    Author     : portal
--%>

<%@page import="java.util.Iterator"%>
<%@page import="java.util.Set"%>
<%@page import="org.dspace.eperson.Group"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="servletsRIUFPA.CadastroUsuario"%>
<%@page import="org.dspace.app.webui.util.JSPManager"%>
<%@page import="org.dspace.core.LogManager"%>
<%@page import="org.dspace.app.webui.servlet.PasswordServlet"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="javax.servlet.jsp.jstl.core.Config"%>
<%@page import="org.dspace.core.I18nUtil"%>
<%@page import="java.util.Locale"%>
<%@page import="org.dspace.app.webui.util.Authenticate"%>
<%@page import="org.dspace.authenticate.AuthenticationMethod"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.authenticate.AuthenticationManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%!
public boolean verGrupo(int id, Context cont, EPerson ep){
    try{
        Group grupoUser = Group.find(cont, id);
        EPerson[] membros = grupoUser.getMembers();
        for(int i=0; i<membros.length; i++){
            if(membros[i].getID() == ep.getID()){
                return true; //pertence a este grupo
            }
        }
    } catch(Exception ex){
        return false;
    }
    
    return false; //não pertence
}

%>

<%
    Logger log = Logger.getLogger(PasswordServlet.class);
    String email = request.getParameter("login_email");
    String password = request.getParameter("login_password");
    String jsp = null;
    String id = request.getParameter("id_user");

    // Locate the eperson
    Context context = new Context();
    int status = AuthenticationManager.authenticate(context, email, password, null, request);


    if (status == AuthenticationMethod.SUCCESS) {
        // Logged in OK.
        Authenticate.loggedIn(context, request, context.getCurrentUser());

        // Set the Locale according to user preferences
        Locale epersonLocale = I18nUtil.getEPersonLocale(context.getCurrentUser());
        context.setCurrentLocale(epersonLocale);
        Config.set(request.getSession(), Config.FMT_LOCALE, epersonLocale);

        log.info(LogManager.getHeader(context, "login", "type=explicit")); 
        
        //Confirma o login, mas diz pra voltar pra cá.
        id = request.getParameter("id_user");        
        response.sendRedirect(request.getContextPath() + "/mydspace?fazendo_aprovacao=true&id_user=" + id);
        
        context.complete();

        return;
    }
    else if (status == AuthenticationMethod.CERT_REQUIRED)
        jsp = "/error/require-certificate.jsp";
    else
        jsp = "/login/incorrect.jsp";
    
    //JSPManager.showJSP(request, response, jsp);
        
    String nome = "Erro ao recuperar nome do usuário " + id;
    String emailUser = "Erro ao recuperar e-mail do usuário " + id;
    String telefone = "Erro ao recuperar telefone do usuário " + id;
    String grupo = "Erro ao recuperar grupo do usuário " + id;
    
    boolean naoExiste = false;
    boolean ativa = false;
    
    EPerson eperson = EPerson.find(context, Integer.parseInt(id));
    if(eperson != null){
        nome = eperson.getFullName();
        emailUser = eperson.getEmail();
        String temp = eperson.getMetadata("phone");
        if(temp != null && !temp.equals("")){
            telefone = temp;
        }
        if(this.verGrupo(1, context, eperson)){
            grupo = "Administrador";
        } else if(this.verGrupo(113, context, eperson)){
            grupo = "Gestor";
        } else if(this.verGrupo(105, context, eperson)){
            grupo = "Catalogador";
        }
        ativa = eperson.canLogIn();
    } else{
        naoExiste = true;
    }
    
    context.complete();
    
    //Você deve estar logado. Note que isso deve ser posto ANTES de qualquer output.
    String usuario = (String) session.getAttribute("nome_usuario");
    if(usuario == null){
%>

    <dspace:layout locbar="link">

        <form method="post">
            <p style="text-align: center;">
                Você precisa fazer login para avaliar o cadastro.
            </p>
            <table border="0" cellpadding="5" align="center">
                <tr>
                    <td class="standard" align="right">
                        <label for="tlogin_email"><strong><fmt:message key="jsp.components.login-form.email"/></strong></label>
                    </td>
                    <td>
                        <input type="text" name="login_email" id="tlogin_email" />
                    </td>
                </tr>
                <tr>
                    <td class="standard" align="right">
                        <label for="tlogin_password"><strong><fmt:message key="jsp.components.login-form.password"/></strong></label>
                    </td>
                    <td>
                        <input type="password" name="login_password" id="tlogin_password" />
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        <input type="submit" name="login_submit" value="<fmt:message key="jsp.components.login-form.login"/>" />
                    </td>
                </tr>
            </table>
        </form>

        <p style="text-align: center;">
            <a href="<%= request.getContextPath() %>/forgot"><fmt:message key="jsp.components.login-form.forgot"/></a>
        </p>
    </dspace:layout>
<%
    } else if (naoExiste) { //USUÁRIO NÃO EXISTE (ID INVÁLIDO)
%>
    <dspace:layout locbar="link" navbar="admin">    
        <p style="margin-left: auto; margin-right: auto; text-align: center; font-size: 14pt; font-weight: bold;">
            O usuário com id <%=id%> não existe.
        </p>
        <div style="text-align: center;">
            <a href="<%= request.getContextPath() %>"> Ir para a Página Inicial </a><br /><br />
            <a href="<%= request.getContextPath() %>/mydspace"> Ir para o Meu Espaço </a>
        </div>
    </dspace:layout>
<%
    } else if (!ativa) { //AINDA NÃO APROVARAM
%>
    <dspace:layout locbar="link" navbar="admin">
        <p style="margin-left: auto; margin-right: auto; text-align: center; font-size: 14pt; font-weight: bold;">
            Aprovação de Novo Cadastro
        </p>
        
        <div style="text-align: center;">
            O usuário abaixo está requerendo uma conta no RIUFPA. Analise os dados cadastrais e decida se essa conta
            será aprovada ou não.
        </div>
        
        <style type="text/css">
            .cadastro{
                background-color: #EBF0FD !important;
                margin-left: auto;
                margin-right: auto;
            }
            .cadastro th{
                text-align: center;
                padding: 10px;
                background: #C9D8FF;
            }
            .cadastro td{
                padding:10px; 
                text-align:justify;
            }
            
            .reprovado{
                background-color: #EBF0FD !important;
                margin-left: auto;
                margin-right: auto;
                padding: 20px;
            }
            
        </style>
        
        <table class="cadastro">
            <tbody>
                <tr>
                    <td><b>Nome</b></td>
                    <td><%= nome %></td>
                </tr>
                <tr>
                    <td><b>E-mail</b></td>
                    <td><%= emailUser %></td>
                </tr>
                <tr>
                    <td><b>Telefone</b></td>
                    <td><%= telefone %></td>
                </tr>
                <tr>
                    <td><b>Tipo de conta desejada</b></td>
                    <td><%= grupo %></td>
                </tr>
                <tr>
                    <td><b>Alterar o tipo de conta para</b></td>
                    <td>
                        <form method="POST" action="<%= request.getContextPath() %>/CadastroUsuario">
                            <input type="hidden" name="<%= CadastroUsuario.PASSO %>" value="<%= CadastroUsuario.PASSO_ALTERAR_GRUPO %>"/>
                            <input type="hidden" name="<%= CadastroUsuario.ID_USUARIO %>" id="<%= CadastroUsuario.ID_USUARIO %>" value="<%= id %>"/>
                            <input type="submit" name="<%= CadastroUsuario.NOVO_GRUPO %>" value="Catalogador"/>
                            <input type="submit" name="<%= CadastroUsuario.NOVO_GRUPO %>" value="Gestor"/>
                            <input type="submit" name="<%= CadastroUsuario.NOVO_GRUPO %>" value="Administrador"/>
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
               
        <div style="text-align: center; padding: 10px;">
            <form action="<%= request.getContextPath() %>/CadastroUsuario" method="POST">
                <input type="hidden" name="<%= CadastroUsuario.ID_USUARIO %>" id="<%= CadastroUsuario.ID_USUARIO %>" value="<%= id %>"/>
                <input type="hidden" name="grupo" id="grupo" value="<%= grupo %>"/>
                <input type="submit" name="<%= CadastroUsuario.PASSO %>" id="<%= CadastroUsuario.PASSO %>" value="<%= CadastroUsuario.PASSO_APROVAR %>"/>
                <input type="button" onclick="mostrarJust();" value="Reprovar Cadastro"/>
                
                <br /><br />
                <div class="reprovado" style="display: none;" id="mostrar">
                    Por favor, escreva a justificativa para a reprovação do cadastro.<br /><br />
                    <textarea cols="60" rows="10" name="justificativa"></textarea><br /><br />
                    <input type="submit" name="<%= CadastroUsuario.PASSO %>" value="<%= CadastroUsuario.PASSO_REPROVAR %>"/>
                </div>
            </form>
        </div>
                
        <script type="text/javascript">
            function mostrarJust(){
                Effect.toggle('mostrar', 'appear', { delay: 0.1 });
            }
        </script>
        
    </dspace:layout>
<%
    } else if (ativa) { //JÁ FOI APROVADA
%>    
    <dspace:layout locbar="link" navbar="admin">    
        <p style="margin-left: auto; margin-right: auto; text-align: center; font-size: 14pt; font-weight: bold;">
                A conta deste usuário (<%=nome%>) já foi aprovada.
        </p>
        <div style="text-align: center;">
            <a href="<%= request.getContextPath() %>"> Ir para a Página Inicial </a><br /><br />
            <a href="<%= request.getContextPath() %>/mydspace"> Ir para o Meu Espaço </a>
        </div>
    </dspace:layout>        
<%
    }
%>