//
//  DetailHeaderView.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 11/05/2024.
//

import UIKit

struct DetailHeaderData {
    let imageURL: URL?
    let temperature: String
    let feelsLike: String
    let maxTemperature: String?
    let minTemperature: String?
    let description: String?
    let wind: String
    let humidity: String
    let pressure: String
    let perception: String
}

class DetailHeaderView: UIView, NibInstantiatable {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var highAndLowTemperatureLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var perceptionLabel: UILabel!
    
    func bind(withData data: DetailHeaderData) {
        temperatureLabel.text = data.temperature
        feelsLikeLabel.text = "Feels like \(data.feelsLike)"
        descriptionLabel.text = data.description
        windLabel.text = "Wind speed: \(data.wind) mph"
        humidityLabel.text = "Humidity: %\(data.humidity)"
        pressureLabel.text = "Pressure: \(data.pressure) hPa"
        perceptionLabel.text = "Perception: %\(data.perception)"
        
        if let max = data.maxTemperature, let min = data.minTemperature {
            highAndLowTemperatureLabel.text = "H:\(max) - L:\(min)"
        }
        if let imageURL = data.imageURL {
            imageView.downloaded(from: imageURL)
        }
    }
}
