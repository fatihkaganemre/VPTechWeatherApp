//
//  ModelMocks.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 12/05/2024.
//

import Foundation
@testable import VPTechWeatherApp

extension Forecast {
    static func mock(list: [DailyForecast] =  [.mock()]) -> Forecast {
        .init(city: .mock(), list: list)
    }
}

extension City {
    static func mock() -> City {
        .init(
            id: 1,
            name: "",
            coord: nil,
            country: "",
            population: 1,
            timezone: 1,
            sunrise: .init(timeIntervalSince1970: 0),
            sunset: .init(timeIntervalSince1970: 0)
        )
    }
}

extension DailyForecast {
    static func mock(
        date: Date = .init(timeIntervalSince1970: 0),
        main: Main = .mock(),
        weather: [Weather] = [.mock()],
        wind: Wind = .mock(),
        visibility: Int = 0,
        pop: Double = 0
    ) -> DailyForecast {
        .init(
            dt: date,
            main: .mock(),
            weather: weather,
            clouds: .init(all: 1),
            wind: wind,
            visibility: visibility,
            pop: pop,
            sys: .init(pod: .day),
            dt_txt: ""
        )
    }
}

extension Main {
    static func mock(
        temp: Double = 1,
        feels_like: Double = 1,
        temp_min: Double = 1,
        temp_max: Double = 1,
        pressure: Int = 1,
        sea_level: Int = 1,
        grnd_level: Int = 1,
        humidity: Int = 1,
        temp_kf: Double = 1
    ) -> Main {
        .init(
            temp: temp,
            feels_like: feels_like,
            temp_min: temp_min,
            temp_max: temp_max,
            pressure: pressure,
            sea_level: sea_level,
            grnd_level: grnd_level,
            humidity: humidity,
            temp_kf: temp_kf
        )
    }
}

extension Weather {
    static func mock(
        icon: String = "",
        description: String = ""
    ) -> Weather {
        .init(
            id: 1,
            main: "",
            description: description,
            icon: icon
        )
    }
}

extension Wind {
    static func mock(speed: Float = 1) -> Wind {
        .init(
            speed: speed,
            deg: 1,
            gust: 1
        )
    }
}
