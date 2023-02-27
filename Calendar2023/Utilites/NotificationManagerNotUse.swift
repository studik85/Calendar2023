//
//  NotificationManager.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 24.02.2023.
//

import Foundation
import UserNotifications

final class NotificationManager: ObservableObject {
    
    @Published var notifications: [UNNotificationRequest] = []
    @Published private(set) var authorizationStatus: UNAuthorizationStatus?
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized : .denied
            }
        }
    }
    
    
    func reloadLocalNotifications() {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func createLocalNotification(year: Int, month: Int, day: Int, hour: Int, minute: Int, title: String, subtitle: String, body: String) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let notificationsContent = UNMutableNotificationContent()
        notificationsContent.title = title
        notificationsContent.subtitle = subtitle
        notificationsContent.body = body
        notificationsContent.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationsContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func deleteLocalNotifications(identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
