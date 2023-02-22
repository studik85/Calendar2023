//
//  DetailView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 20.02.2023.
//

import SwiftUI
import MapKit

struct DetailLoadingView: View {
    @Binding var event: Race?
    var body: some View {
        ZStack{
            if let event = event {
                DetailView(event: event)
            }
        }
    }
}


struct DetailView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    let mapSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let event: Race
    
    init(event: Race) {
        self.event = event
    }
    
    var body: some View {
        ZStack{
                mapLayer
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 16){
                        imageSection
                        titleSection
                    }
                    scheduleSection
                }
                .padding(15)
                .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
//                    .offset(y: 10)
                )
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius:20)
            .padding()
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(event: dev.event)
            .environmentObject(HomeViewModel())
    }
}


extension DetailView {
  private  var mapLayer: some View {
      Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(event.circuit.location.lat) ?? 0.0, longitude: Double(event.circuit.location.long) ?? 0.0), span: mapSpan)))
    }
    

    private var imageSection: some View {
        ZStack{
            Image(event.circuit.location.locality)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial))
        .cornerRadius(10)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 1){
            Text("ROUND \(event.round)")
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Text(event.raceName)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(event.circuit.circuitName)
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var scheduleSection: some View {
        VStack(spacing: 0){
            raceSection
            Divider()
            firstPracticeSection
            Divider()
            if event.thirdPractice?.date != nil {
                secondPracticeSection
                Divider()
                thirdPracticeSection
                Divider()
                qualificationSection
             
            } else {
                qualificationSection
                Divider()
                secondPracticeSection
                Divider()
                sprintSection
            }
        }
    }
    
    private var raceSection: some View {
        
        VStack(alignment: .leading) {
            Text("Race")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.date, time: event.time))
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var firstPracticeSection: some View {
        VStack(alignment: .leading){
            Text("First Practice")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.firstPractice.date, time: event.firstPractice.time))
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var secondPracticeSection: some View {
        VStack(alignment: .leading) {
            Text("Second Practice")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.secondPractice.date, time: event.secondPractice.time))
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var thirdPracticeSection: some View {
        VStack(alignment: .leading) {
            Text("Third Practice")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.thirdPractice?.date ?? "no date", time: event.thirdPractice?.time ?? "no time"))
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var qualificationSection: some View {
        VStack(alignment: .leading) {
            Text("Qualifying")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.qualifying.date, time: event.qualifying.time))
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var sprintSection: some View {
        VStack (alignment: .leading){
            Text("Sprint")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.sprint?.date ?? "no date", time: event.sprint?.time ?? "no time"))
                .font(.subheadline)
                .foregroundColor(Color.theme.accent)
        }
    }
}
