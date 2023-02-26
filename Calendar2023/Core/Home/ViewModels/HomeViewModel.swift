//
//  HomeViewModel.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 13.02.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allRacingEvents: [Race] = []
    @Published var portfolioRaces: [Race] = []
    @Published var searchText: String = ""
    
    private let dataService = ScheduleDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
      addSubscribers()
    }
    
    func addSubscribers() {

        
        $searchText
            .combineLatest(dataService.$allRacingEvents)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterEvents)

            .sink { [weak self] (returnedEvents) in
                self?.allRacingEvents = returnedEvents
            }
            .store(in: &cancellables)
    }
    
    private func filterEvents(text: String, events: [Race]) -> [Race] {
        guard !text.isEmpty else {
            return events
        }
        
        let lowercasedText = text.lowercased()
        return events.filter { (event) -> Bool in
            return event.raceName.lowercased().contains(lowercasedText)
        }
    }
    
    func convertUTCDateToLocalDateString(date: String, time: String) -> String {
        let stringDate: String = date + "T" + time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = formatter.date(from: stringDate)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "d MMM, HH:mm"
        let localDateStr = formatter.string(from: newDate ?? Date())
        return localDateStr.capitalized
    }
    
    func convertUTCDateToLocalDate(date: String, time: String) -> Date? {
        let stringDate: String = date + "T" + time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = formatter.date(from: stringDate)
        return newDate
    }
    
}
