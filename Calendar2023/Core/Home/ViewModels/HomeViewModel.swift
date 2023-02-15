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
    
    private let dataService = ScheduleDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
      addSubscribers()
    }
    
    func addSubscribers() {
        dataService.$allRacingEvents
            .sink { [weak self] returndedSchedule in
                self?.allRacingEvents = returndedSchedule
            }
            .store(in: &cancellables)
    }
    
    func convertUTCDateToLocalDateString(date: String, time: String) -> String {
        let stringDate: String = date + "T" + time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = formatter.date(from: stringDate)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let localDateStr = formatter.string(from: newDate ?? Date())
        return localDateStr
    }
    
}
