<%--
    Document   : teste
    Created on : 16/04/2013, 10:26:47
    Author     : portal
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout title="Uma página de Testes =P">

    <!--[if IE]><script language="javascript" type="text/javascript" src="path/to/excanvas.js"></script><![endif]-->
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/base64.js"></script>
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/canvas2image.js"></script>
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/canvastext.js"></script>
    <script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/static/js/flotr/flotr-0.2.0-alpha.js"></script>

    <style type="text/css">
        .grafico{
            margin: 0 auto;
        }
    </style>

    <!--
    <div id="geral" class="grafico" style="width:700px;height:400px;"></div>

    <form name="image-download" action="" onsubmit="return false">
        <button name="download" class="button" onclick="f.saveImage(getV('png'))">Download</button>
    </form>
    -->

    <div id="container" class="grafico" style="width:600px;height:300px;"></div>
    <button id="oloko">Request JSON</button>

    <script type="text/javascript">
        var f = null;
        var f2 = null;

        $('oloko').observe('click', function(){
                new Ajax.Request('dadosRelatorio', {
                        method:'get',
                        contentType:'application/json',
                        requestHeaders: {Accept: 'application/json'},
                        onSuccess: function(transport){
                                var json = transport.responseText.evalJSON();
                                if(json.series && json.options){
                                    /**
                                    * The json is valid! Display the canvas container.
                                    */
                                   $('container').setStyle({'display':'block'});
                                    f2 = Flotr.draw($('container'), json.series, json.options);
                                }

                        },
                        onFailure: function(){
                            alert('Ocorreu um erro ao receber os dados.');
                        }
                });
        });

/*
        document.observe('dom:loaded', function(){
            var d1 = [];
            for(var i = 1; i < 13; i++ ){
                    d1.push([i, i*4+3*Math.sin(i*4)]);
            }

            f = Flotr.draw(
                    $('geral'),
                    [
                        {data:d1, label:'Quantidade'}
                    ],
                    {
                        title: 'Quantidade de Comunidades, Subcomunidades e Colecoes',
                        subtitle: 'Periodo: 01/01/2013 - 16/04/2013',
                        xaxis:{
                            ticks: [[1, "Jan"], [2, "Fev"], [3, "Mar"], [4, "Abr"], [5, "Maio"], [6, "Jun"], [7, "Jul"], [8, "Ago"], [9, "Set"], [10, "Out"], [11, "Nov"], [12, "Dez"]],
                            min: 1,	 // => part of the series is not displayed.
                            max: 13,	// => part of the series is not displayed.
                            labelsAngle: 45,
                            title: 'Meses'
                        },
                        yaxis:{
                            title: 'Quantidade'
                        },
                        grid:{
                            verticalLines: false,
                            backgroundColor: 'white'
                        },
                        bars:{
                            show:true,
                            barWidth:1
                        },
                        HtmlText: false
                    }
            );
        });*/
    </script>


</dspace:layout>