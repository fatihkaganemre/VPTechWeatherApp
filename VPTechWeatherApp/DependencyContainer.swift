//
//  DependencyContainer.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 12/05/2024.
//

import UIKit

protocol DependencyContainerProtocol {
    func makeHomeViewController() -> HomeViewController
    func makeDetailsViewController(forecasts: [DailyForecast]) -> DetailViewController
}

struct DependencyContainer: DependencyContainerProtocol {
    private let networkService: NetworkServiceProtocol
    private let calendarProvider: CalendarProviderProtocol
    private let formatter: FormatterProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        calendarProvider: CalendarProviderProtocol = CalendarProvider(),
        formatter: FormatterProtocol = Formatter()
    ) {
        self.networkService = networkService
        self.calendarProvider = calendarProvider
        self.formatter = formatter
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        let controller: HomeViewController = UIStoryboard.main.instantiateViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    func makeDetailsViewController(forecasts: [DailyForecast]) -> DetailViewController {
        let viewModel = makeDetailViewModel(forecasts: forecasts)
        let controller: DetailViewController = UIStoryboard.main.instantiateViewController()
        controller.viewModel = viewModel
        return controller
    }
    
    private func makeHomeViewModel() -> HomeViewModelProtocol {
        return HomeViewModel(
            networkService: networkService,
            formatter: formatter,
            calendar: calendarProvider
        )
    }
    
    private func makeDetailViewModel(forecasts: [DailyForecast]) -> DetailsViewModelProtocol {
        return DetailViewModel(
            forecasts: forecasts
        )
    }
}
