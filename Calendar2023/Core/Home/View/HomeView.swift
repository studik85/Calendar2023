//
//  HomeView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 12.02.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showPortfolio: Bool = false
    @State private var selectedEvent: Race? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            //Background Layer
            Color.theme.background
                .ignoresSafeArea()
            //Content Layer
            VStack {
                homeHader
                if !showPortfolio {
                    SearchBarView(searchText: $vm.searchText)
                    columnTitles
                    allRacingList
                }
                if showPortfolio {
                    notificationList
                }
                Spacer(minLength: 0)
            }
        }
        .task {
            try? await lnManager.requestAuthoriztion()
        }
        .onChange(of: scenePhase, perform: { newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSettings()
                    await lnManager.getPendingRequests()
                }
            }
        })
        .background(
            NavigationLink(destination: DetailLoadingView(event: $selectedEvent), isActive: $showDetailView, label: {EmptyView()})
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .environmentObject(dev.homeVM)
        .environmentObject(LocalNotificationManager())
    }
}

extension HomeView {
    private var homeHader: some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "xmark" : "info")
                .animation(.none, value: 0)
                .onTapGesture {
                    if showPortfolio {lnManager.clearRequests()}
                    else {}
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "My Notification" : "2023 Race Calendar ")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: showPortfolio ? "flag.checkered.2.crossed" : "bell.and.waves.left.and.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 360 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var notificationList: some View {
        
        List {
            ForEach(lnManager.pendingRequest, id: \.identifier) { notifcation in
                VStack(alignment: .leading) {
                    Text(notifcation.content.body)
                    Text(notifcation.content.title)
                    //                    Text(notifcation.content.subtitle)
                    Text(notifcation.trigger!.description)
                }
                .font(.caption)
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        lnManager.removeRequest(withIdentifier: notifcation.identifier)
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        
        .listStyle(.plain)
        
    }
    
    private var allRacingList: some View {
        List {
            ForEach(vm.allRacingEvents) { event in
                ScheduleRowView(racingEvent: event)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(event: event)
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioRacingList: some View {
        List {
            ForEach(vm.portfolioRaces) { event in
                ScheduleRowView(racingEvent: event)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack{
            Text("Round")
            Spacer()
            Text("Race Name")
            Spacer()
            Text("Date & Local Time")
                .frame(width: UIScreen.main.bounds.width / 3.5)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private func segue(event: Race) {
        selectedEvent = event
        showDetailView.toggle()
    }
}
