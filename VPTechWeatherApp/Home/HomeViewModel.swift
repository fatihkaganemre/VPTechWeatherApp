//
//  HomeViewModel.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift

class HomeViewModel {
    private let networkService: HomeNetworkProtocol
    private let coordinator: AppCoordinatorProtocol
    private let formatter: FormatterProtocol
    private var disposeBag = DisposeBag()
    private let forecastSubject = PublishSubject<Forecast>()
    private let isLoadingSubject = BehaviorSubject<Bool>(value: true)
    private var forecasts: Forecast?
    private var dailyForecasts: [DailyForecast] = []
    
    var data: Observable<Forecast> {
        forecastSubject.asObservable()
    }
    
    var isLoading: Observable<Bool> {
        isLoadingSubject.asObserver()
    }
    
    init(
        networkService: HomeNetworkProtocol = HomeNetwork(),
        formatter: FormatterProtocol = Formatter(),
        coordinator: AppCoordinatorProtocol
    ) {
        self.networkService = networkService
        self.formatter = formatter
        self.coordinator = coordinator
    }
    
    func fetchForecast(isPullToRefresh: Bool = false ) {
        networkService.getForecast(forCity: "Paris")
            .observe(on: MainScheduler.instance)
            .do(
                onNext: { [weak self] _ in 
                    if !isPullToRefresh {
                        self?.isLoadingSubject.onNext(false)
                    }
                },
                onSubscribe: { [weak self] in 
                    if !isPullToRefresh {
                        self?.isLoadingSubject.onNext(true)
                    }
                }
            )
            .subscribe(forecastSubject)
            .disposed(by: disposeBag)
    }
    
    func headerData() -> Observable<HomeHeaderData?> {
        forecastSubject.map { [weak self] forecast in
            guard let self = self else { return nil }
            self.forecasts = forecast
            guard let currentForecast = forecast.list.first else { return nil }
            let temp = self.formatter.format(temperature: currentForecast.main.temp)
            let maxTemp = self.formatter.format(temperature: currentForecast.main.temp_max)
            let minTemp = self.formatter.format(temperature: currentForecast.main.temp_min)
            let description = currentForecast.weather.first?.description.capitalized
            return HomeHeaderData(
                name: forecast.city.name,
                temperature: temp,
                description: description,
                maxTemperature: maxTemp,
                minTemperature: minTemp
            )
        }
    }
    
    func cellData() -> Observable<[WeatherCellData]> {
        forecastSubject.map(\.list)
            .map({ [weak self] dailyForecasts in
                let groupedDailyForecasts = self?.groupForecastsByDate(forecasts: dailyForecasts) ?? []
                self?.dailyForecasts = groupedDailyForecasts.map(\.forecast)
                return groupedDailyForecasts.map { (day, forecast) -> WeatherCellData in
                    let date = forecast.dt.formatted(Date.FormatStyle().weekday(.abbreviated))
                    let maxTemp = self?.formatter.format(temperature: forecast.main.temp_max)
                    let minTemp = self?.formatter.format(temperature: forecast.main.temp_min)
                    let imageUrl: URL? = if let icon = forecast.weather.first?.icon {
                        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                    } else {
                        nil
                    }

                    return WeatherCellData(
                        date: date,
                        imageURL: imageUrl,
                        minTemperature: minTemp,
                        maxTemperature: maxTemp
                    )
                }
            }).asObservable()
    }
    
    func showDetailView(forRow row: Int) {
        let dailyForecast = dailyForecasts[row]
        let forecastsForSelectedDay = forecasts?.list.filter {
            let forecastDateDay = Calendar.current.component(.day, from: $0.dt)
            let selectedForecastDateDay = Calendar.current.component(.day, from: dailyForecast.dt)
            return forecastDateDay == selectedForecastDateDay
        } ?? []
        coordinator.showDetailView(withForecasts: forecastsForSelectedDay)
    }
    
    private func groupForecastsByDate(forecasts: [DailyForecast]) -> [(day: Int, forecast: DailyForecast)] {
        var groupedDailyForecasts: [(day: Int, forecast: DailyForecast)] = []
        forecasts.forEach { forecast in
            let day = Calendar.current.component(.day, from: forecast.dt)
            if groupedDailyForecasts.isEmpty || !groupedDailyForecasts.contains(where: { $0.0 == day }) {
                groupedDailyForecasts.append((day: day, forecast: forecast))
            }
        }
        return groupedDailyForecasts
    }
}
