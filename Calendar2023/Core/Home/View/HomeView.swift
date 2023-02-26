//
//  HomeView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 12.02.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @EnvironmentObject private var nm: NotificationManager
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
                    
                    //                        .transition(.move(edge: .leading))
                    
                }
                
                if showPortfolio {
                    notificationList
//                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
        
        .background(
            NavigationLink(destination: DetailLoadingView(event: $selectedEvent), isActive: $showDetailView, label: {EmptyView()})
        )
        //        .onAppear(perform: nm.reloadAuthorizationStatus)
        //        .onChange(of: nm.authorizationStatus) { authorizationStatus in
        //            switch authorizationStatus {
        //            case .notDetermined:
        //                nm.requestAuthorization()
        //            case .authorized:
        //                nm.reloadLocalNotifications()
        //            default:
        //                break
        //            }
        //
        //        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .environmentObject(dev.homeVM)
        .environmentObject(NotificationManager())
    }
}

extension HomeView {
    private var homeHader: some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "xmark" : "info")
                .animation(.none, value: 0)
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
            ForEach(nm.notifications, id: \.identifier) { notifcation in
                VStack(alignment: .leading) {
                    Text(notifcation.content.body)
                    Text(notifcation.content.title)
                    Text(notifcation.content.subtitle)
                    
                    //                    Text(notifcation.trigger!.description)
                }
                .font(.caption)
                
                
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: delete)
            
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
    
    func delete(_ indexSet: IndexSet) {
        nm.deleteLocalNotifications(identifiers: indexSet.map {nm.notifications[$0].identifier})
        nm.reloadLocalNotifications()
    }
}
