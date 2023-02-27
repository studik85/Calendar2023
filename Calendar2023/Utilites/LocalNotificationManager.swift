//
//  LocalNotificationManager.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 27.02.2023.
//

import Foundation
import NotificationCenter


@MainActor
class LocalNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var isGranted = false
    @Published var pendingRequest: [UNNotificationRequest] = []
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    //Delegate Function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequests()
        return [.sound, .banner]
    }
    
    //Request
    func requestAuthoriztion() async throws {
        
        try await  notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    //Get Request Status
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    //Open Settings
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task { await UIApplication.shared.open(url) }
                
            }
        }
    }
    
    //Add Request
    func schedule(localNotification: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotification.title
        content.body = localNotification.body
        content.sound = .default
        if localNotification.scheduleType == .time {
            guard let timeInterval = localNotification.timeInterval else {return}
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = localNotification.dateComponents else {return}
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: localNotification.repeats)
            let request = UNNotificationRequest(identifier: localNotification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        
        await getPendingRequests()
    }
    
    
    //Get Pending Requests
    func getPendingRequests() async {
        pendingRequest = await notificationCenter.pendingNotificationRequests()
    }
    
    //Delete Request
    func removeRequest(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequest.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequest.remove(at: index)
        }
    }
    
    //Delete All Requests
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequest.removeAll()
    }
}

