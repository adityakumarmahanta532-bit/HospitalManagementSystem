<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Portal - HMS</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        :root {
            --primary: #43e97b;
            --secondary: #38f9d7;
            --accent: #0081a7;
        }
    </style>
</head>
<body class="doctor-login">
    <div class="background-blobs">
        <div class="blob blob-1" style="background: var(--primary);"></div>
        <div class="blob blob-2" style="background: var(--secondary);"></div>
    </div>
    
    <div class="container float-animation">
        <h1>Doctor Login</h1>
        <p style="margin-bottom: 20px; color: rgba(255,255,255,0.7);">Enter your credentials to access your daily schedule</p>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <form action="<%=request.getContextPath()%>/doctor/login" method="post">
            <div class="form-group">
                <label for="username">Email Address</label>
                <input type="text" id="username" name="username" required placeholder="name@hospital.com">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>
            <button type="submit" style="background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #1a1a2e; font-weight: 700;">Access Dashboard</button>
        </form>
        <div style="margin-top: 20px;">
            <a href="<%=request.getContextPath()%>/index.jsp" style="color: white; text-decoration: none; font-size: 0.9rem;">← Back to Home</a>
        </div>
    </div>
</body>
</html>
