package com.hms.util;

import com.hms.entity.User;
import com.hms.dao.UserDAO;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import org.mindrot.jbcrypt.BCrypt;

@WebListener
public class DataInitializer implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("Initializing Data...");
            UserDAO userDAO = new UserDAO();
            
            // Check if Admin exists
            if (userDAO.getByUsername("admin") == null) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword(BCrypt.hashpw("admin123", BCrypt.gensalt()));
                admin.setRole("ADMIN");
                userDAO.save(admin);
                System.out.println("Admin user created.");
            }

            // Check if Receptionist exists
            if (userDAO.getByUsername("receptionist") == null) {
                User rec = new User();
                rec.setUsername("receptionist");
                rec.setPassword(BCrypt.hashpw("rec123", BCrypt.gensalt()));
                rec.setRole("RECEPTIONIST");
                userDAO.save(rec);
                System.out.println("Receptionist user created.");
            }
            System.out.println("Data Initialization completed.");
        } catch (Exception e) {
            System.err.println("CRITICAL: Data Initialization failed!");
            e.printStackTrace();
            // Don't rethrow if you want the server to start anyway for debugging
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        HibernateUtil.shutdown();
    }
}
