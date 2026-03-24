package com.hms.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getServletPath();

        // Allow access to login pages and public assets
        boolean isPublicPath = path.equals("/login.jsp") || path.equals("/login") || 
            path.equals("/doctor_login.jsp") || path.equals("/doctor/login") ||
            path.equals("/patient_login.jsp") || path.equals("/patient/login") ||
            path.equals("/index.jsp") || path.equals("/") || path.isEmpty() ||
            path.startsWith("/css/") || path.startsWith("/js/");

        if (isPublicPath) {
            chain.doFilter(request, response);
            return;
        }

        // Redirect to appropriate login if no session
        if (session == null || session.getAttribute("user") == null) {
            if (path.startsWith("/doctor/")) {
                res.sendRedirect(req.getContextPath() + "/doctor/login");
            } else if (path.startsWith("/patient/")) {
                res.sendRedirect(req.getContextPath() + "/patient/login");
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
            }
            return;
        }

        String role = (String) session.getAttribute("role");

        // Role-based access control
        if (path.startsWith("/admin/") && !"ADMIN".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin role required.");
            return;
        }

        if (path.startsWith("/receptionist/") && !"RECEPTIONIST".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Receptionist role required.");
            return;
        }

        if (path.startsWith("/doctor/") && !"DOCTOR".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Doctor role required.");
            return;
        }

        if (path.startsWith("/patient/") && !"PATIENT".equals(role)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Patient role required.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
