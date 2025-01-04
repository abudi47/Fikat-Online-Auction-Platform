
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
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/creatorAuctionsServlet"})
public class CreatorAuctionsServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> auctions = new ArrayList<>();

        // Retrieve the userID from the session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userID");

        // Redirect to login if no user ID is found in session
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

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

            // SQL query to fetch active auctions created by the current user
            String sql = "SELECT * FROM auction WHERE creator_id = ? AND status = 'active'";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);  // Set the userId dynamically in the query

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
            RequestDispatcher dispatcher = request.getRequestDispatcher("/creatorAuctions.jsp");
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
