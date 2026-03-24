<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Receptionist Dashboard - HMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .dashboard-container { overflow-y: auto; padding: 20px; }
        .section { margin-bottom: 40px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn-add { background: var(--accent); padding: 8px 16px; font-size: 0.9rem; margin: 0; }
        .status-badge { padding: 4px 8px; border-radius: 8px; font-size: 0.75rem; font-weight: 600; }
        .status-scheduled { background: rgba(16, 185, 129, 0.2); color: #10b981; }
        .status-cancelled { background: rgba(239, 68, 68, 0.2); color: #fca5a5; }
    </style>
</head>
<body style="display: block; overflow: auto;">
    <div id="toast-container"></div>
    <div class="background-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <div class="dashboard-container container" style="max-width: 1000px; margin: 50px auto;">
        <div class="nav">
            <h2>Receptionist Dashboard</h2>
            <div>
                <span>Welcome, ${user.username}</span> | 
                <a href="<%=request.getContextPath()%>/receptionist/billing" style="color:var(--accent); text-decoration:none; margin:0 10px;">Billing</a> | 
                <a href="<%=request.getContextPath()%>/logout" class="logout-link">Logout</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card float-animation">
                <h3>Total Appointments</h3>
                <p style="font-size: 2rem; font-weight: 800; color: var(--accent);">${appointmentCount}</p>
            </div>
        </div>

        <!-- Appointment Form -->
        <div class="section" style="background: rgba(255, 255, 255, 0.05); padding: 20px; border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.1);">
            <h3 style="margin-bottom: 20px;">Book New Appointment</h3>
            <form action="<%=request.getContextPath()%>/receptionist/appointment/book" method="post">
                <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                    <div class="form-group" style="flex: 1; min-width: 200px;">
                        <label>Select Patient</label>
                        <select name="patientId" style="width: 100%; padding: 12px; border-radius: 12px; background: rgba(255, 255, 255, 0.05); color: white; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <c:forEach items="${patients}" var="p">
                                <option value="${p.id}">${p.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group" style="flex: 1; min-width: 200px;">
                        <label>Select Doctor</label>
                        <select name="doctorId" style="width: 100%; padding: 12px; border-radius: 12px; background: rgba(255, 255, 255, 0.05); color: white; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <c:forEach items="${doctors}" var="d">
                                <option value="${d.id}">${d.name} (${d.specialization})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group" style="flex: 1; min-width: 200px;">
                        <label>Date & Time</label>
                        <input type="datetime-local" name="date" required style="padding: 10px;">
                    </div>
                    <div style="flex: 0; min-width: 150px; align-self: flex-end; margin-bottom: 20px;">
                        <button type="submit" style="margin: 0;">Book Now</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Appointments Table -->
        <div class="section">
            <div class="section-header">
                <h3>Scheduled Appointments</h3>
                <input type="text" id="appointmentSearch" placeholder="Search appointments..." onkeyup="filterTable('appointmentTable', 'appointmentSearch')" style="width: 250px; padding: 10px;">
            </div>
            <table id="appointmentTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Patient</th>
                        <th>Doctor</th>
                        <th>Date & Time</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${appointments}" var="app">
                        <tr>
                            <td>${app.id}</td>
                            <td>${app.patient.name}</td>
                            <td>${app.doctor.name}</td>
                            <td>${app.appointmentDate}</td>
                            <td>
                                <span class="badge" style="background: ${app.status == 'SCHEDULED' ? 'var(--accent)' : (app.status == 'COMPLETED' ? 'var(--secondary)' : '#ef4444')}">
                                    ${app.status}
                                </span>
                            </td>
                            <td>
                                <div style="display: flex; gap: 5px;">
                                    <c:if test="${app.status == 'SCHEDULED'}">
                                        <a href="<%=request.getContextPath()%>/receptionist/appointment/complete/${app.id}" class="btn-action" style="background: var(--secondary); text-decoration: none; padding: 5px 10px; border-radius: 5px; color: white; font-size: 0.8rem;">Complete</a>
                                        <a href="<%=request.getContextPath()%>/receptionist/appointment/cancel/${app.id}" class="btn-action" style="background: #ef4444; text-decoration: none; padding: 5px 10px; border-radius: 5px; color: white; font-size: 0.8rem;" onclick="return confirm('Cancel this appointment?')">Cancel</a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}">
                        <tr><td colspan="6" style="text-align: center;">No appointments scheduled.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    <script>
        function filterTable(tableId, inputId) {
            const input = document.getElementById(inputId);
            const filter = input.value.toUpperCase();
            const table = document.getElementById(tableId);
            const tr = table.getElementsByTagName("tr");

            for (let i = 1; i < tr.length; i++) {
                let show = false;
                const td = tr[i].getElementsByTagName("td");
                for (let j = 0; j < td.length - 1; j++) {
                    if (td[j] && td[j].innerHTML.toUpperCase().indexOf(filter) > -1) {
                        show = true;
                        break;
                    }
                }
                tr[i].style.display = show ? "" : "none";
            }
        }

        function showToast(message, type = 'success') {
            const container = document.getElementById('toast-container');
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            toast.innerHTML = `<span>${message}</span>`;
            container.appendChild(toast);
            setTimeout(() => {
                toast.style.opacity = '0';
                toast.style.transform = 'translateX(100%)';
                toast.style.transition = 'all 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        <% if (request.getParameter("msg") != null) { %>
            showToast('<%= request.getParameter("msg") %>');
        <% } %>
    </script>
</body>
</html>
