<%@ page import="java.sql.*, java.security.MessageDigest, java.security.NoSuchAlgorithmException" %>
<%

String email = request.getParameter("username");
String pass = request.getParameter("PASSWORD");

String url = "jdbc:mysql://localhost:3306/itm2";
String dbUsername = "root";
String dbPassword = "saurabh";
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String query1 = "SELECT PASS_HASH FROM reg_db WHERE email=?";
try {
    pass=pass+"AdminOFTheOcta";
    MessageDigest m = MessageDigest.getInstance("SHA-256");
    m.update(pass.getBytes());
    byte[] hashpass = m.digest();
    StringBuilder sb = new StringBuilder();
    for (byte b : hashpass) {
        sb.append(String.format("%02x", b));
    }
    String hashedPassword = sb.toString();

    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, dbUsername, dbPassword);

    ps = conn.prepareStatement(query1);
    ps.setString(1, email);
    rs = ps.executeQuery();

    if (rs.next()) {
        String dbHashedPassword = rs.getString("PASS_HASH");

        if (hashedPassword.equals(dbHashedPassword)) {
            // Passwords match, set session attribute
            session.setAttribute("sid", dbHashedPassword); // Store the PASS_HASH in session as sid
            
            // Retrieve the sid from the session and print it
            String sid = (String) session.getAttribute("sid");
            sid +="123@gmx#009";
            // Redirect to the index page after successful login
        response.sendRedirect("Admin.html?ctnm="+sid);
    //request.getRequestDispatcher("index1.html").forward(request, response);
        } else {
            // Passwords do not match
            response.sendRedirect("AdminLogin?error=Invalid_password"); // Redirect to login page with error message
        }
    } else {
        // No user found with the given email
        response.sendRedirect("AdminLogin.html?error=User_not_found"); // Redirect to login page with error message
    }
} catch (ClassNotFoundException e) {
    out.println("Error: MySQL JDBC Driver not found");
    e.printStackTrace();
} catch (SQLException e) {
    out.println("Error: " + e.getMessage());
    e.printStackTrace();
} catch (NoSuchAlgorithmException e) {
    out.println("Error: SHA-256 algorithm not found");
    e.printStackTrace();
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
