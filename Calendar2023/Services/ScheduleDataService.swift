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
        
       scheduleSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: Schedule.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedSchedule in
                self?.allRacingEvents = returnedSchedule.mrData.raceTable.races
                self?.scheduleSubscription?.cancel()
            }

    }
}
