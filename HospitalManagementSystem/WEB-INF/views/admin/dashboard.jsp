<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - HMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .dashboard-container { overflow-y: auto; padding: 20px; }
        .section { margin-bottom: 40px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn-add { background: var(--accent); padding: 8px 16px; font-size: 0.9rem; margin: 0; min-width: auto; }
        .action-btn { background: none; border: 1px solid rgba(255, 255, 255, 0.2); padding: 4px 8px; font-size: 0.8rem; width: auto; margin: 0 4px; }
        .delete-btn { color: #fca5a5; border-color: rgba(239, 68, 68, 0.3); }
        
        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 100; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); }
        .modal-content { background: var(--bg-gradient); padding: 30px; border-radius: 20px; width: 400px; margin: 100px auto; border: 1px solid rgba(255,255,255,0.2); }
        .close { float: right; cursor: pointer; font-size: 1.5rem; }
        
        .charts-container { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 40px; }
        .chart-card { background: rgba(255, 255, 255, 0.05); padding: 20px; border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.1); }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body style="display: block; overflow: auto;">
    <div id="toast-container"></div>
    <div class="background-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>

    <div class="dashboard-container container" style="max-width: 1000px; margin: 50px auto;">
        <div class="nav">
            <h2>Admin Dashboard</h2>
            <div>
                <span>Welcome, ${user.username}</span> | 
                <a href="<%=request.getContextPath()%>/logout" class="logout-link">Logout</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card float-animation">
                <h3>Doctors</h3>
                <p style="font-size: 2rem; font-weight: 800; color: var(--primary);">${doctorCount}</p>
            </div>
            <div class="stat-card float-animation" style="animation-delay: 1s;">
                <h3>Patients</h3>
                <p style="font-size: 2rem; font-weight: 800; color: var(--secondary);">${patientCount}</p>
            </div>
        </div>

        <div class="charts-container">
            <div class="chart-card">
                <h3>Specializations</h3>
                <canvas id="specChart"></canvas>
            </div>
            <div class="chart-card">
                <h3>Patient Demographics</h3>
                <canvas id="ageChart"></canvas>
            </div>
        </div>

        <!-- Doctors Table -->
        <div class="section">
            <div class="section-header">
                <h3>Manage Doctors</h3>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="doctorSearch" placeholder="Search doctors..." onkeyup="filterTable('doctorTable', 'doctorSearch')" style="width: 200px; padding: 8px;">
                    <button class="btn-add" onclick="showModal('doctorModal')">Add New Doctor</button>
                </div>
            </div>
            <table id="doctorTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Specialization</th>
                        <th>Contact</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${doctors}" var="doctor">
                        <tr>
                            <td>${doctor.id}</td>
                            <td>${doctor.name}</td>
                            <td>${doctor.specialization}</td>
                            <td>${doctor.contact}</td>
                            <td>
                                <div style="display: flex; gap: 5px;">
                                    <button class="btn-action" style="background: var(--accent); color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8rem;" 
                                            onclick="editDoctor('${doctor.id}', '${doctor.name}', '${doctor.specialization}', '${doctor.contact}', '${doctor.email}')">Edit</button>
                                    <a href="<%=request.getContextPath()%>/admin/doctor/delete/${doctor.id}" class="btn-action" style="background: #ef4444; text-decoration: none; padding: 5px 10px; border-radius: 5px; color: white; font-size: 0.8rem;" onclick="return confirm('Are you sure?')">Delete</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty doctors}">
                        <tr><td colspan="5" style="text-align: center;">No doctors found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Patients Table -->
        <div class="section">
            <div class="section-header">
                <h3>Manage Patients</h3>
                <div style="display: flex; gap: 10px;">
                    <input type="text" id="patientSearch" placeholder="Search patients..." onkeyup="filterTable('patientTable', 'patientSearch')" style="width: 200px; padding: 8px;">
                    <button class="btn-add" style="background: var(--secondary);" onclick="showModal('patientModal')">Add New Patient</button>
                </div>
            </div>
            <table id="patientTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Age</th>
                        <th>Gender</th>
                        <th>Contact</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${patients}" var="patient">
                        <tr>
                            <td>${patient.id}</td>
                            <td>${patient.name}</td>
                            <td>${patient.age}</td>
                            <td>${patient.gender}</td>
                            <td>${patient.contact}</td>
                            <td>
                                <div style="display: flex; gap: 5px;">
                                    <button class="btn-action" style="background: var(--accent); color: white; border: none; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 0.8rem;"
                                            onclick="editPatient('${patient.id}', '${patient.name}', '${patient.age}', '${patient.gender}', '${patient.contact}', '${patient.address}')">Edit</button>
                                    <a href="<%=request.getContextPath()%>/admin/patient-history?id=${patient.id}" class="btn-action" style="background: var(--primary); text-decoration: none; padding: 5px 10px; border-radius: 5px; color: white; font-size: 0.8rem;">History</a>
                                    <a href="<%=request.getContextPath()%>/admin/patient/delete/${patient.id}" class="btn-action" style="background: #ef4444; text-decoration: none; padding: 5px 10px; border-radius: 5px; color: white; font-size: 0.8rem;" onclick="return confirm('Are you sure?')">Delete</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty patients}">
                        <tr><td colspan="6" style="text-align: center;">No patients found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Staff Management Table -->
        <div class="section">
            <div class="section-header">
                <h3>Manage Receptionist Staff</h3>
                <button class="btn-add" style="background: var(--accent);" onclick="showModal('staffModal')">Add New Staff member</button>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${receptionists}" var="staff">
                        <tr>
                            <td>${staff.id}</td>
                            <td>${staff.username}</td>
                            <td><span class="badge" style="background: var(--accent);">${staff.role}</span></td>
                            <td>
                                <a href="<%=request.getContextPath()%>/admin/staff/delete/${staff.id}" class="btn-action" style="background: #ef4444; text-decoration: none; padding: 5px 10px; border-radius: 5px; color: white; font-size: 0.8rem;" onclick="return confirm('Remove this staff account?')">Remove</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty receptionists}">
                        <tr><td colspan="4" style="text-align: center;">No staff members found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Staff Modal -->
    <div id="staffModal" class="modal">
        <div class="modal-content container">
            <span class="close" onclick="hideModal('staffModal')">&times;</span>
            <h2 style="margin-bottom: 20px;">Hire Receptionist</h2>
            <form action="<%=request.getContextPath()%>/admin/staff/add" method="post">
                <div class="form-group"><label>Username</label><input type="text" name="username" required></div>
                <div class="form-group"><label>Initial Password</label><input type="password" name="password" required></div>
                <button type="submit" style="background: var(--accent);">Create Account</button>
            </form>
        </div>
    </div>

    <!-- Doctor Modal -->
    <div id="doctorModal" class="modal">
        <div class="modal-content container">
            <span class="close" onclick="hideModal('doctorModal')">&times;</span>
            <h2 style="margin-bottom: 20px;">Add Doctor</h2>
            <form action="<%=request.getContextPath()%>/admin/doctor/add" method="post">
                <input type="hidden" name="id" id="doctor-id">
                <div class="form-group"><label>Name</label><input type="text" name="name" id="doctor-name" required></div>
                <div class="form-group"><label>Specialization</label><input type="text" name="specialization" id="doctor-specialization" required></div>
                <div class="form-group"><label>Contact</label><input type="text" name="contact" id="doctor-contact" required></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" id="doctor-email" required></div>
                <button type="submit" id="doctor-submit">Save Doctor</button>
            </form>
        </div>
    </div>

    <!-- Patient Modal -->
    <div id="patientModal" class="modal">
        <div class="modal-content container">
            <span class="close" onclick="hideModal('patientModal')">&times;</span>
            <h2 style="margin-bottom: 20px;">Add Patient</h2>
            <form action="<%=request.getContextPath()%>/admin/patient/add" method="post">
                <input type="hidden" name="id" id="patient-id">
                <div class="form-group"><label>Name</label><input type="text" name="name" id="patient-name" required></div>
                <div class="form-group"><label>Age</label><input type="number" name="age" id="patient-age" required></div>
                <div class="form-group"><label>Gender</label><input type="text" name="gender" id="patient-gender" required></div>
                <div class="form-group"><label>Contact</label><input type="text" name="contact" id="patient-contact" required></div>
                <div class="form-group"><label>Address</label><input type="text" name="address" id="patient-address" required></div>
                <button type="submit" id="patient-submit" style="background: var(--secondary);">Save Patient</button>
            </form>
        </div>
    </div>

    <script>
        function showModal(id) { document.getElementById(id).style.display = 'block'; }
        function hideModal(id) { document.getElementById(id).style.display = 'none'; }
        window.onclick = function(event) {
            if (event.target.className === 'modal') { event.target.style.display = 'none'; }
        }

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

        // Charts Initialization
        const specCtx = document.getElementById('specChart').getContext('2d');
        new Chart(specCtx, {
            type: 'doughnut',
            data: {
                labels: [<% Map<String, Long> specData = (Map)request.getAttribute("specData"); 
                            if(specData != null) { 
                                for(String s : specData.keySet()) { out.print("'" + s + "',"); }
                            } %>],
                datasets: [{
                    data: [<% if(specData != null) { 
                                for(Long count : specData.values()) { out.print(count + ","); }
                            } %>],
                    backgroundColor: ['#6366f1', '#ec4899', '#10b981', '#f59e0b', '#ef4444'],
                    borderWidth: 0
                }]
            },
            options: { plugins: { legend: { labels: { color: 'white' } } } }
        });

        const ageCtx = document.getElementById('ageChart').getContext('2d');
        new Chart(ageCtx, {
            type: 'bar',
            data: {
                labels: ['0-18', '19-45', '46+'],
                datasets: [{
                    label: 'Count',
                    data: [${ageGroups['0-18']}, ${ageGroups['19-45']}, ${ageGroups['46+']}],
                    backgroundColor: 'rgba(236, 72, 153, 0.5)',
                    borderColor: '#ec4899',
                    borderWidth: 2,
                    borderRadius: 10
                }]
            },
            options: { 
                scales: { 
                    y: { ticks: { color: 'white' }, grid: { color: 'rgba(255,255,255,0.1)' } },
                    x: { ticks: { color: 'white' }, grid: { display: false } }
                },
                plugins: { legend: { display: false } }
            }
        });

        function editDoctor(id, name, spec, contact, email) {
            document.getElementById('doctor-id').value = id;
            document.getElementById('doctor-name').value = name;
            document.getElementById('doctor-specialization').value = spec;
            document.getElementById('doctor-contact').value = contact;
            document.getElementById('doctor-email').value = email;
            document.getElementById('doctor-submit').innerText = 'Update Doctor';
            showModal('doctorModal');
        }

        function editPatient(id, name, age, gender, contact, address) {
            document.getElementById('patient-id').value = id;
            document.getElementById('patient-name').value = name;
            document.getElementById('patient-age').value = age;
            document.getElementById('patient-gender').value = gender;
            document.getElementById('patient-contact').value = contact;
            document.getElementById('patient-address').value = address;
            document.getElementById('patient-submit').innerText = 'Update Patient';
            showModal('patientModal');
        }
    </script>
</body>
</html>
