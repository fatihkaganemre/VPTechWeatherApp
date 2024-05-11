//
//  HomeHeaderView.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import UIKit

struct HomeHeaderData {
    let name: String?
    let temperature: String?
    let description: String?
    let maxTemperature: String?
    let minTemperature: String?
}

class HomeHeaderView: UIView, NibInstantiatable {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var highAndLowTemperatureLabel: UILabel!
    
    func bind(withData data: HomeHeaderData) {
        nameLabel.text = data.name
        temperatureLabel.text = data.temperature
        descriptionLabel.text = data.description
        if let max = data.maxTemperature, let min = data.minTemperature {
            highAndLowTemperatureLabel.text = "H:\(max) - L:\(min)"
        }
    }
}
