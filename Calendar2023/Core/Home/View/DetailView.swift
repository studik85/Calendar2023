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
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    let mapSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let event: Race
    
    init(event: Race) {
        self.event = event
    }
    
    var body: some View {
        ZStack{
            mapLayer2
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 18){
                        imageSection
                        titleSection
                        if let url = URL(string: event.circuit.url) {
                            Link("More Info", destination: url)
                                .font(.caption)
                                .tint(.blue)
                        }
                    }
                    .padding(8)
                    scheduleSection
                }
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                )
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.3), radius:20)
                .padding(5)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 25)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(event: dev.event)
            .environmentObject(HomeViewModel())
            .environmentObject(LocalNotificationManager())
    }
}


extension DetailView {
    private  var mapLayer: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(event.circuit.location.lat) ?? 0.0, longitude: Double(event.circuit.location.long) ?? 0.0), span: mapSpan)))
    }
    
    private  var mapLayer2: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(
            latitude: Double(event.circuit.location.lat) ?? 0.0000,
            longitude: Double(event.circuit.location.long) ?? 0.0000),
                                                           span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
            annotationItems: [event]) { event in
            MapAnnotation(coordinate:
                            CLLocationCoordinate2D(
                                latitude: Double(event.circuit.location.lat) ?? 0.0000,
                                longitude: Double(event.circuit.location.long) ?? 0.0000)) {
                                    EventMapAnnotationView()
                                        .shadow(radius: 10)
                                }
            
        }
    }
    
    private var imageSection: some View {
        ZStack{
            Image(event.circuit.location.locality)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 100)
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
        VStack(alignment: .leading, spacing: 3){
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
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Race")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accent)
                Text(vm.convertUTCDateToLocalDateString(date: event.date, time: event.time))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accent)
            }
            Spacer()
            Button {
                if lnManager.isGranted {
                    Task {
                        guard let date = vm.convertUTCDateToLocalDate(date: event.date, time: event.time) else { return}
                        let newDate = date.addingTimeInterval(TimeInterval(-5.0 * 60))
                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newDate)
                        let localNotification = LocalNotification(
                            identifier: UUID().uuidString,
                            title: event.raceName,
                            body: event.circuit.circuitName,
                            dateComponents: dateComponents,
                            repeats: false)
                        await lnManager.schedule(localNotification: localNotification)
                        
                    }
                    
                    Task {
                        let notification = LocalNotification(identifier: UUID().uuidString, title: event.raceName, body: "This is a Test 15 sec. Notification", timeInterval: 15, repeats: false)
                        await lnManager.schedule(localNotification: notification)
                    }
                    
                } else {
                    lnManager.openSettings()
                }
            }
        label: {
            Image(systemName: lnManager.isGranted ? "bell.circle" : "bell.slash.circle")
                .font(.title)
                .padding(0)
        }
        .padding(.horizontal, 10)
        .disabled(lnManager.pendingRequest.contains(where: {$0.content.title == event.raceName}))
        }
    }
    
    private var firstPracticeSection: some View {
        VStack(alignment: .leading, spacing: 4){
            Text("1 Practice")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.firstPractice.date, time: event.firstPractice.time))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
        }
        
    }
    
    private var secondPracticeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("2 Practice")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.secondPractice.date, time: event.secondPractice.time))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var thirdPracticeSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("3 Practice")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.thirdPractice?.date ?? "", time: event.thirdPractice?.time ?? ""))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var qualificationSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Qualifying")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.qualifying.date, time: event.qualifying.time))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var sprintSection: some View {
        VStack (alignment: .leading, spacing: 4){
            Text("Sprint")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
            Text(vm.convertUTCDateToLocalDateString(date: event.sprint?.date ?? "", time: event.sprint?.time ?? ""))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.accent)
        }
    }
}
