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
    private let fileManager = LocalFileManager.instance
    private let folderName = "flag_images"
    private let imageName: String
    
    init(event: Race) {
        self.event = event
        self.imageName = event.circuit.location.country
        getflagImage()
    }
    
    private func getflagImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadFlagImage()
        }
    }
    
    private func downloadFlagImage() {
        if event.circuit.location.country == "UK" {
            guard let url = URL(string: ("https://countryflagsapi.com/png/\(event.circuit.location.country.replacingOccurrences(of: "UK", with: "gb"))").replacingOccurrences(of: " ", with: "%20")) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else {return
                }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
        } else {
            guard let url = URL(string: ("https://countryflagsapi.com/png/\(event.circuit.location.country.replacingOccurrences(of: "UAE", with: "ae"))").replacingOccurrences(of: " ", with: "%20")) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else {return
                }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
        }
        
            

    }
    
}
