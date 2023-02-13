//
//  HomeView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 12.02.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            //Background Layer
            Color.theme.background
                .ignoresSafeArea()
            //Content Layer
            VStack {
                homeHader
                columnTitles
                if !showPortfolio {
                    allRacingList
                    
                    .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                   portfolioRacingList
                        
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    private var homeHader: some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            Spacer()
            Text(showPortfolio ? "Favorite Races" : "Race Calendar ")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allRacingList: some View {
        List {
            ForEach(vm.allRacingEvents) { event in
                ScheduleRowView(racingEvent: event)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
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
            Text("Date")
                .frame(width: UIScreen.main.bounds.width / 3.5)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
