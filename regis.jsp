<%@ page import="java.sql.*,java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%
String email = request.getParameter("email");
String name = request.getParameter("name");
String contact = request.getParameter("Contact");
String pass = request.getParameter("password");
String cpass = request.getParameter("Cpassword");

String url = "jdbc:mysql://localhost:3306/itm2";
String username = "root";
String password = "saurabh";
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
//String query = "SELECT * FROM emp";
String query1 = "INSERT INTO reg_db (`name`, `email`, `contact`, `PASS_HASH`) VALUES (?, ?, ?, ?)";

String emailcheck="SELECT email FROM reg_db WHERE email = ?";

if (!pass.equals(cpass)) {
    response.sendRedirect("regis.html?error=password_mismatch");
    return;
}

try {
    //pass=pass+"AdminOFTheOcta";
    MessageDigest m = MessageDigest.getInstance("SHA-256");
    m.update(pass.getBytes());
    byte[] hashpass = m.digest();
    StringBuilder sb = new StringBuilder();
    for (byte b : hashpass) {
        sb.append(String.format("%02x", b));
    }
    String hashedPassword = sb.toString();

    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, username, password);

    // email checkup 
    ps=conn.prepareStatement(emailcheck);
    ps.setString(1, email);
    rs=ps.executeQuery();

    if( rs.next()){
        response.sendRedirect("regis.html?error=email_used");
        return ;
      }


    // Insert user details
    ps = conn.prepareStatement(query1);
    ps.setString(1, name);
    ps.setString(2, email);
    ps.setString(3, contact);
    ps.setString(4, hashedPassword);
    ps.executeUpdate();
   
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

<%
response.sendRedirect("login.html");

%>
