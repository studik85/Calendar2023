//
//  ScheduleDataService.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 13.02.2023.
//

import Foundation
import Combine


class ScheduleDataService {
    
    var scheduleSubscription: AnyCancellable?
    
    @Published var allRacingEvents: [Race] = []
    
    init() {
        getSchedules()
    }
    
    private func getSchedules() {
        guard let url = URL(string: "https://ergast.com/api/f1/2023.json") else {return}
        
        scheduleSubscription = NetworkingManager.download(url: url)
            .decode(type: Schedule.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedSchedule in
                self?.allRacingEvents = returnedSchedule.mrData.raceTable.races
                self?.scheduleSubscription?.cancel()
            })

    }
}
