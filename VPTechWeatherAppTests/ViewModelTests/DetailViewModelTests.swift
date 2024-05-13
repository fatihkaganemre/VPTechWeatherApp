//
//  DetailViewModelTests.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import XCTest
@testable import VPTechWeatherApp

class DetailViewModelTests: XCTestCase {
    private var formatter: FormatterMock!
    
    override func setUp() {
        super.setUp()
        formatter = FormatterMock()
    }
    
    func test_againstMemoryLeak() {
        // given
        var sut: DetailViewModel? = makeSut()
        weak var weakSut: DetailViewModel? = sut
        
        // when
        sut = nil
        
        // then
        XCTAssertNil(weakSut)
    }
    
    func test_whenGivenDailyForecasts_shouldDisplayHeaderData() {
        // given
        formatter.formatTemperatureResult = "formattedText"
        let givenWeather: [Weather] = [.mock(icon: "icon", description: "description")]
        let givenMain: Main = .mock(pressure: 1, humidity: 1)
        let givenWind: Wind = .mock(speed: 123.0)
        let givenPop = 0.02
        let givenForecast: DailyForecast = .mock(
            date: .init(timeIntervalSince1970: 0),
            main: givenMain,
            weather: givenWeather,
            wind: givenWind,
            pop: givenPop
        )
        let sut = makeSut(forecasts: [givenForecast])
        
        // when
        guard let headerData = sut.headerData() else {
            XCTFail("No header data")
            return
        }
        
        // then
        guard let imageUrl = headerData.imageURL else {
            XCTFail("No image url")
            return
        }
        
        XCTAssertEqual(imageUrl.description, "https://openweathermap.org/img/wn/icon@2x.png")
        XCTAssertEqual(headerData.temperature, "formattedText")
        XCTAssertEqual(headerData.feelsLike, "formattedText")
        XCTAssertEqual(headerData.maxTemperature, "formattedText")
        XCTAssertEqual(headerData.minTemperature, "formattedText")
        XCTAssertEqual(headerData.description, "Description")
        XCTAssertEqual(headerData.wind, "123.0")
        XCTAssertEqual(headerData.humidity, "1")
        XCTAssertEqual(headerData.pressure, "1")
        XCTAssertEqual(headerData.perception, "2" )
    }
    
    func test_whenGivenDailyForecasts_shouldDisplayCells() {
        // given
        formatter.formatTemperatureResult = "formattedText"
        let givenWeather: [Weather] = [.mock(icon: "icon")]
        let givenMain: Main = .mock(temp_min: 1, temp_max: 1)
        let givenForecast: DailyForecast = .mock(
            date: .init(timeIntervalSince1970: 0), // "1 January 1970 at 1:00:00 CET"
            main: givenMain,
            weather: givenWeather
        )
        let sut = makeSut(forecasts: [givenForecast])
        
        // when
        let cellDatas = sut.cellDatas
        
        // then
        guard let imageUrl = cellDatas.first?.imageURL else {
            XCTFail("No image url")
            return
        }
        XCTAssertEqual(cellDatas.count, 1)
        XCTAssertNotNil(cellDatas.first?.date)
        XCTAssertEqual(cellDatas.first?.maxTemperature, "formattedText")
        XCTAssertEqual(cellDatas.first?.minTemperature, "formattedText")
        XCTAssertEqual(imageUrl.description, "https://openweathermap.org/img/wn/icon@2x.png")
    }
    
    private func makeSut(forecasts: [DailyForecast] = [.mock()]) -> DetailViewModel {
        return .init(
            forecasts: forecasts,
            formatter: formatter
        )
    }
}
