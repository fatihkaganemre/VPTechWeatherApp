//
//  HomeNetwork.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift

protocol HomeNetworkProtocol {
    func getForecast(forCity city: String) -> Observable<Forecast>
}

class HomeNetwork: HomeNetworkProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getForecast(forCity city: String) -> Observable<Forecast> {
        networkService.fetch(
            request: .init(
                path: "https://api.openweathermap.org/data/2.5/forecast",
                method: .GET,
                parameters: [
                    .init(name: "q", value: city),
                    .init(name: "units", value: "metric")
                ]
            )
        )
    }
}
