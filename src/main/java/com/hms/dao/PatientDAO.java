package com.hms.dao;

import com.hms.entity.Patient;

public class PatientDAO extends BaseDAO<Patient> {
    public PatientDAO() {
        super(Patient.class);
    }
    public Patient getByContact(String contact) {
        try (org.hibernate.Session session = com.hms.util.HibernateUtil.getSessionFactory().openSession()) {
            org.hibernate.query.Query<Patient> query = session.createQuery("from Patient where contact = :contact", Patient.class);
            query.setParameter("contact", contact);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
