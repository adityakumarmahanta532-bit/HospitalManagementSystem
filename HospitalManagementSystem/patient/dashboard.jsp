<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard | HMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .header-left h1 {
            font-size: 28px;
            color: #1a1a2e;
            margin-bottom: 5px;
        }
        .header-left p {
            color: #666;
        }
        .card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            text-align: left;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        th {
            font-weight: 600;
            color: #444;
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #fbfbfe;
        }
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-SCHEDULED { background-color: #e3f2fd; color: #1976d2; }
        .status-COMPLETED { background-color: #e8f5e9; color: #388e3c; }
        .status-CANCELLED { background-color: #ffebee; color: #d32f2f; }
        
        .patient-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .info-col {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid #43e97b;
        }
        .info-col h3 {
            font-size: 14px;
            color: #888;
            margin-bottom: 5px;
        }
        .info-col p {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .notes-text {
            white-space: pre-wrap;
            color: #555;
            background: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="background-animation">
        <div class="bg-shape circle1"></div>
        <div class="bg-shape circle2"></div>
        <div class="bg-shape float1"></div>
    </div>

    <nav class="navbar">
        <div class="nav-brand"><i class="fas fa-hospital-user"></i> HMS Patient Portal</div>
        <div class="nav-user">
            <span>Welcome, ${patient.name}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container main-content" style="margin-top: 100px;">
        <c:if test="${not empty param.msg}">
            <div id="toast" class="toast show">${param.msg}</div>
        </c:if>

        <div class="dashboard-header">
            <div class="header-left">
                <h1>My Medical Records</h1>
                <p>Welcome back! Here is a summary of your health profile and appointments.</p>
            </div>
            <button class="btn btn-primary" onclick="document.getElementById('bookingForm').style.display='block'; window.scrollTo(0, 0);"><i class="fas fa-calendar-plus"></i> Request Appointment</button>
        </div>

        <div id="bookingForm" class="card" style="display:none; background: #e3f2fd; border: 1px solid #90caf9;">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h2 style="color: #1565c0; margin:0;"><i class="fas fa-calendar-alt"></i> Book New Appointment</h2>
                <button onclick="document.getElementById('bookingForm').style.display='none'" style="background:none; border:none; font-size:24px; cursor:pointer; color:#1565c0;">&times;</button>
            </div>
            <hr style="border: 0; border-top: 1px solid #bbdefb; margin: 15px 0;">
            <form action="${pageContext.request.contextPath}/patient/dashboard" method="post">
                <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 250px;">
                        <label style="display:block; margin-bottom:5px; font-weight:600; color:#333;">Select Doctor</label>
                        <select name="doctorId" required style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; font-family: inherit;">
                            <c:forEach var="doc" items="${doctors}">
                                <option value="${doc.id}">Dr. ${doc.name} (${doc.specialization})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label style="display:block; margin-bottom:5px; font-weight:600; color:#333;">Preferred Date & Time</label>
                        <input type="datetime-local" name="date" required style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; font-family: inherit;">
                    </div>
                    <div style="flex: 0; align-self: flex-end;">
                        <button type="submit" class="btn btn-primary" style="padding: 12px 25px; height: 44px;">Book Now</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="card">
            <h2>Personal Information</h2>
            <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 20px;">
            <div class="patient-info">
                <div class="info-col">
                    <h3>Full Name</h3>
                    <p>${patient.name}</p>
                </div>
                <div class="info-col">
                    <h3>Age / Gender</h3>
                    <p>${patient.age} / ${patient.gender}</p>
                </div>
                <div class="info-col">
                    <h3>Contact Number</h3>
                    <p>${patient.contact}</p>
                </div>
                <div class="info-col">
                    <h3>Address</h3>
                    <p>${patient.address}</p>
                </div>
            </div>
        </div>

        <div class="card">
            <h2>My Appointments & History</h2>
            <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 20px;">
            <table>
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>Doctor</th>
                        <th>Specialization</th>
                        <th>Status</th>
                        <th>Medical Notes / Prescriptions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="apt" items="${appointments}">
                        <tr>
                            <td>
                                <fmt:parseDate value="${apt.appointmentDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate pattern="dd MMM yyyy, hh:mm a" value="${parsedDate}" />
                            </td>
                            <td>Dr. ${apt.doctor.name}</td>
                            <td>${apt.doctor.specialization}</td>
                            <td><span class="status-badge status-${apt.status}">${apt.status}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty apt.medicalNotes}">
                                        <div class="notes-text"><c:out value="${apt.medicalNotes}" /></div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#aaa; font-style:italic;">No notes available.</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="5" style="text-align:center; padding: 30px; color:#777;">You have no appointment history.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Hide toast message after 3 seconds
        setTimeout(function() {
            var toast = document.getElementById("toast");
            if (toast) {
                toast.classList.remove("show");
            }
        }, 3000);
    </script>
</body>
</html>
