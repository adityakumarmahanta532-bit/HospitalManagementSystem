package com.hms.servlet;

import com.hms.dao.UserDAO;
import com.hms.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import java.io.IOException;

@WebServlet("/admin/staff/*")
public class StaffServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        
        if (username != null && password != null && !username.isEmpty()) {
            User user = new User();
            user.setUsername(username);
            user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole("RECEPTIONIST");
            userDAO.save(user);
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Receptionist+added+successfully");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getPathInfo();
        if (action != null && action.startsWith("/delete/")) {
            Long id = Long.parseLong(action.substring(8));
            User user = userDAO.getById(id);
            if (user != null && "RECEPTIONIST".equals(user.getRole())) {
                userDAO.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Staff+removed+successfully");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
