<%-- 
    Document   : add-metadado
    Created on : 02/12/2014, 09:46:30
    Author     : Jefferson
--%>

<%@page import="org.dspace.storage.rdbms.TableRowIterator"%>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@page import="edu.harvard.hul.ois.mets.Show"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.logging.Level"%>
<%@page import="javax.servlet.ServletException"%>
<%@page import="javax.servlet.http.HttpServlet"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.dspace.app.webui.util.JSPManager"%>
<%@page import="org.dspace.authorize.AuthorizeException"%>
<%@page import="org.dspace.core.ConfigurationManager"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.core.LogManager"%>
<%@page import="org.dspace.eperson.Group"%>
<%@page import="org.dspace.event.Event"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.dspace.content.Community"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.storage.rdbms.DatabaseManager"%>
<%@page import="org.dspace.storage.rdbms.TableRow"%>

<%
/*
  String query = "select distinct item_id from metadatavalue order by item_id";
  String query2 = "";
  Context contexto = new Context();
  TableRowIterator tr3;
  int cont = 0;
  String nome = "dspace";
  String senha = "wb8gv7F3ketvkwqS7CtC";
  //String senha = "dspace";
  String url = "jdbc:postgresql://127.0.0.1:5432/dspace";
  Connection con;
  Statement stat;
  String driver = "org.postgresql.Driver";
  
  if (contexto != null) {
      TableRowIterator tr = DatabaseManager.query(contexto, query);
      
      while (tr.hasNext()) {
            
            cont++;
            TableRow tr2 = tr.next();
            tr2.getTable();
            int i = tr2.getIntColumn("item_id");
            query="select * from metadatavalue where item_id = "+i+" and metadata_field_id = 53";
            tr3 = DatabaseManager.query(contexto, query);
            TableRow tr4 = tr3.next();
             if(tr4 == null ){
                query2 = "insert into metadatavalue (item_id,metadata_field_id,text_value,text_lang,place,authority,confidence) VALUES ("+i+",53,'acesso aberto',NULL,1,NULL,-1)";
                try {
                    try {
                        Class.forName(driver);
                    } catch (ClassNotFoundException ex) {
                        java.util.logging.Logger.getLogger("AdicionarMetadado").log(Level.SEVERE, null, ex);
                    }
            con = DriverManager.getConnection(url,nome,senha);
            stat = con.createStatement();
            
           
            stat.executeUpdate(query2);
            con.close();
            
            
           } catch (SQLException e) {
               System.out.println("ERROOOOOOOO!!!!!");
        }
            }
            
            
           //System.out.println("teste :"+tr4+"Nº - "+cont+" Item id = "+i);
      }
           
     contexto.complete(); 
  }
*/
%>

<dspace:layout>


</dspace:layout>