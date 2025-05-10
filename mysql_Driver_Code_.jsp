<%@ page import="java.sql.*" %>
<%
out.println("hello");

String url = "jdbc:mysql://localhost:3306/itm2";
String username = "root";
String password = "saurabh";

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
String query = "SELECT * FROM emp";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    out.println("Driver loaded successfully<br>");
    
    conn = DriverManager.getConnection(url, username, password);
    ps = conn.prepareStatement(query);

    rs = ps.executeQuery();

    while (rs.next()) {
        String eid = rs.getString("eid");
        String ename = rs.getString("ename");
        out.println("ID: " + eid + ", Name: " + ename + "<br>");
    }
} catch (ClassNotFoundException e) {
    e.printStackTrace();
    out.println("Error: MySQL JDBC Driver not found");
} catch (SQLException e) {
    e.printStackTrace();
    out.println("Error: " + e.getMessage());
} finally {
    try {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
