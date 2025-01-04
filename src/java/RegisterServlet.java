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

/**
 *
 * @author Nahom
 */
@WebServlet(urlPatterns = {"/registerServlet"})
public class RegisterServlet extends HttpServlet {

    // Database connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/auctionDataBASE?serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "Nahom@321";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().print("Welcome to the Registration Page");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form data from the request
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Database connection and insertion logic
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Register the MySQL JDBC driver (necessary for MySQL 8.x and some older configurations)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to the database
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);

            // SQL query to check if the username or email already exists
            String checkQuery = "SELECT * FROM users WHERE username = ? OR email = ?";
            stmt = conn.prepareStatement(checkQuery);
            stmt.setString(1, username);
            stmt.setString(2, email);

            // Execute the query to check for existing records
            rs = stmt.executeQuery();

            // If a record is found, it means the username or email already exists
            if (rs.next()) {
                request.setAttribute("errorMessage", "You already have an account with this username or email.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
                dispatcher.forward(request, response);
            } else {
                // SQL query to insert the user data into the users table
                String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(sql);

                // Set the parameters
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, password); // Note: You should hash the password before storing it

                // Execute the query
                int rowsAffected = stmt.executeUpdate();

                // If registration is successful, redirect to home.jsp
                if (rowsAffected > 0) {
                    response.sendRedirect("login.jsp"); // Redirects to home.jsp
                } else {
                    request.setAttribute("errorMessage", "Registration failed, please try again.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
                    dispatcher.forward(request, response);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            // Pass the error message to the registration page
            request.setAttribute("errorMessage", "Error occurred: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Close database resources
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
