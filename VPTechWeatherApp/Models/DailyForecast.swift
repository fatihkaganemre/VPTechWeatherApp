//
//  DailyForecast.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

struct DailyForecast: Decodable {
    let dt: Date
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dt_txt: String
}
