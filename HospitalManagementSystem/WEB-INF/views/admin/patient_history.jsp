<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient History - ${patient.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="display: block; overflow: auto;">
    <div class="background-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
    </div>

    <div class="container" style="width: 90%; max-width: 1000px; margin-top: 50px;">
        <div class="header">
            <div>
                <h1>Medical History: <span style="color: var(--secondary);">${patient.name}</span></h1>
                <p>Age: ${patient.age} | Gender: ${patient.gender} | Contact: ${patient.contact}</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-add" style="background: rgba(255,255,255,0.1); text-decoration: none;">Back to Dashboard</a>
        </div>

        <div class="section">
            <div class="section-header">
                <h3>Appointment Records</h3>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>Doctor</th>
                        <th>Specialization</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="app" items="${appointments}">
                        <tr>
                            <td>${app.appointmentDate}</td>
                            <td>${app.doctor.name}</td>
                            <td><span class="badge" style="background: var(--primary);">${app.doctor.specialization}</span></td>
                            <td>
                                <span class="badge" style="background: ${app.status == 'SCHEDULED' ? 'var(--accent)' : 'rgba(239, 68, 68, 0.2)'}">
                                    ${app.status}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="4" style="text-align: center; color: rgba(255,255,255,0.5);">No appointment records found for this patient.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
