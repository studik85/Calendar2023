//
//  NetworkingManager.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 13.02.2023.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "Bad Response From URL: \(url)"
            case .unknown: return "Unknown Error Occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
             .subscribe(on: DispatchQueue.global(qos: .default))
             .tryMap({try handleURLResponse(output: $0, url: url)})
             .receive(on: DispatchQueue.main)
             .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleComplition(complition: Subscribers.Completion<Error>) {
        switch complition {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
