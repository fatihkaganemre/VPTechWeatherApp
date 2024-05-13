//
//  HomeViewModelOutput.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 13/05/2024.
//

import Foundation

enum HomeViewModelOutput {
    case alert(AlertViewModel)
    case details(forecasts: [DailyForecast])
}
