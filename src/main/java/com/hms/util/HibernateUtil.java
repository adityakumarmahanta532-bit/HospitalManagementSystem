package com.hms.util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import com.hms.entity.*;

public class HibernateUtil {
    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            return new Configuration().configure()
                    .addAnnotatedClass(User.class)
                    .addAnnotatedClass(Doctor.class)
                    .addAnnotatedClass(Patient.class)
                    .addAnnotatedClass(Appointment.class)
                    .addAnnotatedClass(Bill.class)
                    .buildSessionFactory();
        } catch (Throwable ex) {
            System.err.println("Initial SessionFactory creation failed." + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }
}
