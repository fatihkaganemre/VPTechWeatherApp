//
//  DependencyMocks.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 12/05/2024.
//

import Foundation
import RxSwift
import RxCocoa
@testable import VPTechWeatherApp

class FormatterMock: FormatterProtocol {
    var formatTemperatureResult: String = ""
    var foratTemperatureCallCounter: Int = 0
    func format(temperature: Double) -> String {
        foratTemperatureCallCounter += 1
        return formatTemperatureResult
    }
}

class NetworkServiceMock: NetworkServiceProtocol {
    var getForecastCallCounter: Int = 0
    var getForecastInputCity: String = ""
    var getForecastResult = PublishRelay<Forecast>()
    func getForecast(forCity city: String) -> Observable<Forecast> {
        getForecastInputCity = city
        getForecastCallCounter += 1
        return getForecastResult.asObservable()
    }
}

class CalendarProviderMock: CalendarProviderProtocol {
    var getComponentCallCounter: Int = 0
    var getComponentResult: Int = 0
    func getComponent(_ component: Calendar.Component, fromDate date: Date) -> Int {
        getComponentCallCounter += 1
        return getComponentResult
    }
    
    
}
