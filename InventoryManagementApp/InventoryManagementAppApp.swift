//
//  InventoryManagementAppApp.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import SwiftUI
import UserNotifications

@main
struct InventoryManagementAppApp: App {
    

    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


extension UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for notifications!")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
}

//*** Implement App delegate ***//
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)          {
      print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print(error.localizedDescription)
    }
}
