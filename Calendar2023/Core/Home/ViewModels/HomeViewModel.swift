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
    
}
