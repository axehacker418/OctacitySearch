<%
String sid = (String) session.getAttribute("sid");
if (sid != null) {
   
    session.invalidate();
    response.sendRedirect("index.html");
    //out.println(sid);

} 
else{
    response.sendRedirect("index.html");
}
%>
