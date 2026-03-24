# Hospital Management System (HMS)

A robust, role-based Hospital Management System built with Java, JSP, Hibernate, and MySQL. Features a modern, animated UI with glassmorphism.

## 🚀 Getting Started

### Prerequisites
- JDK 17 or higher (Supports up to JDK 25)
- Maven 3.8+
- MySQL Server

### Database Setup
1. Start your MySQL server.
2. The application will automatically create the `hms_db` database and required tables on first run via `createDatabaseIfNotExist=true` and `hbm2ddl.auto=update`.
3. Default credentials (Admin/Receptionist) will be seeded automatically.

### Running the Application
1. Clone the project and navigate to the root directory.
2. Build the project:
   ```bash
   mvn clean install
   ```
3. Run the project locally using the embedded Tomcat runner:
   ```bash
   mvn tomcat7:run-war
   ```
4. Alternatively, deploy the generated `target/HospitalManagementSystem.war` to your favorite servlet container (e.g., Apache Tomcat 10+).

## 👥 Default Credentials

| Role | Username | Password |
| :--- | :--- | :--- |
| **Admin** | `admin` | `admin123` |
| **Receptionist** | `receptionist` | `rec123` |

## 🛠️ Tech Stack
- **Backend**: Jakarta Servlet 6.0, Hibernate 6.4, MySQL
- **Frontend**: JSP, JSTL, Vanilla CSS (Modern UI)
- **Utilities**: Lombok 1.18.44, BCrypt

## 📂 Features
- **Admin**: Staff management, Patient registration, Dashboard statistics.
- **Receptionist**: Appointment booking and status tracking.
- **Security**: Role-based access control filters and session management.

---
*Developed by Antigravity*
