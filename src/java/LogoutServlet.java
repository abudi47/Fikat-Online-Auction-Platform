import java.io.IOException; // For handling input/output exceptions

import jakarta.servlet.ServletException; // For handling servlet exceptions
import jakarta.servlet.annotation.WebServlet; // For defining the servlet URL mapping
import jakarta.servlet.http.HttpServlet; // Base class for HTTP servlets
import jakarta.servlet.http.HttpServletRequest; // For accessing HTTP request data
import jakarta.servlet.http.HttpServletResponse; // For sending HTTP responses
import jakarta.servlet.http.HttpSession; 

@WebServlet(urlPatterns = {"/logoutServlet"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Invalidate the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Redirect to login page
        response.sendRedirect("login.jsp");
    }
}
