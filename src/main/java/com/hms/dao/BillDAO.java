package com.hms.dao;

import com.hms.entity.Bill;
import com.hms.util.HibernateUtil;
import org.hibernate.Session;
import java.util.List;

public class BillDAO extends BaseDAO<Bill> {
    public BillDAO() {
        super(Bill.class);
    }

    public List<Bill> getByPatientId(Long patientId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Bill WHERE patient.id = :pid ORDER BY issueDate DESC", Bill.class)
                    .setParameter("pid", patientId)
                    .list();
        }
    }

    public List<Bill> getAllBills() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM Bill ORDER BY issueDate DESC", Bill.class).list();
        }
    }
}
