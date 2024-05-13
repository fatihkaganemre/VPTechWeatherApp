//
//  HomeViewModelTests.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import XCTest
@testable import VPTechWeatherApp

class HomeViewModelTests: XCTestCase {
    private var networkService: NetworkServiceMock!
    private var formatter: FormatterMock!
    private var calendar: CalendarProviderMock!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkServiceMock()
        formatter = FormatterMock()
        calendar = CalendarProviderMock()
    }
    
    override func tearDown() {
        super.tearDown()
        networkService = nil
        formatter = nil
        calendar = nil
        super.tearDown()
    }
    
    func test_againstMemoryLeak() {
        // given
        var sut: HomeViewModel? = makeSut()
        weak var weakSut: HomeViewModel? = sut
        
        // when
        sut = nil
        
        // then
        XCTAssertNil(weakSut)
    }
    
    func test_whenInitialized_shouldCallGetForecast() {
        // when
        let sut = makeSut()
        
        // then
        XCTAssertEqual(networkService.getForecastCallCounter, 1)
        
    }
    
    private func makeSut() -> HomeViewModel {
        .init(
            networkService: networkService,
            formatter: formatter,
            calendar: calendar
        )
    }
}
