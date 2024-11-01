//
//  NotificationManager.swift
//  DaysReminder
//
//  Created by zhang on 01/11/2024.
//
//  Request Notification Permission
//  Schedule Notification
//  Cancel
//  Update


import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
    }
    
    //Request authorization
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    // Schedule
    
    func scheduleNotification(for entry: DateEntry) {
        guard entry.notificationEnabled, let notificationTime = entry.notificationTime else {return}
        
        //Create notification content
        
        let content = UNMutableNotificationContent()
        content.title = entry.title
        content.body = entry.isAnniversary ? "Anniversary of \(content.title)" : "Event Reminder"
        content.sound = .default
        
        //Configure Date and time
        var dateConponents = Calendar.current.dateComponents([.year, .month, .day], from: entry.date)
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
        dateConponents.hour = timeComponents.hour
        dateConponents.minute = timeComponents.minute
        
        //Set trigger with dateComponents and repeat if anniversary
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateConponents, repeats: entry.isAnniversary)
        
        //UUID as identifier
        let request = UNNotificationRequest(identifier: entry.id.uuidString, content: content, trigger: trigger)
        
        //Add notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(entry.title) on \(dateConponents)")
            }
        }
    }
    //Cancel
    func cancelNotification(for entry: DateEntry) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [entry.id.uuidString])
    }
    
    //Update
    func updateNotification(for entry: DateEntry) {
        cancelNotification(for: entry)
        if entry.notificationEnabled {
            scheduleNotification(for: entry)
        }
    }
}

