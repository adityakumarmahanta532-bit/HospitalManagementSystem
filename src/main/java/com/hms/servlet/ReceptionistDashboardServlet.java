package com.hms.servlet;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.DoctorDAO;
import com.hms.dao.PatientDAO;
import com.hms.entity.Appointment;
import com.hms.entity.Doctor;
import com.hms.entity.Patient;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/receptionist/dashboard")
public class ReceptionistDashboardServlet extends HttpServlet {
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAll();
        List<Doctor> doctors = doctorDAO.getAll();
        List<Patient> patients = patientDAO.getAll();

        req.setAttribute("appointments", appointments);
        req.setAttribute("doctors", doctors);
        req.setAttribute("patients", patients);
        req.setAttribute("appointmentCount", appointments.size());

        req.getRequestDispatcher("/WEB-INF/views/receptionist/dashboard.jsp").forward(req, resp);
    }
}
