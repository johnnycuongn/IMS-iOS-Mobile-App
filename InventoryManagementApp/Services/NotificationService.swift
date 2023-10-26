//
//  NotificationService.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import UserNotifications



class NotificationService: NSObject {
    static let shared = NotificationService()
    
    override init() {
       super.init()
       UNUserNotificationCenter.current().delegate = self
    }
    
    func sendNotification(for item: Item) {
        let content = UNMutableNotificationContent()
        print("Sending notification \(item.name)")
        content.title = "Low Inventory Alert"
        content.body = "Inventory for \(item.name ?? "") is lower than 5!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func checkInventoryAndNotify(item: Item) {
        if item.inventory < 5 {
            print("\(item.name) is less than 5. Send notification.")
            sendNotification(for: item)
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleDailyNotification(notificationID: String, title: String, body: String ) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 9 // 9 AM
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        center.add(request)
    }
    
    func checkAndRequestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                // Permission has not been requested yet, go ahead and request it
                self.requestNotificationPermission()
            case .authorized, .provisional:
                // Permission has already been granted
                print("Notification permission already granted.")
            case .denied:
                // Permission has been denied
                print("Notification permission denied.")
            case .ephemeral:
                print("Notification allowed for schedule")
            @unknown default:
                // Handle other cases
                print("Unknown notification permission status.")
            }
        }
    }

    
}

extension NotificationService: UNUserNotificationCenterDelegate  {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}
