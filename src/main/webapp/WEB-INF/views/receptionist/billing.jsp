<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Billing & Invoicing - HMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .dashboard-container { overflow-y: auto; padding: 20px; }
        .section { margin-bottom: 40px; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .btn-add { background: var(--accent); padding: 8px 16px; font-size: 0.9rem; margin: 0; border: none; border-radius: 8px; color: white; cursor: pointer; }
        .status-badge { padding: 4px 8px; border-radius: 8px; font-size: 0.75rem; font-weight: 600; }
        .status-PENDING { background: #ffebee; color: #d32f2f; }
        .status-PAID { background: #e8f5e9; color: #388e3c; }
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
            <h2>Billing & Invoicing</h2>
            <div>
                <a href="<%=request.getContextPath()%>/receptionist/dashboard" style="color:var(--accent); text-decoration:none; margin-right:15px;">&larr; Back to Dashboard</a>
                <span>Welcome, ${user.username}</span> | 
                <a href="<%=request.getContextPath()%>/logout" class="logout-link">Logout</a>
            </div>
        </div>

        <!-- Generate Bill Form -->
        <div class="section" style="background: rgba(255, 255, 255, 0.05); padding: 20px; border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.1);">
            <h3 style="margin-bottom: 20px;">Generate New Bill</h3>
            <form action="<%=request.getContextPath()%>/receptionist/billing" method="post">
                <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                    <div class="form-group" style="flex: 2; min-width: 200px;">
                        <label>Select Completed Appointment</label>
                        <select name="appointmentId" style="width: 100%; padding: 12px; border-radius: 12px; background: rgba(255, 255, 255, 0.05); color: white; border: 1px solid rgba(255, 255, 255, 0.1);">
                            <c:forEach items="${appointments}" var="a">
                                <option value="${a.id}">Apt #${a.id} - ${a.patient.name} (Dr. ${a.doctor.name})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group" style="flex: 1; min-width: 150px;">
                        <label>Amount (in USD)</label>
                        <input type="number" step="0.01" name="amount" required style="padding: 10px; width: 100%;" placeholder="e.g. 150.00">
                    </div>
                    <div style="flex: 0; min-width: 150px; align-self: flex-end; margin-bottom: 20px;">
                        <button type="submit" class="btn-add">Generate Bill</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Bills Table -->
        <div class="section">
            <div class="section-header">
                <h3>All Invoices</h3>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Invoice ID</th>
                        <th>Issue Date</th>
                        <th>Patient</th>
                        <th>Appointment ID</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${bills}" var="b">
                        <tr>
                            <td>INV-${b.id}</td>
                            <td>
                                <fmt:parseDate value="${b.issueDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate pattern="dd MMM yyyy" value="${parsedDate}" />
                            </td>
                            <td>${b.patient.name}</td>
                            <td>#${b.appointment.id}</td>
                            <td style="font-weight:bold;">$${b.amount}</td>
                            <td>
                                <span class="badge status-${b.status}">${b.status}</span>
                            </td>
                            <td>
                                <c:if test="${b.status == 'PENDING'}">
                                    <a href="<%=request.getContextPath()%>/receptionist/billing/markPaid/${b.id}" class="btn-action" style="background: #10b981; color: white; padding: 5px 10px; border-radius: 5px; text-decoration: none; font-size:0.8rem;">Mark as Paid</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty bills}">
                        <tr><td colspan="7" style="text-align: center;">No bills generated yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <script>
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
