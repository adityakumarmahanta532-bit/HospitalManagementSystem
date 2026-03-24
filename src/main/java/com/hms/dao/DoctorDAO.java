package com.hms.dao;

import com.hms.entity.Doctor;

public class DoctorDAO extends BaseDAO<Doctor> {
    public DoctorDAO() {
        super(Doctor.class);
    }
    public Doctor getByEmail(String email) {
        try (org.hibernate.Session session = com.hms.util.HibernateUtil.getSessionFactory().openSession()) {
            org.hibernate.query.Query<Doctor> query = session.createQuery("from Doctor where email = :email", Doctor.class);
            query.setParameter("email", email);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
