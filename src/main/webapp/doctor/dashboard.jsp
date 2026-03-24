<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | HMS</title>
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
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 15px;
            width: 90%;
            max-width: 500px;
            position: relative;
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .close-btn {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        .btn-update {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
        }
        .action-btn {
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            border: none;
            background: #e3f2fd;
            color: #1976d2;
            transition: all 0.3s;
        }
        .action-btn:hover {
            background: #bbdefb;
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
        <div class="nav-brand"><i class="fas fa-hospital-user"></i> HMS Doctor Portal</div>
        <div class="nav-user">
            <span>Welcome, Dr. ${doctor.name}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Logout</a>
        </div>
    </nav>

    <div class="container main-content" style="margin-top: 100px;">
        <c:if test="${not empty param.msg}">
            <div id="toast" class="toast show">${param.msg}</div>
        </c:if>

        <div class="dashboard-header">
            <div class="header-left">
                <h1>My Appointments</h1>
                <p>Manage your schedule and update patient records</p>
            </div>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>Patient Name</th>
                        <th>Status</th>
                        <th>Notes</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="apt" items="${appointments}">
                        <tr>
                            <td>
                                <fmt:parseDate value="${apt.appointmentDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate pattern="dd MMM yyyy, hh:mm a" value="${parsedDate}" />
                            </td>
                            <td>${apt.patient.name}</td>
                            <td><span class="status-badge status-${apt.status}">${apt.status}</span></td>
                            <td>${empty apt.medicalNotes ? '<span style="color:#aaa;">No notes</span>' : '📝 Notes added'}</td>
                            <td>
                                <button class="action-btn" onclick="openNotesModal(${apt.id}, '${apt.status}', this.getAttribute('data-notes'))" data-notes="<c:out value='${apt.medicalNotes}'/>">
                                    <i class="fas fa-edit"></i> Update
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty appointments}">
                        <tr>
                            <td colspan="5" style="text-align:center; padding: 30px; color:#777;">You have no appointments scheduled.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Notes Modal -->
    <div id="notesModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeNotesModal()">&times;</span>
            <h2>Update Appointment</h2>
            <form action="${pageContext.request.contextPath}/doctor/dashboard" method="post">
                <input type="hidden" name="action" value="updateNotes">
                <input type="hidden" id="modalAptId" name="id">
                
                <div class="form-group" style="margin-top: 20px;">
                    <label>Status</label>
                    <select id="modalStatus" name="status" class="form-control">
                        <option value="SCHEDULED">SCHEDULED</option>
                        <option value="COMPLETED">COMPLETED</option>
                        <option value="CANCELLED">CANCELLED</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Medical Notes / Prescriptions</label>
                    <textarea id="modalNotes" name="medicalNotes" class="form-control" placeholder="Add diagnosis, prescriptions, or notes related to this appointment..."></textarea>
                </div>
                
                <button type="submit" class="btn-update">Save Updates</button>
            </form>
        </div>
    </div>

    <script>
        function openNotesModal(id, status, notes) {
            document.getElementById('modalAptId').value = id;
            document.getElementById('modalStatus').value = status;
            document.getElementById('modalNotes').value = notes === 'null' ? '' : notes;
            document.getElementById('notesModal').style.display = 'flex';
        }

        function closeNotesModal() {
            document.getElementById('notesModal').style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('notesModal')) {
                closeNotesModal();
            }
        }
        
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
