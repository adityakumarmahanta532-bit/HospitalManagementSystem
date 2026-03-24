package com.hms.servlet;

import com.hms.dao.AppointmentDAO;
import com.hms.dao.BillDAO;
import com.hms.entity.Appointment;
import com.hms.entity.Bill;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/receptionist/billing/*")
public class BillingServlet extends HttpServlet {
    private final BillDAO billDAO = new BillDAO();
    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getPathInfo();
        
        if (action != null && action.startsWith("/markPaid/")) {
            Long id = Long.parseLong(action.substring(10));
            Bill bill = billDAO.getById(id);
            if (bill != null) {
                bill.setStatus("PAID");
                billDAO.update(bill);
                resp.sendRedirect(req.getContextPath() + "/receptionist/billing?msg=Bill+marked+as+paid");
                return;
            }
        }

        List<Bill> bills = billDAO.getAllBills();
        List<Appointment> appointments = appointmentDAO.getAll();
        
        // Filter appointments to only those that are COMPLETED and don't have a bill yet
        // A simple way is to let the JSP show all COMPLETED appointments in a dropdown, but for simplicity, 
        // we'll pass all appointments and filter in JSP or we can filter here.
        appointments.removeIf(a -> !a.getStatus().equals("COMPLETED"));
        
        req.setAttribute("bills", bills);
        req.setAttribute("appointments", appointments);
        req.getRequestDispatcher("/WEB-INF/views/receptionist/billing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String aptIdStr = req.getParameter("appointmentId");
        String amountStr = req.getParameter("amount");

        if (aptIdStr != null && amountStr != null) {
            try {
                Long aptId = Long.parseLong(aptIdStr);
                Double amount = Double.parseDouble(amountStr);
                
                Appointment apt = appointmentDAO.getById(aptId);
                if (apt != null) {
                    Bill bill = new Bill();
                    bill.setAppointment(apt);
                    bill.setPatient(apt.getPatient());
                    bill.setAmount(amount);
                    bill.setStatus("PENDING");
                    bill.setIssueDate(LocalDateTime.now());
                    
                    billDAO.save(bill);
                    resp.sendRedirect(req.getContextPath() + "/receptionist/billing?msg=Bill+generated+successfully");
                    return;
                }
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/receptionist/billing?msg=Error+generating+bill");
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/receptionist/billing");
    }
}
