//
//  HomeViewModel.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelProtocol {
    var output: Observable<HomeViewModelOutput> { get }
    var homeViewData: HomeViewData { get }
}

class HomeViewModel: HomeViewModelProtocol {
    private let networkService: NetworkServiceProtocol
    private let formatter: FormatterProtocol
    private let calendar: CalendarProviderProtocol
    private var disposeBag = DisposeBag()
    private var forecasts: Forecast? = nil
    private var dailyForecasts: [DailyForecast] = []
    
    private let showAlertRelay = PublishRelay<String>()
    private let refresh = PublishRelay<Void>()
    private let isLoadingRelay = BehaviorRelay<Bool>(value: true)
    private let selectedItem = PublishRelay<Int>()
    
    private lazy var forecastResponse = refresh
        .startWith(())
        .flatMapLatest { [weak self] in self?.networkService.getForecast(forCity: "Paris") ?? .empty() }
        .do(
            onNext: { [weak self] _ in self?.isLoadingRelay.accept(false) },
            onError: { [weak self] error in
                self?.showAlertRelay.accept(error.localizedDescription)
                self?.isLoadingRelay.accept(false)
            }
        )
        .share(replay: 1)
    
    private var isLoading: Driver<Bool> {
        isLoadingRelay.asDriver()
    }
    
    private lazy var headerData: Driver<HomeHeaderData?> = forecastResponse
        .map { [weak self] in self?.getHomeHeaderDataFromForecast($0) }
        .asDriver(onErrorJustReturn: nil)
    
    private lazy var cellDatas: Driver<[WeatherCellData]> = forecastResponse
        .map { [weak self] in self?.getCellDatasFromForecast(forecast: $0) ?? [] }
        .asDriver(onErrorJustReturn: [])
    
    private lazy var navigateToDetails = selectedItem.map { [weak self] item in
        let forecasts = self?.getForecastsForSelectedDay(forRow: item) ?? []
        return HomeViewModelOutput.details(forecasts: forecasts)
    }.asObservable()
    
    private lazy var showAlert = showAlertRelay.map {
        let alertViewModel = AlertViewModel.requestFailedAlert(errorMessage: $0)
        return HomeViewModelOutput.alert(alertViewModel)
    }.asObservable()
    
    lazy var output: Observable<HomeViewModelOutput> = .merge(
        navigateToDetails,
        showAlert
    )
    
    lazy var homeViewData = HomeViewData(
        isLoading: isLoading,
        headerData: headerData,
        cellDatas: cellDatas,
        selectedItem: selectedItem,
        pullToRefresh: refresh
    )
    
    init(
        networkService: NetworkServiceProtocol,
        formatter: FormatterProtocol,
        calendar: CalendarProviderProtocol
    ) {
        self.networkService = networkService
        self.formatter = formatter
        self.calendar = calendar
    }
    
    private func getHomeHeaderDataFromForecast(_ forecast: Forecast) -> HomeHeaderData? {
        self.forecasts = forecast
        guard let currentForecast = forecast.list.first else { return nil }
        let temp = formatter.format(temperature: currentForecast.main.temp)
        let maxTemp = formatter.format(temperature: currentForecast.main.temp_max)
        let minTemp = formatter.format(temperature: currentForecast.main.temp_min)
        let description = currentForecast.weather.first?.description.capitalized
        let imageUrl = ImageUrlProvider.getImageUrl(currentForecast.weather.first?.icon)
        return HomeHeaderData(
            name: forecast.city.name,
            imageURL: imageUrl,
            temperature: temp,
            description: description,
            maxTemperature: maxTemp,
            minTemperature: minTemp
        )
    }
    
    private func getCellDatasFromForecast(forecast: Forecast) -> [WeatherCellData] {
        let groupedDailyForecasts = groupForecastsByDate(forecasts: forecast.list)
        dailyForecasts = groupedDailyForecasts.map(\.forecast)
        return groupedDailyForecasts.map { (day, forecast) -> WeatherCellData in
            let date = forecast.dt.formatted(Date.FormatStyle().weekday(.abbreviated))
            let maxTemp = formatter.format(temperature: forecast.main.temp_max)
            let minTemp = formatter.format(temperature: forecast.main.temp_min)
            let imageUrl = ImageUrlProvider.getImageUrl(forecast.weather.first?.icon)
            return WeatherCellData(
                date: date,
                imageURL: imageUrl,
                minTemperature: minTemp,
                maxTemperature: maxTemp
            )
        }
    }
    
    private func getForecastsForSelectedDay(forRow row: Int) -> [DailyForecast] {
        let dailyForecast = dailyForecasts[row]
        let forecastsForSelectedDay = forecasts?.list.filter {
            let forecastDay = calendar.getComponent(.day, fromDate: $0.dt)
            let selectedForecastDay = calendar.getComponent(.day, fromDate: dailyForecast.dt)
            return forecastDay == selectedForecastDay
        } ?? []
        return forecastsForSelectedDay
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
