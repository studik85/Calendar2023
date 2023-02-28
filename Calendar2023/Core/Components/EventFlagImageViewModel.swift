//
//  EventFlagImageViewModel.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 14.02.2023.
//

import Foundation
import SwiftUI
import Combine

class EventFlagImageViewModel: ObservableObject {
    
    @Published var flagImage: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let event: Race
    private let dataService: FlagImageService
    
    init(event: Race) {
        self.event = event
        self.dataService = FlagImageService(event: event)
        self.addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.flagImage = returnedImage
            }
            .store(in: &cancellables)

    }
}
