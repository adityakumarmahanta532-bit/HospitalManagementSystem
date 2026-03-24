package com.hms.dao;

import com.hms.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class BaseDAO<T> {
    private final Class<T> type;

    public BaseDAO(Class<T> type) {
        this.type = type;
    }

    public void save(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        try {
            transaction = session.beginTransaction();
            session.save(entity); // Use save() for Hibernate 5.6
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            System.err.println("Error during save operation: " + e.getMessage());
            e.printStackTrace();
            throw e; // Rethrow to let DataInitializer catch it
        } finally {
            session.close();
        }
    }

    public void update(T entity) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        try {
            transaction = session.beginTransaction();
            session.update(entity); // Use update() for Hibernate 5.6
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            session.close();
        }
    }

    public void delete(Long id) {
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction transaction = null;
        try {
            transaction = session.beginTransaction();
            T entity = session.get(type, id);
            if (entity != null) {
                session.delete(entity); // Use delete() for Hibernate 5.6
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            session.close();
        }
    }

    public T getById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(type, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<T> getAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("from " + type.getName(), type).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
