//
//  FlagImageService.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 14.02.2023.
//

import Foundation
import SwiftUI
import Combine

class FlagImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let event: Race
    
    init(event: Race) {
        self.event = event
        getFlagImage()
    }
    
    private func getFlagImage() {
        if event.circuit.location.country == "UK" {
            guard let url = URL(string: ("https://countryflagsapi.com/png/\(event.circuit.location.country.replacingOccurrences(of: "UK", with: "gb"))").replacingOccurrences(of: " ", with: "%20")) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
        } else {
            guard let url = URL(string: ("https://countryflagsapi.com/png/\(event.circuit.location.country.replacingOccurrences(of: "UAE", with: "ae"))").replacingOccurrences(of: " ", with: "%20")) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.imageSubscription?.cancel()
            })
        }
        
            

    }
    
}
