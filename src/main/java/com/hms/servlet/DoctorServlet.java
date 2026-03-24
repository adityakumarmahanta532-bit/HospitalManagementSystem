package com.hms.servlet;

import com.hms.dao.DoctorDAO;
import com.hms.dao.UserDAO;
import com.hms.entity.Doctor;
import com.hms.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/doctor/*")
public class DoctorServlet extends HttpServlet {
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String specialization = req.getParameter("specialization");
        String contact = req.getParameter("contact");
        String email = req.getParameter("email");

        if (name != null) {
            Doctor doctor;
            if (idStr != null && !idStr.isEmpty()) {
                doctor = doctorDAO.getById(Long.parseLong(idStr));
            } else {
                doctor = new Doctor();
            }
            
            doctor.setName(name);
            doctor.setSpecialization(specialization);
            doctor.setContact(contact);
            doctor.setEmail(email);
            
            if (idStr != null && !idStr.isEmpty()) {
                doctorDAO.update(doctor);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Doctor+updated+successfully");
            } else {
                doctorDAO.save(doctor);
                User user = new User();
                user.setUsername(email);
                user.setPassword(org.mindrot.jbcrypt.BCrypt.hashpw("doc123", org.mindrot.jbcrypt.BCrypt.gensalt()));
                user.setRole("DOCTOR");
                userDAO.save(user);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Doctor+added+successfully");
            }
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getPathInfo();
        if (action != null && action.startsWith("/delete/")) {
            Long id = Long.parseLong(action.substring(8));
            Doctor doc = doctorDAO.getById(id);
            if (doc != null) {
                userDAO.deleteByUsername(doc.getEmail());
                doctorDAO.delete(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Doctor+deleted+successfully");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
