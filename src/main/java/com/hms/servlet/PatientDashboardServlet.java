package com.hms.servlet;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.PatientDAO;
import com.hms.entity.Appointment;
import com.hms.entity.Patient;
import com.hms.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.hms.dao.DoctorDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
    private final PatientDAO patientDAO = new PatientDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    private final DoctorDAO doctorDAO = new com.hms.dao.DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && "PATIENT".equals(user.getRole())) {
                Patient patient = patientDAO.getByContact(user.getUsername());
                if (patient != null) {
                    List<Appointment> appointments = appointmentDAO.getByPatientId(patient.getId());
                    List<com.hms.entity.Doctor> doctors = doctorDAO.getAll();
                    req.setAttribute("patient", patient);
                    req.setAttribute("appointments", appointments);
                    req.setAttribute("doctors", doctors);
                    req.getRequestDispatcher("/patient/dashboard.jsp").forward(req, resp);
                    return;
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/patient/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && "PATIENT".equals(user.getRole())) {
                Patient patient = patientDAO.getByContact(user.getUsername());
                if (patient != null) {
                    try {
                        Long doctorId = Long.parseLong(req.getParameter("doctorId"));
                        java.time.LocalDateTime date = java.time.LocalDateTime.parse(req.getParameter("date"));
                        com.hms.entity.Doctor doctor = doctorDAO.getById(doctorId);
                        
                        Appointment app = new Appointment();
                        app.setPatient(patient);
                        app.setDoctor(doctor);
                        app.setAppointmentDate(date);
                        app.setStatus("SCHEDULED");
                        
                        appointmentDAO.save(app);
                        com.hms.util.NotificationService.sendBookingNotification(app);
                        
                        resp.sendRedirect(req.getContextPath() + "/patient/dashboard?msg=Appointment+requested+successfully");
                        return;
                    } catch (Exception e) {
                        resp.sendRedirect(req.getContextPath() + "/patient/dashboard?msg=Error+booking+appointment");
                        return;
                    }
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/patient/login");
    }
}
