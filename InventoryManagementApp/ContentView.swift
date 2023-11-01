//
//  ContentView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import SwiftUI
import CoreData
import UserNotifications

enum CustomTab { // This is the different custom tabs in the Contentview! which you can see in the navigation bar
    case home
    case settings
    case profile
}

struct ContentView: View {
    
    @State private var selectedTab: CustomTab = .home // state variable to track which tab is being currently selected
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    // Content
                    ZStack(alignment: .leading) {
                        if selectedTab == .home { // shows page view based on what has been selected
                            HomePageView()
                        } else if selectedTab == .settings {
                            Text("Settings Content")
                        } else if selectedTab == .profile {
                            Text("Profile Content")
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - 50)
                    
                    // Custom Tab Bar
                    HStack {
                        Button(action: { selectedTab = .home }) {
                            VStack {
                                Image(systemName: "house.fill") // home tab
                                Text("Home")
                            }
                        }
                        .foregroundColor(selectedTab == .home ? .blue : .gray)
                        
                        Spacer()
                        
                        Button(action: { selectedTab = .settings }) { // This is the setting tab
                            VStack {
                                Image(systemName: "gearshape.fill")
                                Text("Settings")
                            }
                        }
                        .foregroundColor(selectedTab == .settings ? .blue : .gray)
                        
                        Spacer()
                        
                        Button(action: { selectedTab = .profile }) { // profile tab
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
        }.onAppear { // when contentivew is displayed , it will automatically request notification permission and schedule a daily notification
            NotificationService.shared.checkAndRequestNotificationPermission()
            ItemModel().scheduleDailyNotification()
        }
    }
    
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

