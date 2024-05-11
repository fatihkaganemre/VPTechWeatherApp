//
//  Wind.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

struct Wind: Decodable {
    let speed: Float
    let deg: Int
    let gust: Float
}
