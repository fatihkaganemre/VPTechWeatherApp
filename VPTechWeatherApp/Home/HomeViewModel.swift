//
//  HomeViewModel.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    private let networkService: HomeNetworkProtocol
    private let coordinator: AppCoordinatorProtocol
    private let formatter: FormatterProtocol
    private let calendar: CalendarProviderProtocol
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
        coordinator: AppCoordinatorProtocol,
        calendar: CalendarProviderProtocol = CalendarProvider()
    ) {
        self.networkService = networkService
        self.formatter = formatter
        self.coordinator = coordinator
        self.calendar = calendar
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
                onError: { [weak self]_ in
                    self?.showAlert()
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
    
    private func showAlert() {
        let alertViewModel = AlertViewModel.requestFailedAlert(errorMessage: "Request Failed")
        coordinator.showAlert(viewModel: alertViewModel)
    }
    
    func headerData() -> Driver<HomeHeaderData?> {
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
        }.asDriver(onErrorJustReturn: nil)
    }
    
    func cellData() -> Driver<[WeatherCellData]> {
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
            }).asDriver(onErrorJustReturn: [])
    }
    
    func showDetailView(forRow row: Int) {
        let dailyForecast = dailyForecasts[row]
        let forecastsForSelectedDay = forecasts?.list.filter {
            let forecastDay = calendar.getComponent(.day, fromDate: $0.dt)
            let selectedForecastDay = calendar.getComponent(.day, fromDate: dailyForecast.dt)
            return forecastDay == selectedForecastDay
        } ?? []
        coordinator.showDetailView(withForecasts: forecastsForSelectedDay)
    }
    
    private func groupForecastsByDate(forecasts: [DailyForecast]) -> [(day: Int, forecast: DailyForecast)] {
        var groupedDailyForecasts: [(day: Int, forecast: DailyForecast)] = []
        forecasts.forEach { forecast in
            let day = calendar.getComponent(.day, fromDate: forecast.dt)
            if groupedDailyForecasts.isEmpty || !groupedDailyForecasts.contains(where: { $0.0 == day }) {
                groupedDailyForecasts.append((day: day, forecast: forecast))
            }
        }
        return groupedDailyForecasts
    }
}
