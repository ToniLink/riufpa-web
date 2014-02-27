<%--
    Document   : escolher-tipo
    Created on : 11/09/2012, 09:07:07
    Author     : portal
--%>

<%@page import="submissao.EscolherTipoDoc"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.app.webui.servlet.SubmissionController"%>
<%@page import="org.dspace.submit.AbstractProcessingStep"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);
    //Indica se uma opção estará marcada (checked='checked').
    String marcadoArtigo = "", marcadoTese = "", marcadoDissertacao = "", marcadoTrabalho = "", marcadoOutro = "";

    //O padrão é artigo científico.
    String tipoDoc = EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO.toString();
    Object temp = request.getAttribute(EscolherTipoDoc.TIPO_DOCUMENTO);
    if (temp != null){
        tipoDoc = temp.toString();
    }
%>

<dspace:layout locbar="off"
               navbar="off"
               title="Escolher o tipo de documento"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>

    <form action="<%= request.getContextPath()%>/submit" method="post">

        <jsp:include page="/submit/progressbar.jsp"></jsp:include>

        <div class="formularioDesc">

            <h3>Qual é o tipo do seu documento?</h3>

            <div id="tiposDoc">
                <table>
                    <%
                        if (tipoDoc.equals(EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO.toString())) {
                            marcadoArtigo = "checked=\"checked\"";
                        }
                    %>
                    <tr>
                        <td>
                            <input type="radio" id="artigo" <%= marcadoArtigo%> class="regular-radio"
                                   name="<%= EscolherTipoDoc.NAME_ESCOLHA_TIPO %>" value="<%= EscolherTipoDoc.TipoDoc.ARTIGO_CIENTIFICO%>">
                            <label for="artigo"></label>
                        </td>
                        <td>
                            <label for="artigo" class="descricao">Artigo Científico</label>
                        </td>
                    </tr>
                    <%
                        if (tipoDoc.equals(EscolherTipoDoc.TipoDoc.TESE.toString())) {
                            marcadoTese = "checked=\"checked\"";
                        }
                    %>
                    <tr>
                        <td>
                            <input type="radio" id="tese" <%= marcadoTese%> class="regular-radio"
                                   name="<%= EscolherTipoDoc.NAME_ESCOLHA_TIPO %>" value="<%= EscolherTipoDoc.TipoDoc.TESE%>">
                            <label for="tese"></label>
                        </td>
                        <td>
                            <label for="tese" class="descricao">Tese</label>
                        </td>
                    </tr>
                    <%
                        if (tipoDoc.equals(EscolherTipoDoc.TipoDoc.DISSERTACAO.toString())) {
                            marcadoDissertacao = "checked=\"checked\"";
                        }
                    %>
                    <tr>
                        <td>
                            <input type="radio" id="dissertacao" <%= marcadoDissertacao%> class="regular-radio"
                                   name="<%= EscolherTipoDoc.NAME_ESCOLHA_TIPO %>" value="<%= EscolherTipoDoc.TipoDoc.DISSERTACAO%>">
                            <label for="dissertacao"></label>
                        </td>
                        <td>
                            <label for="dissertacao" class="descricao">Dissertação</label>
                        </td>
                    </tr>

                    <%
                        if (tipoDoc.equals(EscolherTipoDoc.TipoDoc.TRABALHO.toString())) {
                            marcadoTrabalho = "checked=\"checked\"";
                        }
                    %>
                    <tr>
                        <td>
                            <input type="radio" id="trabalho" <%= marcadoTrabalho%> class="regular-radio"
                                   name="<%= EscolherTipoDoc.NAME_ESCOLHA_TIPO %>" value="<%= EscolherTipoDoc.TipoDoc.TRABALHO%>">
                            <label for="trabalho"></label>
                        </td>
                        <td>
                            <label for="trabalho" class="descricao">Trabalho Apresentado em Evento</label>
                        </td>
                    </tr>

                    <%
                        if (tipoDoc.equals(EscolherTipoDoc.TipoDoc.OUTRO.toString())) {
                            marcadoOutro = "checked=\"checked\"";
                        }
                    %>
                    <tr>
                        <td>
                            <input type="radio" id="outro" <%= marcadoOutro%> class="regular-radio"
                                   name="<%= EscolherTipoDoc.NAME_ESCOLHA_TIPO %>" value="<%= EscolherTipoDoc.TipoDoc.OUTRO%>">
                            <label for="outro"></label>
                        </td>
                        <td>
                            <label for="outro" class="descricao">Outro tipo</label>
                        </td>
                    </tr>
                </table>
                <br />


            </div>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <div id="controles">
                <div class="direita">
                    <input type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" class="button" value="<fmt:message key="jsp.submit.general.cancel-or-save.button"/>" />
                </div>
                <div class="esquerda">
                    <input type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" class="button" value="<fmt:message key="jsp.submit.general.previous"/>" />
                    <input type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" class="button" value="<fmt:message key="jsp.submit.general.next"/>" />
                </div>
            </div>

        </div>
    </form>

</dspace:layout>