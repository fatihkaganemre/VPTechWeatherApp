//
//  NetworkService.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol {
    func getForecast(forCity city: String) -> Observable<Forecast>
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let apiKey = "1fed17ca4634e53285f3c97dd0389c2a"
    private let host = "https://api.openweathermap.org/data/2.5/"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getForecast(forCity city: String) -> Observable<Forecast> {
        fetch(
            request: .init(
                path: host + "forecast",
                method: .GET,
                parameters: [
                    .init(name: "q", value: city),
                    .init(name: "units", value: "metric")
                ]
            )
        )
    }
    
    private func fetch<T: Decodable>(request: NetworkRequest) -> Observable<T> {
        guard let urlRequest = request.urlRequest(apiKey: apiKey) else {
            return Observable.error(NetworkError.wrongRequest)
        }
        
        return URLSession.shared.rx.data(request: urlRequest)
            .map {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                return try decoder.decode(T.self, from: $0)
            }
            .observe(on: MainScheduler.asyncInstance)
    }
}
