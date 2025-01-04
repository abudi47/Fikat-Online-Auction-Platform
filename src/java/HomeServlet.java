package com.app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/app/homeServlet"})
public class HomeServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> auctions = new ArrayList<>();

        // Database connection and query execution
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Register the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            System.out.println("Database connection successful.");

            // SQL query to fetch only active auctions
            String sql = "SELECT * FROM auction WHERE status = 'active'";

            stmt = conn.prepareStatement(sql);

            rs = stmt.executeQuery();

            // Process the result set
            while (rs.next()) {
                Map<String, Object> auction = new HashMap<>();
                auction.put("auctionId", rs.getInt("auction_id"));
                auction.put("itemName", rs.getString("item_name"));
                auction.put("description", rs.getString("description"));
                auction.put("startingPrice", rs.getDouble("starting_price"));
                auction.put("currentBid", rs.getDouble("current_bid"));
                auction.put("itemImg", rs.getString("item_img"));
                auction.put("startTime", rs.getTimestamp("start_time"));
                auction.put("endTime", rs.getTimestamp("end_time"));
                auction.put("status", rs.getString("status"));  // Should be 'active'

                auctions.add(auction);
            }

            // Set the auctions attribute and forward to JSP
            request.setAttribute("auctions", auctions);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            // Handle exceptions
            String errorMessage = "Error occurred: " + e.getMessage();
            e.printStackTrace();
            request.setAttribute("errorMessage", errorMessage);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
