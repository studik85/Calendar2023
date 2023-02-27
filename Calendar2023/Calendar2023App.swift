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
    @StateObject var lnManager = LocalNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
            .environmentObject(lnManager)
        }
    }
}
