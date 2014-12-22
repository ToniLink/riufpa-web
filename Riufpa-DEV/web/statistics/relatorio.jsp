
<%-- 
    Document   : relatorio
    Created on : 17/11/2014, 12:07:43
    Author     : Jefferson
--%>


<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.DocumentException"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>




<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%

Document document = new Document();
          try {
             
              PdfWriter.getInstance(document, new FileOutputStream("/home/jefferson/PDF_DevMedia.pdf"));
              document.open();
             
              // adicionando um parágrafo no documento
              document.add(new Paragraph("Gerando PDF - Java"));
}
          catch(DocumentException de) {
              System.err.println(de.getMessage());
          }
          catch(IOException ioe) {
              System.err.println(ioe.getMessage());
          }
          document.close();
      

%>

<dspace:layout  titlekey="jsp.statistics.no-report.title">





</dspace:layout>
