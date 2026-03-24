package com.hms.servlet;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.DoctorDAO;
import com.hms.entity.Appointment;
import com.hms.entity.Doctor;
import com.hms.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/doctor/dashboard")
public class DoctorDashboardServlet extends HttpServlet {
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && "DOCTOR".equals(user.getRole())) {
                Doctor doctor = doctorDAO.getByEmail(user.getUsername());
                if (doctor != null) {
                    List<Appointment> appointments = appointmentDAO.getByDoctorId(doctor.getId());
                    req.setAttribute("doctor", doctor);
                    req.setAttribute("appointments", appointments);
                    req.getRequestDispatcher("/doctor/dashboard.jsp").forward(req, resp);
                    return;
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/doctor/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("updateNotes".equals(action)) {
            Long aptId = Long.parseLong(req.getParameter("id"));
            String status = req.getParameter("status");
            String notes = req.getParameter("medicalNotes");

            Appointment apt = appointmentDAO.getById(aptId);
            if (apt != null) {
                if (status != null && !status.isEmpty()) {
                    apt.setStatus(status);
                }
                apt.setMedicalNotes(notes);
                appointmentDAO.update(apt);
                resp.sendRedirect(req.getContextPath() + "/doctor/dashboard?msg=Appointment+updated+successfully");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");
    }
}
