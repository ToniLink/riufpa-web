<%--
  - choose-file.jsp
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

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
           prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.submit.step.UploadStep" %>
<%@ page import="org.dspace.app.util.DCInputSet" %>
<%@ page import="org.dspace.app.util.DCInputsReader" %>
<%@ page import="org.dspace.app.util.SubmissionInfo" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>


<%
    request.setAttribute("LanguageSwitch", "hide");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);

    //get submission information object
    SubmissionInfo subInfo = SubmissionController.getSubmissionInfo(context, request);

    // Determine whether a file is REQUIRED to be uploaded (default to true)
    boolean fileRequired = ConfigurationManager.getBooleanProperty("webui.submit.upload.required", true);
%>


<dspace:layout locbar="off"
               navbar="off"
               titlekey="jsp.submit.choose-file.title"
               nocache="true">

    <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/estilos-submissao.css" type="text/css"/>


    <form method="post" id="enviarArquivo" action="<%= request.getContextPath()%>/submit" enctype="multipart/form-data" onkeydown="return disableEnterKey(event);">

        <jsp:include page="/submit/progressbar.jsp"/>

        <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
        <%= SubmissionController.getSubmissionParameters(context, request)%>

        <div class="formularioDesc">
            <%-- <h1>Submit: Upload a File</h1> --%>
            <h3><fmt:message key="jsp.submit.choose-file.heading"/></h3>

            <%-- <p>Please enter the name of
            <%= (si.submission.hasMultipleFiles() ? "one of the files" : "the file" ) %> on your
            local hard drive corresponding to your item.  If you click "Browse...", a
            new window will appear in which you can locate and select the file on your
            local hard drive. <object><dspace:popup page="/help/index.html#upload">(More Help...)</dspace:popup></object></p> --%>

            <p><fmt:message key="jsp.submit.choose-file.info1"/>
                <%--
                <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext,
                            \"help.index\") + \"#upload\"%>"><fmt:message key="jsp.morehelp"/></dspace:popup></p>
                --%>

            <%-- FIXME: Collection-specific stuff should go here? --%>
            <%-- <p class="submitFormHelp">Please also note that the DSpace system is
            able to preserve the content of certain types of files better than other
            types.
            <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.formats\")%>">Information about file types</dspace:popup> and levels of
            support for each are available.</p> --%>

            <%--
            <div class="submitFormHelp"><fmt:message key="jsp.submit.choose-file.info6"/>
                <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext,
            \"help.formats\")%>"><fmt:message key="jsp.submit.choose-file.info7"/></dspace:popup>
                </div>
            --%>

            <p style="text-align: center;">
                <%--
                        <label for="tfile"><fmt:message key="jsp.submit.choose-file.document"/></label>
                --%>
                        <input type="file" size="40" name="file" id="tfile" />

            </p>

                <%
                    if (subInfo.getSubmissionItem().hasMultipleFiles()) {
                %>
                        <p>
                        <fmt:message key="jsp.submit.choose-file.info9"/>
                        </p>
                        <p style="text-align: center;">
                        <label for="tdescription"><fmt:message key="jsp.submit.choose-file.filedescr"/></label>
                    <input type="text" name="description" id="tdescription" size="40"/>
                        </p>
                <%
                    }
                %>

            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request)%>

            <p>&nbsp;</p>

            <div id="controles">
                <div class="direita">
                    <input type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" class="button"
                           value="<fmt:message key="jsp.submit.general.cancel-or-save.button"/>" />
                </div>
                <div class="esquerda">
                    <%
                //if upload is set to optional, or user returned to this page after pressing "Add Another File" button
                if (!fileRequired || UIUtil.getSubmitButton(request, "").equals(UploadStep.SUBMIT_MORE_BUTTON)) {
            %>

            <input type="submit" name="<%=UploadStep.SUBMIT_SKIP_BUTTON%>" class="button"
                   onclick="naoValidar();" value="<fmt:message key="jsp.submit.choose-file.skip"/>" />

            <%
                }
            %>
            <%  //if not first step, show "Previous" button
                if (!SubmissionController.isFirstStep(request, subInfo)) {
            %>
            <input type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" class="button"
                   onclick="naoValidar();" value="<fmt:message key="jsp.submit.general.previous"/>" />

            <%
                }
            %>

            <input type="submit" name="<%=UploadStep.SUBMIT_UPLOAD_BUTTON%>" class="button"
                   value="<fmt:message key="jsp.submit.general.next"/>" />


                </div>


        </div>
    </form>

    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/riufpa/livevalidation.js"></script>
    <script type="text/javascript">
        var titulo = new LiveValidation( "tfile", {
            validMessage: "",
            wait: 500,
            onlyOnSubmit: true
        } );
        titulo.add( Validate.Presence, {
            failureMessage: "Por favor, selecione um arquivo"
        } );
        titulo.add( Validate.Format, {
            pattern: /.*/i,
            failureMessage: "Arquivo inválido"
        } );

        /*
        * Chame este método quando um botão submit (voltar) não precisar fazer a validação do formulário.
        */
        function naoValidar(){
            var form = $('enviarArquivo');
            Element.writeAttribute(form, 'onsubmit', 'null');
        }
    </script>

</dspace:layout>
