package com.hms.dao;

import com.hms.entity.User;
import com.hms.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import java.util.List;

public class UserDAO extends BaseDAO<User> {
    public UserDAO() {
        super(User.class);
    }

    public User getByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<User> query = session.createQuery("from User where username = :username", User.class);
            query.setParameter("username", username);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<User> getByRole(String role) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM User WHERE role = :r", User.class)
                    .setParameter("r", role)
                    .list();
        }
    }
    public void deleteByUsername(String username) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            session.beginTransaction();
            Query<?> query = session.createQuery("DELETE FROM User WHERE username = :username");
            query.setParameter("username", username);
            query.executeUpdate();
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
