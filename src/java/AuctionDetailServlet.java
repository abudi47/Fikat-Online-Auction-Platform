import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/auctionDetailServlet")
public class AuctionDetailServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String auctionId = request.getParameter("id");

    if (auctionId == null || auctionId.isEmpty()) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Auction ID is required.");
        return;
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Register JDBC driver

        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {
            Map<String, Object> auction = fetchAuctionDetails(conn, auctionId);

            if (auction == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Auction not found.");
                return;
            }

            request.setAttribute("auction", auction);
            request.getRequestDispatcher("auction_detail.jsp").forward(request, response);
        }
    } catch (ClassNotFoundException e) {
        response.setContentType("text/plain");
        e.printStackTrace(response.getWriter());
    } catch (SQLException e) {
        response.setContentType("text/plain");
        e.printStackTrace(response.getWriter());
    } catch (Exception e) {
        response.setContentType("text/plain");
        e.printStackTrace(response.getWriter());
    }
}

    private Map<String, Object> fetchAuctionDetails(Connection conn, String auctionId) throws SQLException {
        String query = "SELECT  auction_id AS auctionID, item_name AS itemName, item_img AS itemImg, description, starting_price AS startingPrice,  status AS status ," +
                       "current_bid AS currentBid, start_time AS startTime, end_time AS endTime FROM auction WHERE auction_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, auctionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> auction = new HashMap<>();
                    auction.put("status", rs.getString("status"));
                    auction.put("auctionID", rs.getInt("auctionID"));
                    auction.put("itemName", rs.getString("itemName"));
                    auction.put("itemImg", rs.getString("itemImg"));
                    auction.put("description", rs.getString("description"));
                    auction.put("startingPrice", rs.getDouble("startingPrice"));
                    auction.put("currentBid", rs.getDouble("currentBid"));
                    auction.put("startTime", rs.getTimestamp("startTime"));
                    auction.put("endTime", rs.getTimestamp("endTime"));
                    return auction;
                }
            }
        }
        return null;
    }
}
