<%--
  - own-submissions.jsp
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
  - Show user's previous (accepted) submissions
  -
  - Attributes to pass in:
  -    user     - the e-person who's submissions these are (EPerson)
  -    items    - the submissions themselves (Item[])
  -    handles  - Corresponding Handles (String[])
--%>

<%@page import="java.util.Comparator"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.dspace.search.QueryArgs"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="java.util.Set"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="org.dspace.search.QueryResults"%>
<%@page import="org.dspace.sort.SortOption"%>
<%@page import="org.dspace.content.DCValue"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.JSPManager"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<%@page import="org.dspace.core.LogManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="org.apache.lucene.search.function.DocValues"%>
<%@page import="javax.print.DocFlavor.STRING"%>
<%@page import= "org.dspace.content.ItemIterator"%>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    EPerson eperson = (EPerson) request.getAttribute("user");
    Item[] items = (Item[]) request.getAttribute("items");
    //Array qua vai ser ordenado
    Item[] itemsOrd = items;


    QueryResults qResults = null;

    SortOption sortOption = null;
    QueryArgs qArgs = new QueryArgs();
    String ordem = request.getParameter("order");

    int sortBy2 = 0;

    String tipo = request.getParameter("tipo_doc");
    if (tipo == null) {
        tipo = "todos";
    }

    String submetendoOrdem = request.getParameter("submetendoOrdem");

    if (submetendoOrdem != null) {
        items = (Item[]) session.getAttribute("aux");
        itemsOrd = (Item[]) session.getAttribute("itemsOrd");
        sortBy2 = UIUtil.getIntParameter(request, "sort_by");

    }

    String submetendoFiltro = request.getParameter("submetendoFiltro");

    if (submetendoFiltro != null) {
        items = (Item[]) session.getAttribute("aux");
        itemsOrd = (Item[]) session.getAttribute("itemsOrd");
        sortBy2 = UIUtil.getIntParameter(request, "sort_by");

    }


    //Array para ordenar o resultado filtrado
    //O conteudo de "aux3" é o "Array2"
    Item[] items3 = (Item[]) session.getAttribute("aux3");

    if (items3 != null) {
        if (items3.length == 0) {
            //O conteudo de "aux4" é o "Array3"
            items3 = (Item[]) session.getAttribute("aux4");
        }
    }

    int cont = 0;
    DCValue[] values = new DCValue[5];
    String teste = "";

    int x = 0;
    //Conta quantos Items possuem o tipo de documento passado na variavel "tipo"
    for (int i = 0; i < itemsOrd.length; i++) {
        values = itemsOrd[i].getMetadata("dc", "type", null, Item.ANY);
        for (int j = 0; j < values.length; j++) {
            teste = values[j].value;
        }

        if (teste.equalsIgnoreCase(tipo)) {
            cont++;
        }

    }
    //Array para colocar os resultados filtrados por tipo de documento
    //O tamanho dele foi calculado anteriormente.
    Item[] items2 = new Item[cont];
    int cont2 = 0;
    //Insere os Items no Array que são do tipo passado pela variavel "tipo"
    for (int i = 0; i < itemsOrd.length; i++) {
        values = itemsOrd[i].getMetadata("dc", "type", null, Item.ANY);

        for (int j = 0; j < values.length; j++) {
            teste = values[j].value;
        }

        if (teste.equalsIgnoreCase(tipo)) {
            items2[cont2] = itemsOrd[i];
            cont2++;
        }

    }

    //Para deixar acessível o valor das variaveis na página depois de atualizar...
    session.setAttribute("aux", items);
    session.setAttribute("itemsOrd", itemsOrd);
    session.setAttribute("aux3", items2);
    session.setAttribute("aux4", items3);

    //Parte do código veio do Servlet de Busca simples.
    if (sortBy2 > 0) {
        sortOption = SortOption.getSortOption(sortBy2);
        qArgs.setSortOption(sortOption);
    }

    if (SortOption.ASCENDING.equalsIgnoreCase(ordem)) {
        qArgs.setSortOrder(SortOption.ASCENDING);
    } else {
        qArgs.setSortOrder(SortOption.DESCENDING);
    }

    session.setAttribute("order", qArgs.getSortOrder());
    session.setAttribute("sortedBy", sortOption);

    String order = (String) session.getAttribute("order");
    String ascSelected = (SortOption.ASCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    String descSelected = (SortOption.DESCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    SortOption so = (SortOption) session.getAttribute("sortedBy");
    //SortOption so = new SortOption(0, "teste", "dc.title", "title");
    String sortedBy = (so == null) ? null : so.getName();
    int limitAuthor = (so == null) ? 0 : Integer.parseInt(request.getParameter("etal"));

    // Get the attributes sort_by



    String tipoSort = (so == null) ? null : so.getMetadata();
    boolean sorted = false;
    Item[] temp = new Item[2];


    //Verifica se o botão filtrar foi usado para saber se vai ordenar
    //todo os Itens ou só resultados filtrados.
    String filtro = request.getParameter("fil");
    if (filtro == null) {
        filtro = "false";
    }
    if (tipo.equalsIgnoreCase("todos") != true) {
        filtro = "true";
    }
%>

<dspace:layout locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace">

    <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/riufpa/own-submissions.js"></script>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/own-submissions.css" type="text/css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/mydspace.css" type="text/css" />

    <h1><fmt:message key="jsp.mydspace.own-submissions.title"/></h1>

    <%
        if (items.length == 0) {
    %>
    <p><fmt:message key="jsp.mydspace.own-submissions.text1"/></p>
    <%} else {
    %>
    <p><fmt:message key="jsp.mydspace.own-submissions.text2"/></p>
    <%
        if (items.length == 1) {
    %>
    <p><fmt:message key="jsp.mydspace.own-submissions.text3"/></p>
    <%    } else {
    %>
    <p>
        <fmt:message key="jsp.mydspace.own-submissions.text4">
            <fmt:param><%= items.length%></fmt:param>
        </fmt:message>
    </p>
    <%
        }
    %>

    <div class="ordenacao">

                    <form id="ordenacao" method="post" action="<%= request.getContextPath()%>/mydspace/own-submissions.jsp">
                        <%
                            Set<SortOption> sortOptions = SortOption.getSortOptions();
                            if (sortOptions.size() > 1) {
                        %>
                        <fmt:message key="search.results.sort-by"/>
                        <select name="sort_by" onchange="alterarOrdem();">
                            <option value="0"><fmt:message key="search.sort-by.relevance"/></option>
                            <%
                                for (SortOption sortBy : sortOptions) {
                                    if (sortBy.isVisible()) {
                                        String selected = (sortBy.getName().equals(sortedBy) ? "selected=\"selected\"" : "");
                                        String mKey = "search.sort-by." + sortBy.getName();
                            %>
                            <option value="<%= sortBy.getNumber()%>" <%= selected%>><fmt:message key="<%= mKey%>"/></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <%
                            }
                        %>
                        <fmt:message key="search.results.order"/>
                        <select name="order" onchange="alterarOrdem();">
                            <option value="ASC" <%= ascSelected%>><fmt:message key="search.order.asc" /></option>
                            <option value="DESC" <%= descSelected%>><fmt:message key="search.order.desc" /></option>
                        </select>
                        <fmt:message key="search.results.etal" />
                        <select name="etal" onchange="alterarOrdem();">
                            <%
                                String unlimitedSelect = "";

                            %>
                            <option value="0" <%= unlimitedSelect%>><fmt:message key="browse.full.etal.unlimited"/></option>
                            <%
                                boolean insertedCurrent = false;
                                for (int i = 0; i <= 50; i += 5) {
                                    // for the first one, we want 1 author, not 0
                                    if (i == 0) {
                                        String sel = (i + 1 == limitAuthor ? "selected=\"selected\"" : "");
                            %>
                            <option value="1" <%= sel%>>1</option>
                            <%
                                }

                                // if the current i is greated than that configured by the user,
                                // insert the one specified in the right place in the list
                                if (i > limitAuthor && !insertedCurrent && limitAuthor > 1) {
                            %>
                            <option value="<%= limitAuthor%>" selected="selected"><%= limitAuthor%></option>
                            <%
                                    insertedCurrent = true;
                                }

                                // determine if the current not-special case is selected
                                String selected = (i == limitAuthor ? "selected=\"selected\"" : "");

                                // do this for all other cases than the first and the current
                                if (i != 0 && i != limitAuthor) {
                            %>
                            <option value="<%= i%>" <%= selected%>> <%= i%></option>
                            <%
                                    }

                                }
                            %>
                        </select>

                        <input type="hidden" name="submetendoOrdem" value="true"/>
                        <input type="hidden" name="aux" value="<%= session.getAttribute("items")%>"/>
                        <input type="hidden" name="itemsOrd" value="<%= session.getAttribute("itemsOrd")%>"/>
                        <input type="hidden" name="aux3" value="<%= session.getAttribute("items2")%>"/>
                        <input type="hidden" name="aux4" value="<%= session.getAttribute("items3")%>"/>
                        <input type="hidden" name="aux2" value="<%= session.getAttribute("so")%>"/>
                        <input type="hidden" name="fil" value="<%= filtro%>"/>

                        <noscript>
                            <input type="submit" class="button" name="submit_search" value="<fmt:message key="search.update" />" />
                        </noscript>

                    </form>

                        <br />
                        <hr/>
                        <br />

                    <%
                        //Para deixar selecionado no combobox a ultima opção escolhida na filtragem
                        String selecArt = "";
                        String selecMasThe = "";
                        String selecDocThe = "";
                        String selecRev = "";
                        String selecConfObj = "";

                        if (tipo != null) {
                            selecArt = (tipo.equalsIgnoreCase("article") ? "selected=\"selected\"" : "");
                            selecMasThe = (tipo.equalsIgnoreCase("masterThesis") ? "selected=\"selected\"" : "");
                            selecDocThe = (tipo.equalsIgnoreCase("doctoralThesis") ? "selected=\"selected\"" : "");
                            selecRev = (tipo.equalsIgnoreCase("review") ? "selected=\"selected\"" : "");
                            selecConfObj = (tipo.equalsIgnoreCase("conferenceObject") ? "selected=\"selected\"" : "");

                        }

                    %>
                    <form id="tipo_doc" action="<%= request.getContextPath()%>/mydspace/own-submissions.jsp" method="post">
                        Tipo de documento:
                        <select id="tipo_doc" name="tipo_doc" onchange="alterarTipoDoc();">

                            <option value="Todos"   >Todos</option>
                            <option value="article" <%=selecArt%> >Artigo de periódico</option>
                            <%--<option value="ANY">Monografia (graduação)</option>--%>
                            <option value="masterThesis" <%=selecMasThe%> >Dissertação (mestrado)</option>
                            <option value="doctoralThesis" <%=selecDocThe%> >Tese (doutorado)</option>
                            <%--<option value="ANY">Livro</option>
                                <option value="ANY">Capítulo ou parte de livro</option>--%>
                            <option value="review" <%=selecRev%> >Resenha de livro ou de artigo</option>
                            <option value="conferenceObject" <%=selecConfObj%> >Artigo de evento</option>
                            <%--<option value="ANY">Palestra ou apresentação</option>
                                <option value="ANY">Documento científico ou técnico (workingpaper)</option>
                                <option value="ANY">Plan or blueprint</option>
                                <option value="ANY">Preprint</option>
                                <option value="ANY">Relatório técnico</option>
                                <option value="ANY">Parecer científico ou técnico</option>
                                <option value="ANY">Artigo não científico pulicado em revista ou jornal</option>
                                <option value="ANY">Patente</option>
                                <option value="ANY">Eletronic Thesis or Dissertation</option>
                                <option value="ANY">Outros</option>--%>
                        </select>

                        <input type="hidden" name="submetendoFiltro" value="true"/>
                        <input type="hidden" name="itemsOrd" value="<%= session.getAttribute("itemsOrd")%>"/>
                        <input type="hidden" name="aux" value="<%= session.getAttribute("items")%>"/>

                        <input type="hidden" name="etal" value="0" />
                        <input type="hidden" name="sort_by" value="2"/>

                        <noscript>
                            <input type="submit" class="button" value="Filtro"/>
                        </noscript>
                    </form>
    </div>

    <br/><br/><br/>

    <%
        if (so == null) {
    %>

    <dspace:itemlist items="<%=items%>"/>

    <%
    } else {

        if (submetendoOrdem != null) {

            if (filtro.equalsIgnoreCase("false")) {
                //Ordena a lista de Item de acordo com o tipo de ordenação;
                for (int top = items.length - 1; top > 0 && !sorted; top--) {
                    sorted = true;
                    //Ordem crescente
                    if (order.equalsIgnoreCase("ASC")) {
                        for (int i = 0; i < top; i++) {
                            if (itemsOrd[i].getMetadata(tipoSort)[0].value.compareToIgnoreCase(itemsOrd[i + 1].getMetadata(tipoSort)[0].value) > 0) {
                                sorted = false;
                                temp[0] = itemsOrd[i];
                                itemsOrd[i] = itemsOrd[i + 1];
                                itemsOrd[i + 1] = temp[0];
                            }
                        }

                    } //Ordem decrescente
                    else {
                        for (int i = 0; i < top; i++) {
                            if (itemsOrd[i].getMetadata(tipoSort)[0].value.compareToIgnoreCase(itemsOrd[i + 1].getMetadata(tipoSort)[0].value) < 0) {
                                sorted = false;
                                temp[0] = itemsOrd[i];
                                itemsOrd[i] = itemsOrd[i + 1];
                                itemsOrd[i + 1] = temp[0];
                            }
                        }
                    }
                }

    %>

    <dspace:itemlist sortOption="<%=so%>"  authorLimit="<%=limitAuthor%>" items="<%=itemsOrd%>" emphcolumn="<%=tipoSort%>" />

    <%
    } else {

        for (int top = items3.length - 1; top > 0 && !sorted; top--) {
            sorted = true;
            //Ordem crescente
            if (order.equalsIgnoreCase("ASC")) {
                for (int i = 0; i < top; i++) {
                    if (items3[i].getMetadata(tipoSort)[0].value.compareToIgnoreCase(items3[i + 1].getMetadata(tipoSort)[0].value) > 0) {
                        sorted = false;
                        temp[0] = items3[i];
                        items3[i] = items3[i + 1];
                        items3[i + 1] = temp[0];
                    }
                }

            } //Ordem decrescente
            else {
                for (int i = 0; i < top; i++) {
                    if (items3[i].getMetadata(tipoSort)[0].value.compareToIgnoreCase(items3[i + 1].getMetadata(tipoSort)[0].value) < 0) {
                        sorted = false;
                        temp[0] = items3[i];
                        items3[i] = items3[i + 1];
                        items3[i + 1] = temp[0];
                    }
                }

            }

        }

        values = items3[0].getMetadata("dc", "type", null, Item.ANY);
    %>

    <strong><% out.print(values[0].value);%></strong> submetido(s) por você: <strong><%=items3.length%></strong>
    <dspace:itemlist items="<%=items3%>" authorLimit="<%=limitAuthor%>" />

    <%
            }
        }
        if (submetendoFiltro != null) {
            if (tipo.equalsIgnoreCase("Todos")) {

    %>

    <dspace:itemlist items="<%=items%>" />

    <%
    } else {
    %>

    <strong><% out.print(tipo);%></strong> submetido(s) por você: <strong><%=cont%></strong>
    <dspace:itemlist items="<%=items2%>" />

    <%
                    }
                }
            }
        }
    %>
</dspace:layout>