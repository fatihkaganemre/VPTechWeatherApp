//
//  Weather.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
