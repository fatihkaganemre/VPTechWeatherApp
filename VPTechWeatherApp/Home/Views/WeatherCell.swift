//
//  WeatherCell.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 10/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

struct WeatherCellData: Equatable {
    let date: String?
    let imageURL: URL?
    let minTemperature: String?
    let maxTemperature: String?
}

class WeatherCell: UITableViewCell, Reusable {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var highAndLowTemperatureLabel: UILabel!
    
    func bind(withData data: WeatherCellData) {
        dateLabel.text = data.date
        if let imageURL = data.imageURL {
            weatherImage.load(url: imageURL)
        }
        
        if let max = data.maxTemperature, let min = data.minTemperature {
            highAndLowTemperatureLabel.text = "H:\(max) - L:\(min)"
        }
    }
}
