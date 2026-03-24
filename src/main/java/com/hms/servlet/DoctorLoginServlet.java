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

@WebServlet("/doctor/login")
public class DoctorLoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/doctor_login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDAO.getByUsername(username);

        if (user != null && "DOCTOR".equals(user.getRole()) && BCrypt.checkpw(password, user.getPassword())) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", "DOCTOR");
            resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
        } else {
            req.setAttribute("error", "Invalid doctor credentials");
            req.getRequestDispatcher("/doctor_login.jsp").forward(req, resp);
        }
    }
}
