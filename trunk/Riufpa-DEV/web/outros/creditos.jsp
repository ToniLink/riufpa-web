<%--
  - home.jsp
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

<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>

<dspace:layout titlekey="jsp.home.title">

    <style type="text/css">
        .creditos{
            text-align: center;
            line-height: 170%;
        }
    </style>

    <table class="areaHome">
        <tr>
            <td bgcolor="#ebf0fd">
                <p style="color: #0332B2; text-align: center; font-size: 16pt; font-weight: bold; font-family: OxygenBold;">
                    <fmt:message key="credits.equip"/>
                </p>
                <div class="creditos">
                <p>
                    <strong><fmt:message key="credits.director"/></strong><br />
                    Maria das Graças da Silva Pena
                </p>
                <p>
                    <strong><fmt:message key="credits.managers"/></strong><br />
                    Albirene de Sousa Aires<br />
                    Irvana dos Santos Coutinho
                </p>
                <p>
                    <strong><fmt:message key="credits.cataloguers"/></strong><br />
                    Ana Rosa dos Santos Rodrigues da Silva<br />
                    Edisângela Paixão Bastos<br />
                    Samira Maria Rossy Prince
                </p>
                <p>
                    <strong><fmt:message key="credits.itteam"/></strong><br />
                    Derick Dias Rosa<br />
                    Jefferson William Furtado Cordeiro<br />
                    Leandro Henrique Santos Corrêa<br />
                    Manoel Afonso Pereira de Lima Filho<br />
                    Nelson Silva da Silva<br />
                    Paulo Robson Campelo Malcher<br />
                    Rafael Mesquita do Mar<br />
                    Vitor Lima Coelho<br />
                    William Christian Silva da Silva<br />
                    <%-- <br /><i><fmt:message key="credits.former"/></i><br /> --%>
                    
                    
                   
                </p>
                </div>
            </td>
        </tr>
    </table>
    <br/>

    <dspace:sidebar>
        <dspace:include page="/layout/parceiros.jsp" />
    </dspace:sidebar>

</dspace:layout>
