package com.hms.dao;

import com.hms.entity.Appointment;
import com.hms.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;

public class AppointmentDAO extends BaseDAO<Appointment> {
    public AppointmentDAO() {
        super(Appointment.class);
    }

    public List<Appointment> getByPatientId(Long patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Appointment WHERE patient.id = :pid ORDER BY appointmentDate DESC", Appointment.class)
                    .setParameter("pid", patientId)
                    .list();
        }
    }
    public List<Appointment> getByDoctorId(Long doctorId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Appointment WHERE doctor.id = :did ORDER BY appointmentDate ASC", Appointment.class)
                    .setParameter("did", doctorId)
                    .list();
        }
    }
}
