<%--
  - new-user.jsp
  -
  - Version: $Revision: 3705 $
  -
  - Date: $Date: 2009-04-11 17:02:24 +0000 (Sat, 11 Apr 2009) $
  -
  - Copyright (c) 2002, Hewlett-Packard Company and Massachusetts
  - Institute of Technology.  All rights reserved.
  -
  - Redistribution and use in source and binary forms, with or without
  - modification, are permitted provided that the following conditions are
  - met:
  -
  - - Redistributions of source code must retain the above copyright
  - notice, this list of conditions and the following disclaimer.
  -
  - - Redistributions in binary form must reproduce the above copyright
  - notice, this list of conditions and the following disclaimer in the
  - documentation and/or other materials provided with the distribution.
  -
  - - Neither the name of the Hewlett-Packard Company nor the name of the
  - Massachusetts Institute of Technology nor the names of their
  - contributors may be used to endorse or promote products derived from
  - this software without specific prior written permission.
  -
  - THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  - ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  - LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  - A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  - HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
  - INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  - BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
  - OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  - ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
  - TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
  - USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  - DAMAGE.
--%>


<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.core.I18nUtil"%>
<%--
  - Register with DSpace form
  -
  - Form where new users enter their email address to get a token to access
  - the personal info page.
  -
  - Attributes to pass in:
  -     retry  - if set, this is a retry after the user entered an invalid email
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.dspace.app.webui.servlet.RegisterServlet" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@ page import="servletsRIUFPA.CadastroUsuario"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    boolean retry = (request.getAttribute("retry") != null);

    //Se há um usuário logado, redireciona para o meu espaço.
    String usuario = (String) session.getAttribute("nome_usuario");
    if (usuario != null) {
        response.sendRedirect(request.getContextPath() + "/mydspace");
    }

    String nome = "";
    String sobrenome = "";
    String email = "";
    String telefone = "";

    if( request.getParameter("nome") != null){
        nome = request.getParameter("nome").toString();
    }
    if( request.getParameter("sobrenome") != null){
        sobrenome = request.getParameter("sobrenome").toString();
    }
    if( request.getParameter("email") != null){
        email = request.getParameter("email").toString();
    }
    if( request.getParameter("telefone") != null){
        telefone = request.getParameter("telefone").toString();
    }
%>

<dspace:layout titlekey="jsp.register.new-user.title">

    <%-- Estilos do formulário --%>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/new-user.css" type="text/css" />

    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/protopass/protopass.js"></script>

    <%-- Biblioteca para o Protopass --%>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/chosen/chosen/chosen.js"></script>

    <%
        if (retry) {
    %>
    <p><fmt:message key="jsp.register.new-user.info1"/></p>
    <%  }%>

    <form id="cadastro_usuario" method="POST" action="<%= request.getContextPath()%>/CadastroUsuario" onsubmit="return validarFormulario();">
        <h3>
            <fmt:message key="jsp.register.title"/>
        </h3>
        <div style="text-align: center; margin: 20px;">
            <fmt:message key="jsp.register.instructions">
                <fmt:param value="<span id='obrigatorio'>*</span>"/>
            </fmt:message>
        </div>

        <table>
            <tr>
                <td>
                    <label for="nome">
                        <fmt:message key="jsp.register.field.name"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <input type="text" name="nome" id="nome" class="input" value="<%= nome %>"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="sobrenome">
                        <fmt:message key="jsp.register.field.lastname"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <input type="text" name="sobrenome" id="sobrenome" class="input" value="<%= sobrenome %>"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="email">
                        <fmt:message key="jsp.register.field.email"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <input type="text" name="email" id="email" class="input" value="<%= email %>"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="telefone">
                        <fmt:message key="jsp.register.field.phone"/>:
                    </label>
                </td>
                <td>
                    <input type="text" name="telefone" id="telefone" class="input" value="<%= telefone %>"/>
                </td>
            </tr>



            <%-- Por enquanto, todos os usuários serão cadastrados como Anonymous.
            <div class="field">
                <label for="tipo_conta">Tipo de conta<span id="obrigatorio">*</span>:</label>
                <input type="radio" name="tipo_conta" id="tipo_conta" value="Anonymous" checked="checked" onclick="mostrarTexto('Anonymous');"/> Usuário
                <input type="radio" name="tipo_conta" id="tipo_conta" value="Depositante" onclick="mostrarTexto('Depositante');"/> Depositante
                <input type="radio" name="tipo_conta" id="tipo_conta" value="Catalogador" onclick="mostrarTexto('Catalogador');"/> Catalogador
                <input type="radio" name="tipo_conta" id="tipo_conta" value="Revisor" onclick="mostrarTexto('Revisor');"/> Revisor
            </div>

        <div class="descricaoConta" id="descricao_conta">
            <i>Clique em uma conta para ver sua descrição.</i>
        </div>
            --%>
            <tr>
                <td>
                    <label for="senha">
                        <fmt:message key="jsp.register.field.password"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <%--Mínimo 6 caracteres.--%>
                    <input type="password" name="senha" id="senha" class="input" onfocus="showIndicador();" onblur="hideIndicador();"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="confirmar_senha">
                        <fmt:message key="jsp.register.field.password.retype"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <input type="password" name="confirmar_senha" id="confirmar_senha" class="input"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label for="kaptcha">
                        <fmt:message key="jsp.register.field.captcha"/><span id="obrigatorio">*</span>:
                    </label>
                </td>
                <td>
                    <div style="display: block; margin-top: 10px;">
                        <fmt:message key="jsp.register.field.captcha.msg"/>
                    </div>

                    <div style="margin-top: 10px;">
                        <img src="kaptcha.jpg" id="img_captcha" />

                        <a class="button" id="trocar_img" onclick="trocarCaptcha();" href="javascript:void(0);">
                            <fmt:message key="jsp.register.field.captcha.change"/>
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
                        <fmt:message key="jsp.register.field.captcha.wrong"/>
                    </div>
                    <%                        }
                    %>
                </td>
            </tr>
            <tr id="enviar">
                <td colspan="2">
                    <br /><br />
                    <%-- Este é o passo inicial. Estamos apenas enviando as informações. --%>
                    <input type="hidden" name="<%=CadastroUsuario.PASSO%>" id="<%=CadastroUsuario.PASSO%>" value="<%=CadastroUsuario.PASSO_INICIAL%>"/>
                    <input type="submit" class="button" id="confirmar" value="<fmt:message key="jsp.register.send"/>"/>
                </td>
            </tr>

        </table>
    </form>

    <script type="text/javascript">
        /*
         * Evita colar texto nos campos de senha.
         */
        window.onload = function() {
            var senha = $('senha');
            var repetir_senha = $('confirmar_senha');
            senha.onpaste = function(e) {
                e.preventDefault();
            };
            repetir_senha.onpaste = function(e) {
                e.preventDefault();
            };
        };

        function trocarCaptcha () {
            $('img_captcha').src = 'kaptcha.jpg?' + Math.floor(Math.random()*100);
        }

        function hideIndicador(){
            $('senha_bar').hide();
            $('senha_text').hide();
        }

        function showIndicador(){
            triggerEvent($('senha'), 'keyup');
            $('senha_bar').show();
            $('senha_text').show();
        }

        // this supports trigger native events such as 'onchange'
        // whereas prototype.js Event.fire only supports custom events
        function triggerEvent(element, eventName) {
            // safari, webkit, gecko
            if (document.createEvent)
            {
                var evt = document.createEvent('HTMLEvents');
                evt.initEvent(eventName, true, true);
                return element.dispatchEvent(evt);
            }

            // Internet Explorer
            if (element.fireEvent) {
                return element.fireEvent('on' + eventName);
            }
        }

        new Protopass('senha', {
            common: ["password", "123456", "123", "1234", "mypass", "pass", "letmein", "qwerty", "monkey", "asdfgh", "zxcvbn", "pass", 'contraseña', '741852963', '963852741'],
            messages: [
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.insecure") %>",
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.tooshort") %>",
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.tooweak") %>",
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.weak") %>",
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.average") %>",
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.strong") %>",
                "<%= LocaleSupport.getLocalizedMessage(pageContext, "jsp.register.field.password.toostrong") %>"
                ]
        });
    </script>

</dspace:layout>