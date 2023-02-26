//
//  Calendar2023App.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 12.02.2023.
//

import SwiftUI

@main
struct Calendar2023App: App {
    
    @StateObject private var vm = HomeViewModel()
    @StateObject private var nm = NotificationManager()

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .onAppear(perform: nm.reloadAuthorizationStatus)
            .onChange(of: nm.authorizationStatus) { authorizationStatus in
                switch authorizationStatus {
                case .notDetermined:
                    nm.requestAuthorization()
                case .authorized:
                    nm.reloadLocalNotifications()
                default:
                    break
                }

            }
            .environmentObject(vm)
            .environmentObject(nm)
        }
    }
}
