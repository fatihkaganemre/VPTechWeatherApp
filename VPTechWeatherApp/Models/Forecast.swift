//
//  Forecast.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation

struct Forecast: Decodable {
    let city: City
    let list: [DailyForecast]
}
