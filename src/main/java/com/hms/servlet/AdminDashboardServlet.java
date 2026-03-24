package com.hms.servlet;

import com.hms.dao.DoctorDAO;
import com.hms.dao.PatientDAO;
import com.hms.dao.UserDAO;
import com.hms.entity.Doctor;
import com.hms.entity.Patient;
import com.hms.entity.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.HashMap;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAll();
        List<Patient> patients = patientDAO.getAll();

        req.setAttribute("doctors", doctors);
        req.setAttribute("patients", patients);
        req.setAttribute("doctorCount", doctors.size());
        req.setAttribute("patientCount", patients.size());

        // Spec data for chart
        Map<String, Long> specData = doctors.stream()
            .collect(Collectors.groupingBy(Doctor::getSpecialization, Collectors.counting()));
        req.setAttribute("specData", specData);

        // Age data for chart
        Map<String, Long> ageGroups = new HashMap<>();
        ageGroups.put("0-18", patients.stream().filter(p -> p.getAge() <= 18).count());
        ageGroups.put("19-45", patients.stream().filter(p -> p.getAge() > 18 && p.getAge() <= 45).count());
        ageGroups.put("46+", patients.stream().filter(p -> p.getAge() > 45).count());
        req.setAttribute("ageGroups", ageGroups);

        // Fetch Receptionists
        List<User> receptionists = userDAO.getByRole("RECEPTIONIST");
        req.setAttribute("receptionists", receptionists);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
