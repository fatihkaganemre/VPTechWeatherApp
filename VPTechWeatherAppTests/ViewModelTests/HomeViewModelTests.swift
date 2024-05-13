//
//  HomeViewModelTests.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import XCTest
import RxSwift
@testable import VPTechWeatherApp

class HomeViewModelTests: XCTestCase {
    private var networkService: NetworkServiceMock!
    private var formatter: FormatterMock!
    private var calendar: CalendarProviderMock!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkServiceMock()
        formatter = FormatterMock()
        calendar = CalendarProviderMock()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        networkService = nil
        formatter = nil
        calendar = nil
        disposeBag = nil
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
    
    func test_whenSubscribedToHomeViewHeaderData_shouldCallGetForecastForParis() {
        // when
        let sut = makeSut()
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(networkService.getForecastInputCity, "Paris")
        XCTAssertEqual(networkService.getForecastCallCounter, 1)
    }
    
    func test_whenSubscribedToHomeViewCellDatas_shouldCallGetForecast() {
        // when
        let sut = makeSut()
        sut.homeViewData.cellDatas.drive().disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(networkService.getForecastCallCounter, 1)
    }
    
    func test_whenForecastFetched_shouldShowHeaderData() {
        
    }
    
    func test_whenForecastFetched_shouldStopLoading() {
        
    }
    
    func test_whenForecastFetched_shouldShowWeatherCells() {
        
    }
    
    func test_whenFetchForecastFailed_shouldShowAlert() {
        
    }
    
    func test_WhenFetchForecastFailed_shouldStopLoading() {
        
    }
    
    func test_whenDailyForecastSelected_shouldShowDetailView() {
        
    }
    
    func test_whenPullToRefresh_shouldCallGetForecast() {
        
    }
    
    func test_whenSubscribedLoader_shouldStartLoading() {
        
    }
    
    private func makeSut() -> HomeViewModel {
        .init(
            networkService: networkService,
            formatter: formatter,
            calendar: calendar
        )
    }
}
