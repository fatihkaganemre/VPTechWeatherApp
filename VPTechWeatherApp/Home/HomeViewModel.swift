//
//  HomeViewModel.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum HomeViewModelOutput {
    case alert(AlertViewModel)
    case details(forecasts: [DailyForecast])
}

struct HomeViewData {
    let isLoading: Driver<Bool>
    let headerData: Driver<HomeHeaderData?>
    let cellDatas: Driver<[WeatherCellData]>
    let selectedItem: PublishRelay<Int>
    let pullToRefresh: PublishRelay<Void>
}

protocol HomeViewModelProtocol {
    var output: Observable<HomeViewModelOutput> { get }
    var homeViewData: HomeViewData { get }
}

class HomeViewModel: HomeViewModelProtocol {
    private let networkService: NetworkServiceProtocol
    private let formatter: FormatterProtocol
    private let calendar: CalendarProviderProtocol
    private var disposeBag = DisposeBag()
    
    private let isLoadingSubject = BehaviorRelay<Bool>(value: true)
    private let isRefreshingRelay = PublishRelay<Bool>()
    private var forecasts: Forecast? = nil
    private var dailyForecasts: [DailyForecast] = []
    
    lazy var output: Observable<HomeViewModelOutput> = .merge(
        navigateToDetails,
        showAlert
    )
    
    var isLoading: Driver<Bool> {
        isLoadingSubject.asDriver()
    }
    
    private lazy var weatherResponse = refresh
        .startWith(())
        .flatMapLatest { [weak self] in self?.networkService.getForecast(forCity: "Paris") ?? .empty() }
        .do(
            onNext: { [weak self] _ in self?.isLoadingSubject.accept(false) },
            onError: { [weak self] _ in self?.showAlert() },
            onSubscribe: { [weak self] in self?.isLoadingSubject.accept(true)  }
        )
        .share()
    
    private let refresh = PublishRelay<Void>()
    private lazy var headerData: Driver<HomeHeaderData?> = weatherResponse
        .map { [weak self] in self?.getHomeHeaderDataFromForecast($0) }
        .asDriver(onErrorJustReturn: nil)
    private lazy var cellDatas: Driver<[WeatherCellData]> = weatherResponse
        .map { [weak self] in self?.getCellDatasFromForecast(forecast: $0) ?? [] }
        .asDriver(onErrorJustReturn: [])
    
    private let selectedItem = PublishRelay<Int>()
    private let pullToRefresh = PublishRelay<Void>()
    
    private lazy var navigateToDetails = selectedItem.map { [weak self] item in
        let forecasts = self?.getForecastsForSelectedDay(forRow: item) ?? []
        return HomeViewModelOutput.details(forecasts: forecasts)
    }.asObservable()
    
    private lazy var showAlert = weatherResponse.catch {
        let alertViewModel = AlertViewModel.requestFailedAlert(errorMessage: "Request Failed")
        let output = HomeViewModelOutput.alert(alertViewModel)
        return Observable.just(output)
    }
    
    
    lazy var homeViewData = HomeViewData(
        isLoading: isLoadingSubject.asDriver(),
        headerData: headerData,
        cellDatas: cellDatas,
        selectedItem: selectedItem,
        pullToRefresh: pullToRefresh
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
        let temp = self.formatter.format(temperature: currentForecast.main.temp)
        let maxTemp = self.formatter.format(temperature: currentForecast.main.temp_max)
        let minTemp = self.formatter.format(temperature: currentForecast.main.temp_min)
        let description = currentForecast.weather.first?.description.capitalized
        let imageUrl: URL? = if let icon = currentForecast.weather.first?.icon {
            URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        } else {
            nil
        }
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
