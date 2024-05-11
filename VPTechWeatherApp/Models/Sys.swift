//
//  Sys.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import Foundation

struct Sys: Decodable {
    let pod: DayPart
    
    enum DayPart: String, Decodable {
        case day = "d"
        case night = "n"
    }
}
