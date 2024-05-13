//
//  ImageUrlProvider.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 13/05/2024.
//

import Foundation

struct ImageUrlProvider {
    static func getImageUrl(_ imageName: String?) -> URL? {
        guard let name = imageName else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(name)@2x.png")
    }
}
