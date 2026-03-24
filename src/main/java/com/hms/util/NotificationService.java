package com.hms.util;

import com.hms.entity.Appointment;
import java.time.format.DateTimeFormatter;

public class NotificationService {
    
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    public static void sendBookingNotification(Appointment apt) {
        new Thread(() -> {
            try {
                Thread.sleep(1000); // Simulate network delay
                System.out.println("\n\u001B[32m=========================================\u001B[0m");
                System.out.println("📧 \u001B[34mEMAIL SENT TO:\u001B[0m " + apt.getPatient().getName() + " (" + apt.getPatient().getContact() + ")");
                System.out.println("\u001B[33mSubject:\u001B[0m Appointment Confirmation");
                System.out.println("Dear " + apt.getPatient().getName() + ",");
                System.out.println("Your appointment with Dr. " + apt.getDoctor().getName() + " is confirmed for " + apt.getAppointmentDate().format(formatter) + ".");
                System.out.println("Thank you for choosing HMS.");
                System.out.println("\u001B[32m=========================================\u001B[0m\n");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

    public static void sendCancellationNotification(Appointment apt) {
        new Thread(() -> {
            try {
                Thread.sleep(1000);
                System.out.println("\n\u001B[31m=========================================\u001B[0m");
                System.out.println("📧 \u001B[34mEMAIL SENT TO:\u001B[0m " + apt.getPatient().getName() + " (" + apt.getPatient().getContact() + ")");
                System.out.println("\u001B[33mSubject:\u001B[0m Appointment Cancellation");
                System.out.println("Dear " + apt.getPatient().getName() + ",");
                System.out.println("Your appointment with Dr. " + apt.getDoctor().getName() + " scheduled for " + apt.getAppointmentDate().format(formatter) + " has been cancelled.");
                System.out.println("We apologize for the inconvenience. Please contact the receptionist to reschedule.");
                System.out.println("\u001B[31m=========================================\u001B[0m\n");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }
}
