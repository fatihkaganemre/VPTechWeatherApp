//
//  Formatter.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

protocol FormatterProtocol {
    func format(temperature: Double) -> String
}

struct Formatter: FormatterProtocol {
    private let formatter: MeasurementFormatter
    
    init(formatter: MeasurementFormatter = .init()) {
        self.formatter = formatter
    }
    
    func format(temperature: Double) -> String {
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter.string(from: measurement)
    }
}
