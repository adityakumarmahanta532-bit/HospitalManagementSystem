package com.hms.servlet;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.PatientDAO;
import com.hms.entity.Appointment;
import com.hms.entity.Patient;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/patient-history")
public class PatientHistoryServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String patientIdStr = req.getParameter("id");
        if (patientIdStr != null) {
            Long patientId = Long.parseLong(patientIdStr);
            Patient patient = patientDAO.getById(patientId);
            List<Appointment> appointments = appointmentDAO.getByPatientId(patientId);
            
            req.setAttribute("patient", patient);
            req.setAttribute("appointments", appointments);
            req.getRequestDispatcher("/WEB-INF/views/admin/patient_history.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }
}
