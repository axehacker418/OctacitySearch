<%@ page import="java.sql.*, java.util.ArrayList, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
String cityName = request.getParameter("cityName");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String url = "jdbc:mysql://localhost:3306/itm2";
String username = "root";
String password = "saurabh";
String query = "SELECT DISTINCT s.sname FROM service s JOIN city c ON s.cid = c.cid WHERE c.cname = ?";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, username, password);

    ps = conn.prepareStatement(query);
    ps.setString(1, cityName);
    rs = ps.executeQuery();

    JSONArray servicesArray = new JSONArray();

    while (rs.next()) {
        servicesArray.add(rs.getString("sname"));
    }

    JSONObject responseData = new JSONObject();
    responseData.put("services", servicesArray);

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
