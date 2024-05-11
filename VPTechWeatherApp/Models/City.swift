//
//  City.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coordinate?
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Date
    let sunset: Date
}
