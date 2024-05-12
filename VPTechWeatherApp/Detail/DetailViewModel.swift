//
//  DetailViewModel.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift

protocol DetailsViewModelProtocol {
    func headerData() -> DetailHeaderData?
    var cellDatas: [WeatherCellData] { get }
}

class DetailViewModel: DetailsViewModelProtocol {
    private let formatter: FormatterProtocol
    private let dailyForecasts: [DailyForecast]
    private(set) var cellDatas: [WeatherCellData] = []
    
    init(
        forecasts: [DailyForecast],
        formatter: FormatterProtocol = Formatter()
    ) {
        self.dailyForecasts = forecasts
        self.formatter = formatter
        self.cellDatas = forecasts.map { whetherCellData(fromDailyForecast: $0) }
    }
    
    func headerData() -> DetailHeaderData? {
        guard let currentForecast = dailyForecasts.first else { return nil }
        let imageUrl: URL? = if let icon = currentForecast.weather.first?.icon {
            URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        } else {
            nil
        }
        let temp = formatter.format(temperature: currentForecast.main.temp)
        let feelsLike = formatter.format(temperature: currentForecast.main.feels_like)
        let maxTemp = formatter.format(temperature: currentForecast.main.temp_max)
        let minTemp = formatter.format(temperature: currentForecast.main.temp_min)
        let description = currentForecast.weather.first?.description.capitalized
        let wind = String(currentForecast.wind.speed)
        let humidity = String(currentForecast.main.humidity)
        let pressure = String(currentForecast.main.pressure)
        let perception = String(Int(currentForecast.pop * 100))
        return .init(
            imageURL: imageUrl,
            temperature: temp,
            feelsLike: feelsLike,
            maxTemperature: maxTemp,
            minTemperature: minTemp,
            description: description,
            wind: wind,
            humidity: humidity,
            pressure: pressure,
            perception: perception
        )
    }
    
    private func whetherCellData(fromDailyForecast forecast: DailyForecast) -> WeatherCellData {
        let date = forecast.dt.formatted(date: .omitted, time: .shortened)
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
