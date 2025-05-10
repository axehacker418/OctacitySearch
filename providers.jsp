<%@ page import="java.sql.*, java.util.ArrayList, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
String cityName = request.getParameter("cityName");
String serviceName = request.getParameter("serviceName");
String locationName = request.getParameter("locationName");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String url = "jdbc:mysql://localhost:3306/itm2";
String username = "root";
String password = "saurabh";
String query = "SELECT p.pname, p.paddress, p.pcontect FROM provider p JOIN service s ON p.sid = s.sid JOIN city c ON p.cid = c.cid JOIN location l ON p.lid=l.lid WHERE c.cname = ? AND s.sname = ? AND l.lname = ?";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, username, password);

    ps = conn.prepareStatement(query);
    ps.setString(1, cityName);
    ps.setString(2, serviceName);
    ps.setString(3, locationName);
    rs = ps.executeQuery();

    JSONArray providersArray = new JSONArray();

    while (rs.next()) {
        JSONObject provider = new JSONObject();
        provider.put("pname", rs.getString("pname")); // Ensure column name matches your database schema
        provider.put("paddress", rs.getString("paddress")); // Ensure column name matches your database schema
        provider.put("pcontect", rs.getString("pcontect")); // Ensure column name matches your database schema
        providersArray.add(provider);
    }

    JSONObject responseData = new JSONObject();
    responseData.put("providers", providersArray);

    // Set response content type
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    // Write JSON response
    out.print(responseData.toJSONString());

} catch (ClassNotFoundException e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.println("{\"error\": \"MySQL JDBC Driver not found\"}");
} catch (SQLException e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.println("{\"error\": \"" + e.getMessage() + "\"}");
} catch (Exception e) {
    e.printStackTrace();
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.println("{\"error\": \"An unexpected error occurred\"}");
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
