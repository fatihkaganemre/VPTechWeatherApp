//
//  Main.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Float
}
