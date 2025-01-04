

import java.io.IOException;
import java.sql.*;
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

@WebServlet(urlPatterns = {"/balanceServlet"})
public class BalanceServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String successMessage = (String) request.getAttribute("successMessage");

        List<Map<String, Object>> transactions = new ArrayList<>();
        double balanceAmount = 0;

        // Get the user ID from the session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userID");

        if (userId == null) {
            response.sendRedirect("/index.jsp");
            return;
        }

        // Database connection and query execution
        Connection conn = null;
        PreparedStatement stmtBalance = null, stmtTransactions = null;
        ResultSet rsBalance = null, rsTransactions = null;

        try {
            // Register the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // SQL query to fetch balance info based on user ID
            String sqlBalance = "SELECT balance_amount FROM balance WHERE user_id = ?";
            stmtBalance = conn.prepareStatement(sqlBalance);
            stmtBalance.setInt(1, userId);
            rsBalance = stmtBalance.executeQuery();

            if (rsBalance.next()) {
                balanceAmount = rsBalance.getDouble("balance_amount");
            }

            // SQL query to fetch all transactions for the user's balance
            String sqlTransactions = "SELECT t.transaction_id, t.type, t.amount, t.transaction_status, t.created_at "
                    + "FROM transaction t "
                    + "JOIN balance b ON t.balance_id = b.balance_id "
                    + "WHERE b.user_id = ?";
            stmtTransactions = conn.prepareStatement(sqlTransactions);
            stmtTransactions.setInt(1, userId);
            rsTransactions = stmtTransactions.executeQuery();

            // Process the result set for transactions
            while (rsTransactions.next()) {
                Map<String, Object> transaction = new HashMap<>();
                transaction.put("transactionId", rsTransactions.getInt("transaction_id"));
                transaction.put("type", rsTransactions.getString("type"));
                transaction.put("amount", rsTransactions.getDouble("amount"));
                transaction.put("transactionStatus", rsTransactions.getString("transaction_status"));
                transaction.put("createdAt", rsTransactions.getTimestamp("created_at"));

                transactions.add(transaction);
            }

            // Set attributes for balance and transactions
            request.setAttribute("balanceAmount", balanceAmount);
            request.setAttribute("transactions", transactions);
            request.setAttribute("successMessage", successMessage);
            // Forward to JSP
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/balance.jsp");
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
                if (rsTransactions != null) rsTransactions.close();
                if (rsBalance != null) rsBalance.close();
                if (stmtTransactions != null) stmtTransactions.close();
                if (stmtBalance != null) stmtBalance.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
