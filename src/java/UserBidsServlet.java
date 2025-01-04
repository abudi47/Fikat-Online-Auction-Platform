
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

@WebServlet(urlPatterns = {"/userBidsServlet"})
public class UserBidsServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Map<String, Object>> userBids = new ArrayList<>();

        // Retrieve the user ID from session (assumes user is logged in)
        Integer userId = (Integer) request.getSession().getAttribute("userID");

        if (userId == null) {
            request.setAttribute("errorMessage", "User not logged in.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            String sql = """
                SELECT a.auction_id, a.item_name, a.description, a.item_img, 
                       a.starting_price, b.bid_amount, b.created_at
                FROM bid b
                JOIN auction a ON b.auction_id = a.auction_id
                WHERE b.user_id = ?
                ORDER BY b.created_at DESC
            """;

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> bid = new HashMap<>();
                bid.put("auctionId", rs.getInt("auction_id"));
                bid.put("itemName", rs.getString("item_name"));
                bid.put("description", rs.getString("description"));
                bid.put("itemImg", rs.getString("item_img"));
                bid.put("startingPrice", rs.getDouble("starting_price"));
                bid.put("bidAmount", rs.getDouble("bid_amount"));
                bid.put("createdAt", rs.getTimestamp("created_at"));
                userBids.add(bid);
            }

            request.setAttribute("userBids", userBids);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/bid.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error fetching user bids: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
        } finally {
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
