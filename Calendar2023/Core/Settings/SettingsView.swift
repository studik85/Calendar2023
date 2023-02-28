//
//  SettingsView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 28.02.2023.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com.ua")!
    let ergastApiURL = URL(string: "https://ergast.com/mrd/")!
    let personalURL = URL(string: "https://github.com/studik85")!
    
    var body: some View {
        NavigationView {
            List {
                generalSection
                ergastSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            }
        }
    }

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


extension SettingsView {
    
    private var generalSection: some View {
        Section("GENERAL") {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Andrey Studenkov. It uses SwiftUI, MVVM Architecture, Combine & Local Notification")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("My GitHub", destination: personalURL)
        }
    }
    
    private var ergastSection: some View {
        Section("🏁 Ergast API 🏁") {
            VStack(alignment: .leading) {
                Text("The Ergast Developer API is an experimental web service which provides a historical record of motor racing data for non-commercial purposes. Please read the terms and conditions of use. The API provides data for the Formula One series, from the beginning of the world championships in 1950.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Ergast API", destination: ergastApiURL)
        }
    }
    
    private var applicationSection: some View {
        Section("Application") {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
    
}

