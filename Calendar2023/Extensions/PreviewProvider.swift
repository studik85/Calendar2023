//
//  PreviewProvider.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 13.02.2023.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {
        
    }
    
    let homeVM = HomeViewModel()
    
    let event = Race(season: "2023", round: "1", url: "https://en.wikipedia.org/wiki/2023_Bahrain_Grand_Prix", raceName: "Bahrain Grand Prix", circuit: Circuit(circuitID: "bahrain", url: "http://en.wikipedia.org/wiki/Bahrain_International_Circuit", circuitName: "Bahrain International Circuit", location: Location(lat: "26.0325", long: "50.5106", locality: "Sakhir", country: "Bahrain")), date: "2023-03-05", time: "15:00:00Z", firstPractice: NotRaceEvent(date: "2023-03-03", time: "11:30:00Z"), secondPractice: NotRaceEvent(date: "2023-03-03", time: "15:00:00Z"), thirdPractice: NotRaceEvent(date: "2023-03-04", time: "11:30:00Z") , qualifying: NotRaceEvent(date: "2023-03-04", time: "15:00:00Z"), sprint: NotRaceEvent(date: "", time: ""))
}
