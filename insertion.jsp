<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
   String ctnm = request.getParameter("ctnm");
   if (ctnm == null) {
      response.sendRedirect("index.html");
   } else {
      // Retrieve parameters from the HTML form
      String city = request.getParameter("city");
      String service = request.getParameter("serviceName");
      String location = request.getParameter("locationName");
      String provider = request.getParameter("providerName");
      String contact = request.getParameter("providerContact");

      // Database connection parameters
      String url = "jdbc:mysql://localhost:3306/itm2";
      String username = "root";
      String password = "saurabh";

      Connection conn = null;
      PreparedStatement pstmt = null;
      PreparedStatement ps = null;
      ResultSet rs = null;

      try {
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(url, username, password);

         // Check if service already exists
         String serviceCheck = "SELECT sid FROM service WHERE sname = ? AND cid = (SELECT cid FROM city WHERE cname = ?)";
         ps = conn.prepareStatement(serviceCheck);
         ps.setString(1, service);
         ps.setString(2, city);
         rs = ps.executeQuery();

         int sid;
         if (!rs.next()) {
            // Insert into services table if service doesn't exist
            String sqlServices = "INSERT INTO service (sname, cid) VALUES (?, (SELECT cid FROM city WHERE cname = ?))";
            pstmt = conn.prepareStatement(sqlServices, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, service);
            pstmt.setString(2, city);
            pstmt.executeUpdate();
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
               sid = generatedKeys.getInt(1);
            } else {
               throw new SQLException("Failed to get service ID.");
            }
            pstmt.close(); // Close previous statement
         } else {
            sid = rs.getInt("sid");
         }
         rs.close(); // Close ResultSet

         // Check if location already exists for the given service and city
         String locationCheck = "SELECT lid FROM location WHERE lname = ? AND sid = ? AND cid = (SELECT cid FROM city WHERE cname = ?)";
         ps = conn.prepareStatement(locationCheck);
         ps.setString(1, location);
         ps.setInt(2, sid);
         ps.setString(3, city);
         rs = ps.executeQuery();

         int lid;
         if (!rs.next()) {
            // Insert into location table if location doesn't exist
            String sqlLocation = "INSERT INTO location (lname, sid, cid) VALUES (?, ?, (SELECT cid FROM city WHERE cname = ?))";
            pstmt = conn.prepareStatement(sqlLocation, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, location);
            pstmt.setInt(2, sid);
            pstmt.setString(3, city);
            pstmt.executeUpdate();
            ResultSet generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
               lid = generatedKeys.getInt(1);
            } else {
               throw new SQLException("Failed to get location ID.");
            }
            pstmt.close(); // Close previous statement
         } else {
            lid = rs.getInt("lid");
         }
         rs.close(); // Close ResultSet

         // Check if provider already exists for the given service, city, and location
         String providerCheck = "SELECT pid FROM provider WHERE pname = ? AND sid = ? AND cid = (SELECT cid FROM city WHERE cname = ?) AND lid = ?";
         ps = conn.prepareStatement(providerCheck);
         ps.setString(1, provider);
         ps.setInt(2, sid);
         ps.setString(3, city);
         ps.setInt(4, lid);
         rs = ps.executeQuery();

         if (rs.next()) {
            response.sendRedirect("insertion.html?error=provider_already_exists");
            return;
         }
         rs.close(); // Close ResultSet

         // Insert into provider table if provider doesn't exist
         String sqlProvider = "INSERT INTO provider (pname, pcontect, sid, cid, lid) VALUES (?, ?, ?, (SELECT cid FROM city WHERE cname = ?), ?)";
         pstmt = conn.prepareStatement(sqlProvider);
         pstmt.setString(1, provider);
         pstmt.setString(2, contact);
         pstmt.setInt(3, sid);
         pstmt.setString(4, city);
         pstmt.setInt(5, lid);
         int rowsProvider = pstmt.executeUpdate();

         // Redirect to admin page if insertion is successful
         if (rowsProvider != 0) {
            response.sendRedirect("Admin.html?ctnm=" + ctnm);
         }

      } catch (ClassNotFoundException | SQLException e) {
         // Output error message
         response.getWriter().write("Error Inserting Data: " + e.getMessage());
         // Optionally, log the exception for debugging purposes
         e.printStackTrace(new java.io.PrintWriter(response.getWriter()));
      } finally {
         // Close resources in finally block
         try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
         } catch (SQLException e) {
            e.printStackTrace();
         }
      }
   }
%>
