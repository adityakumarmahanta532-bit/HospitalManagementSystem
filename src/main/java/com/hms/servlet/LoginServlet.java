package com.hms.servlet;

import com.hms.dao.UserDAO;
import com.hms.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDAO.getByUsername(username);

        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            String role = user.getRole();
            if ("ADMIN".equals(role) || "RECEPTIONIST".equals(role)) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("role", role);

                if ("ADMIN".equals(role)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
                }
            } else if ("DOCTOR".equals(role)) {
                req.setAttribute("error", "Please use the Doctor Portal to login");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            } else if ("PATIENT".equals(role)) {
                req.setAttribute("error", "Please use the Patient Portal to login");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("error", "Invalid staff credentials");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
