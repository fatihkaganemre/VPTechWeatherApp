//
//  NetworkError.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case wrongRequest
    case decodingError(Error)
    case requestFailed(Error)
}
