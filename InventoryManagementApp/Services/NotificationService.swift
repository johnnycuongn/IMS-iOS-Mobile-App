//
//  NotificationService.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import UserNotifications

func checkInventoryAndNotify(item: Item) {
    if item.inventory < 5 {
        sendNotification(for: item)
    }
}

func sendNotification(for item: Item) {
    let content = UNMutableNotificationContent()
    content.title = "Low Inventory Alert"
    content.body = "Inventory for \(item.name ?? "") is lower than 5!"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}
