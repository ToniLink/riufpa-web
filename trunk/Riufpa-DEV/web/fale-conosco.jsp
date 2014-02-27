<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="org.dspace.core.LogManager"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<%@page import="javax.mail.MessagingException"%>
<%@page import="org.dspace.app.webui.util.JSPManager"%>
<%@page import="java.util.Date"%>
<%@page import="org.dspace.core.Email"%>
<%@page import="org.dspace.core.ConfigurationManager"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.core.Context"%>


<%
    Context contexto = UIUtil.obtainContext(request);

//Se tiver alguém logado, tentar auto-completar as suas informações.
    String nomeEperson = "";
    String emailEperson = "";

    EPerson ep = contexto.getCurrentUser();
    if (ep != null) {
        nomeEperson = ep.getFullName();
        emailEperson = ep.getEmail();
    }

//inicia o processo de submissão do feedback.
    String submetendo = request.getParameter("submetendo");
    if (submetendo != null) {
        boolean captchaCorreto = false;
        String kaptchaExpected = (String) request.getSession().getAttribute(com.google.code.kaptcha.Constants.KAPTCHA_SESSION_KEY);
        String kaptchaReceived = request.getParameter("kaptcha");

        if (kaptchaReceived == null || !kaptchaReceived.equalsIgnoreCase(kaptchaExpected)) {
            captchaCorreto = false;
        } else {
            captchaCorreto = true;
        }

        if (captchaCorreto) {
            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String assunto = request.getParameter("assunto");
            String descricao = request.getParameter("feedback");
            String nomeUsuario = "Usuário Visitante";

            EPerson usuario = contexto.getCurrentUser();
            if (usuario != null) {
                nomeUsuario = usuario.getFullName();
            } else {
                nomeUsuario = nome;
            }

            // All data is there, send the email
            try {
                Email destinatario = ConfigurationManager.getEmail("/dspace/config/emails/fale_conosco.txt");

                destinatario.addRecipient(ConfigurationManager.getProperty("feedback.recipient"));

                destinatario.addArgument(nomeUsuario);
                destinatario.addArgument(assunto);
                destinatario.addArgument(descricao);
                destinatario.addArgument(email);
                destinatario.addArgument(assunto);
                destinatario.addArgument(new Date()); // Date

                // Replying to feedback will reply to destinatario on form
                destinatario.setReplyTo(email);

                destinatario.send();

                JSPManager.showJSP(request, response, "/feedback/acknowledge.jsp");
            } catch (MessagingException me) {
                JSPManager.showInternalError(request, response);
            }
        } else {
            request.setAttribute("cod_errado", "true");
        }
    }

    contexto.complete();
%>

<dspace:layout titlekey="jsp.feedback.form.title">

    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/fale-conosco.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/fale-conosco.css" type="text/css"/>

    <%-- Configura as mensagens de alertas de acordo com o idioma atual --%>
    <script type="text/javascript">
        setAlertas("<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.contact.alert.name") %>",
        "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.contact.alert.email") %>",
        "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.contact.alert.subject") %>",
        "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.contact.alert.message") %>");
    </script>

    <form name="faleConosco" id="cadastro_usuario" method="post" onsubmit="return validaCampo(this);" accept-charset="UTF-8">
        <h3>
            <fmt:message key="jsp.contact.title"/>
        </h3>

        <div style="text-align: center; margin-bottom: 10px;">
            <fmt:message key="jsp.contact.msg">
                <fmt:param value="<span id='obrigatorio'>*</span>"/>
            </fmt:message>
        </div>

        <table>
            <tr>
                <td>
                    <label for="tnome">
                        <fmt:message key="jsp.contact.field.name"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <input class="input" type="text" id="tnome" size="40%" name="nome" value="<%=StringEscapeUtils.escapeHtml(nomeEperson)%>" /><br>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="temail">
                        <fmt:message key="jsp.contact.field.email"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <input class="input" type="text" name="email" id="temail" size="40%" value="<%=StringEscapeUtils.escapeHtml(emailEperson)%>"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="assunto">
                        <fmt:message key="jsp.contact.field.subject"/><span id="obrigatorio">*</span>:
                    </label><br>
                </td>
                <td>
                    <select  name="assunto" style=" width: 100%;" id="assunto" >
                        <option value="" selected="selected">
                            <fmt:message key="jsp.contact.field.subject.choose"/>
                        </option>
                        <option value="Dúvida">
                            <fmt:message key="jsp.contact.field.subject.doubt"/>
                        </option>
                        <option value="Elogio">
                            <fmt:message key="jsp.contact.field.subject.compliment"/>
                        </option>
                        <option value="Sugestão">
                            <fmt:message key="jsp.contact.field.subject.suggestion"/>
                        </option>
                        <option value="Reclamação">
                            <fmt:message key="jsp.contact.field.subject.complaint"/>
                        </option>
                        <option value="Outro">
                            <fmt:message key="jsp.contact.field.subject.other"/>
                        </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="tfeedback">
                        <fmt:message key="jsp.contact.field.text"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <textarea class="input" name="feedback" id="tfeedback" rows="6" cols="40" ></textarea>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="kaptcha">
                        <fmt:message key="jsp.contact.field.captcha"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <div style="display: block; margin-top: 10px;">
                        <fmt:message key="jsp.contact.field.captcha.msg"/>
                    </div>

                    <div style="margin-top: 10px;">
                        <img src="kaptcha.jpg" id="img_captcha" />

                        <a class="button" id="trocar_img" onclick="trocarCaptcha();" href="javascript:void(0);">
                            <fmt:message key="jsp.contact.field.captcha.change"/>
                        </a>
                    </div>

                    <div style="display: block; margin-top: 5px;">
                        <input type="text" name="kaptcha" id="kaptcha" value="" />
                    </div>
                    <%
                        Object r = request.getAttribute("cod_errado");
                        if (r != null && r.toString() == "true") {
                    %>
                    <div id="capctha_erro">
                        <fmt:message key="jsp.contact.field.captcha.wrong"/>
                    </div>
                    <%                        }
                    %>
                </td>
            </tr>
            <tr id="enviar">
                <td colspan="2">
                    <br /><br />
                    <input type="hidden" name="submetendo" value="true"/>
                    <input class="button" name="submit" type="submit" value="<fmt:message key="jsp.contact.send"/>"/>
                </td>
            </tr>

        </table>
    </form>

</dspace:layout>