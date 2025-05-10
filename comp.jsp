<%@ page import="java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*" %>
<%
    // Get form data from the request
    int uid = Integer.parseInt(request.getParameter("uid"));
    String officer = request.getParameter("officer");  // Officer field
    String objective = request.getParameter("objective");
    String complaintMessage = request.getParameter("complaintDetails");

    // Database connection details
    String dbURL = "jdbc:mysql://localhost:3306/okji"; // Replace with your database details
    String dbUser = "root"; // Replace with your DB username
    String dbPass = "saurabh"; // Replace with your DB password

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // SQL Insert query with officer selection
        String sql = "INSERT INTO complaints (Uid, Officer, Message, Objective, Status, Date) VALUES (?, ?, ?, ?, 'No Action', NOW())";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, uid);  // User ID
        pstmt.setString(2, officer);  // Officer selection
        pstmt.setString(3, complaintMessage);  // Complaint message
        pstmt.setString(4, objective);  // Objective

        // Execute the update
        int result = pstmt.executeUpdate();
        if (result > 0) {
            out.println("<h3>Complaint submitted successfully and forwarded to " + officer + ".</h3>");
        } else {
            out.println("<h3>There was an issue submitting your complaint.</h3>");
        }
    } catch (Exception e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
