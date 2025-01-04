import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/depositServlet"})
public class DepositServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve session and validate
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userID");
        String depositAmountStr = request.getParameter("depositAmount");
        String paymentMethod = request.getParameter("paymentMethod");
        String receiptUrl = request.getParameter("receiptUrl");

        // Validate inputs
        if (userId == null || depositAmountStr == null || depositAmountStr.isEmpty()
                || paymentMethod == null || paymentMethod.isEmpty()
                || receiptUrl == null || receiptUrl.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required. Please fill in the deposit amount, payment method, and receipt URL.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
            return;
        }

        double depositAmount;
        try {
            depositAmount = Double.parseDouble(depositAmountStr);
            if (depositAmount <= 0) {
                throw new NumberFormatException("Deposit amount must be positive.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid deposit amount. Please enter a valid positive number.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Database operations
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            // Load JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // Step 1: Find balance_id for the user_id
            stmt = conn.prepareStatement("SELECT balance_id FROM balance WHERE user_id = ?");
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            Integer balanceId = null;
            if (rs.next()) {
                balanceId = rs.getInt("balance_id");
            }

            if (balanceId == null) {
                request.setAttribute("errorMessage", "No balance record found for the user. Please contact support.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Step 2: Insert deposit into the transaction table using balance_id
            stmt = conn.prepareStatement(
                    "INSERT INTO transaction (balance_id, amount, receipt_url,type, created_at) " +
                            "VALUES (?, ?, ?, ?, NOW())");
            stmt.setInt(1, balanceId);
            stmt.setDouble(2, depositAmount);
            stmt.setString(3, receiptUrl);
            stmt.setString(4, "deposit");

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                // Successful transaction
                request.setAttribute("successMessage", "Deposit recorded successfully!");
                response.sendRedirect("balanceServlet"); // Redirect to transaction history or relevant page
            } else {
                // Failed to insert transaction
                request.setAttribute("errorMessage", "Failed to record the transaction. Please try again.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/error.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your deposit: " + e.getMessage());
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
