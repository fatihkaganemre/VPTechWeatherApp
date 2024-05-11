//
//  CalendarService.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 11/05/2024.
//

import Foundation

protocol CalendarProviderProtocol {
    func getComponent(_ component: Calendar.Component, fromDate date: Date) -> Int
}

struct CalendarProvider: CalendarProviderProtocol {
    private let calendar: Calendar
    
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    
    func getComponent(_ component: Calendar.Component, fromDate date: Date) -> Int {
        Calendar.current.component(component, from: date)
    }
}
