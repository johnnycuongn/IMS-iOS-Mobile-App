//
//  ContentView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import SwiftUI
import CoreData
import UserNotifications

enum CustomTab {
    case home
    case settings
    case profile
}

struct ContentView: View {
    
    @State private var selectedTab: CustomTab = .home
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    // Content
                    ZStack(alignment: .leading) {
                        if selectedTab == .home {
                            HomePageView()
                        } else if selectedTab == .settings {
                            SettingsView()
                        } else if selectedTab == .profile {
                            Text("Profile Content")
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - 50)
                    
                    // Custom Tab Bar
                    HStack {
                        Button(action: { selectedTab = .home }) {
                            VStack {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                        }
                        .foregroundColor(selectedTab == .home ? .blue : .gray)
                        
                        Spacer()
                        
                        Button(action: { selectedTab = .settings }) {
                            VStack {
                                Image(systemName: "gearshape.fill")
                                Text("Settings")
                            }
                        }
                        .foregroundColor(selectedTab == .settings ? .blue : .gray)
                        
                        Spacer()
                        
                        Button(action: { selectedTab = .profile }) {
                            VStack {
                                Image(systemName: "person.fill")
                                Text("Profile")
                            }
                        }
                        .foregroundColor(selectedTab == .profile ? .blue : .gray)
                    }
                    .frame(height: 40)
                    .padding()
                }
            }
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
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
