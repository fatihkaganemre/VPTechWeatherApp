//
//  CommonMocks.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 13/05/2024.
//

import Foundation
@testable import VPTechWeatherApp

enum TestError: Error {
    case any
}

extension HomeViewModelOutput {
    var isDetails: Bool {
        switch self {
            case .details: return true
            default: return false
        }
    }
    
    var isAlert: Bool {
        switch self {
            case .alert: return true
            default: return false
        }
    }
}
