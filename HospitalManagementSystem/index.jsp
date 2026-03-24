<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hospital Management System - Portal Select</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
    <style>
        .portal-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 50px;
        }
        .portal-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px 20px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            color: white;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .portal-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.3);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        .portal-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .portal-card h2 { margin-bottom: 10px; font-size: 1.5rem; }
        .portal-card p { opacity: 0.7; font-size: 0.9rem; margin: 0; }
        
        .staff-portal { --primary: #0081a7; --secondary: #00afb9; }
        .doctor-portal { --primary: #43e97b; --secondary: #38f9d7; }
        .patient-portal { --primary: #fa709a; --secondary: #fee140; }
    </style>
</head>
<body>
    <div class="background-blobs">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
    </div>
    
    <div class="container" style="max-width: 1000px; padding: 50px 20px;">
        <h1 style="font-size: 3.5rem; margin-bottom: 10px;">Welcome to HMS</h1>
        <p style="font-size: 1.2rem; margin-bottom: 50px; opacity: 0.8;">Select your portal to continue</p>
        
        <div class="portal-grid">
            <a href="<%=request.getContextPath()%>/login.jsp" class="portal-card staff-portal">
                <div class="portal-icon">🏢</div>
                <h2>Staff Portal</h2>
                <p>Admin & Receptionist Access</p>
            </a>
            
            <a href="<%=request.getContextPath()%>/doctor/login" class="portal-card doctor-portal">
                <div class="portal-icon">🩺</div>
                <h2>Doctor Portal</h2>
                <p>Medical Staff Login</p>
            </a>
            
            <a href="<%=request.getContextPath()%>/patient/login" class="portal-card patient-portal">
                <div class="portal-icon">🏥</div>
                <h2>Patient Portal</h2>
                <p>Personal Health Access</p>
            </a>
        </div>
        
        <div style="margin-top: 80px; font-size: 0.8rem; opacity: 0.5;">
            &copy; 2026 Hospital Management System. All rights reserved.
        </div>
    </div>
</body>
</html>
