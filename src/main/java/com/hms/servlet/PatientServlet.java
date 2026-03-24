package com.hms.servlet;

import com.hms.dao.PatientDAO;
import com.hms.dao.UserDAO;
import com.hms.entity.Patient;
import com.hms.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/patient/*")
public class PatientServlet extends HttpServlet {
    private final PatientDAO patientDAO = new PatientDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String name = req.getParameter("name");
        String ageStr = req.getParameter("age");
        String gender = req.getParameter("gender");
        String contact = req.getParameter("contact");
        String address = req.getParameter("address");

        if (name != null) {
            Patient patient;
            if (idStr != null && !idStr.isEmpty()) {
                patient = patientDAO.getById(Long.parseLong(idStr));
            } else {
                patient = new Patient();
            }

            patient.setName(name);
            patient.setAge(Integer.parseInt(ageStr));
            patient.setGender(gender);
            patient.setContact(contact);
            patient.setAddress(address);

            if (idStr != null && !idStr.isEmpty()) {
                patientDAO.update(patient);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Patient+updated+successfully");
            } else {
                patientDAO.save(patient);
                User user = new User();
                user.setUsername(contact);
                user.setPassword(org.mindrot.jbcrypt.BCrypt.hashpw("pat123", org.mindrot.jbcrypt.BCrypt.gensalt()));
                user.setRole("PATIENT");
                userDAO.save(user);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Patient+added+successfully");
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
            Patient pat = patientDAO.getById(id);
            if (pat != null) {
                userDAO.deleteByUsername(pat.getContact());
                patientDAO.delete(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=Patient+deleted+successfully");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
