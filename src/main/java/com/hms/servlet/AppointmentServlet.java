package com.hms.servlet;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.DoctorDAO;
import com.hms.dao.PatientDAO;
import com.hms.entity.Appointment;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/receptionist/appointment/*")
public class AppointmentServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getPathInfo();
        if ("/book".equals(action)) {
            Appointment app = new Appointment();
            app.setPatient(patientDAO.getById(Long.parseLong(req.getParameter("patientId"))));
            app.setDoctor(doctorDAO.getById(Long.parseLong(req.getParameter("doctorId"))));
            app.setAppointmentDate(LocalDateTime.parse(req.getParameter("date")));
            app.setStatus("SCHEDULED");
            appointmentDAO.save(app);
            com.hms.util.NotificationService.sendBookingNotification(app);
            resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard?msg=Appointment+booked+successfully");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getPathInfo();
        if (action != null && action.startsWith("/cancel/")) {
            Long id = Long.parseLong(action.substring(8));
            Appointment app = appointmentDAO.getById(id);
            if (app != null) {
                app.setStatus("CANCELLED");
                appointmentDAO.update(app);
                com.hms.util.NotificationService.sendCancellationNotification(app);
            }
            resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard?msg=Appointment+cancelled+successfully");
            return;
        } else if (action != null && action.startsWith("/complete/")) {
            Long id = Long.parseLong(action.substring(10));
            Appointment app = appointmentDAO.getById(id);
            if (app != null) {
                app.setStatus("COMPLETED");
                appointmentDAO.update(app);
                resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard?msg=Appointment+marked+as+completed");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/receptionist/dashboard");
    }
}
