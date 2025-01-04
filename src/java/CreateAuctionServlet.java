import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/CreateAuctionServlet"})
public class CreateAuctionServlet extends HttpServlet {

    // Database connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data from the request
        String itemName = request.getParameter("item_name");
        String description = request.getParameter("description");
        double startingPrice = Double.parseDouble(request.getParameter("starting_price"));
        double currentBid = Double.parseDouble(request.getParameter("current_bid"));
        String itemImg = request.getParameter("item_img");
        String startTime = request.getParameter("start_time");
        String endTime = request.getParameter("end_time");
        String status = request.getParameter("status");
        String itemType = request.getParameter("item_type");

        // Get the creator's userID from the session
        Object userIDObj = request.getSession().getAttribute("userID");

        // Safely handle the userID
        String userID = null;
        if (userIDObj != null) {
            if (userIDObj instanceof Integer) {
                // Convert Integer to String if necessary
                userID = String.valueOf(userIDObj);
            } else if (userIDObj instanceof String) {
                userID = (String) userIDObj;
            }
        }

        // Check if user is logged in (userID should not be null)
        if (userID == null) {
            response.sendRedirect("login.jsp"); // Redirect to login page if user is not logged in
            return;
        }

        // Database connection and insertion logic
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Register the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // SQL query to insert the auction data into the auction table
            String sql = "INSERT INTO auction (item_name, description, starting_price, current_bid, item_img, start_time, end_time, status, creator_id,item_type) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
            stmt = conn.prepareStatement(sql);

            // Set the parameters for the query
            stmt.setString(1, itemName);
            stmt.setString(2, description);
            stmt.setDouble(3, startingPrice);
            stmt.setDouble(4, currentBid);
            stmt.setString(5, itemImg);
            stmt.setString(6, startTime);
            stmt.setString(7, endTime);
            stmt.setString(8, status);
            stmt.setString(9, userID); // Set the creator's ID (userID)
            stmt.setString(10, itemType);

            // Execute the query
            int rowsAffected = stmt.executeUpdate();

            // If auction creation is successful, redirect to the success page
            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp"); // Redirect to a success page
            } else {
                request.setAttribute("errorMessage", "Auction creation failed, please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/create_auction.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException e) {
            // Handle database errors
            request.setAttribute("errorMessage", "Error occurred: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/create_auction.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Close database resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
