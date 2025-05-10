<%@ page import="java.sql.*,java.security.MessageDigest,java.security.NoSuchAlgorithmException" %>
<%
    // Get form parameters
    String ctnm = request.getParameter("ctnm");
    String email = request.getParameter("email");
    String name = request.getParameter("name");
    String contact = request.getParameter("Contact");
    String pass = request.getParameter("password");
    String cpass = request.getParameter("Cpassword");

    // Redirect to the main page if 'ctnm' is not null
    if (ctnm != null) {
        response.sendRedirect("index.html");
        return;
    }

    // Database connection parameters
    final String DB_URL = "jdbc:mysql://localhost:3306/itm2";
    final String DB_USER = "root";
    final String DB_PASSWORD = "saurabh";

    // SQL queries
    final String QUERY_SELECT_EMAIL = "SELECT email FROM reg_db WHERE email = ?";
    final String QUERY_INSERT_USER = "INSERT INTO reg_db (`name`, `email`, `contact`, `PASS_HASH`) VALUES (?, ?, ?, ?)";

    // Validate passwords match
    if (!pass.equals(cpass)) {
        response.sendRedirect("regis.html?error=password_mismatch");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        
        pass=pass+"AdminOFTheOcta";
        // Hash the password using SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(pass.getBytes());
        byte[] hashedBytes = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        String hashedPassword = sb.toString();

        // Load MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Connect to the database
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        // Check if email already exists
        ps = conn.prepareStatement(QUERY_SELECT_EMAIL);
        ps.setString(1, email);
        rs = ps.executeQuery();
        if (rs.next()) {
            response.sendRedirect("regis.html?error=email_used");
            return;
        }

        // Insert user details
        ps = conn.prepareStatement(QUERY_INSERT_USER);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, contact);
        ps.setString(4, hashedPassword);
        int result = ps.executeUpdate();
        if (result > 0) {
            response.sendRedirect("Admin.html?ctnm=" + ctnm);
        } else {
            out.println("Error: Failed to register user.");
        }

    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: MySQL JDBC Driver not found");
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } catch (NoSuchAlgorithmException e) {
        e.printStackTrace();
        out.println("Error: Unable to hash password");
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
