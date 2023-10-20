//
//  InventoryManagementAppApp.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import SwiftUI

@main
struct InventoryManagementAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
