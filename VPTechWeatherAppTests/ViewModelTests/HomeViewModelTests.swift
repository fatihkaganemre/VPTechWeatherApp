//
//  HomeViewModelTests.swift
//  VPTechWeatherAppTests
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import XCTest
import RxSwift
import RxTest
import RxCocoa
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
        // given
        let sut = makeSut()
        
        // when
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(networkService.getForecastInputCity, "Paris")
        XCTAssertEqual(networkService.getForecastCallCounter, 1)
    }
    
    func test_whenSubscribedToHomeViewCellDatas_shouldCallGetForecast() {
        // given
        let sut = makeSut()
        
        // when
        sut.homeViewData.cellDatas.drive().disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(networkService.getForecastCallCounter, 1)
    }
    
    func test_whenSubscribedMultipleTimes_shouldCallGetForecastOnlyOnce() {
        // given
        let sut = makeSut()
        
        // when
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        sut.homeViewData.cellDatas.drive().disposed(by: disposeBag)
        
        // then
        XCTAssertEqual(networkService.getForecastCallCounter, 1)
    }
    
    func test_whenForecastFetched_shouldShowHeaderData() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let givenForecast = Forecast.mock()
        let headerDataObserver = scheduler.createObserver(HomeHeaderData?.self)
        
        // when
        sut.homeViewData.headerData
            .asObservable()
            .bind(to: headerDataObserver)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.next(1, Forecast.mock())])
            .bind(to: networkService.getForecastResult)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        XCTAssertEqual(
            headerDataObserver.events,
            [.next(1, HomeHeaderData(
                name: "",
                imageURL: nil,
                temperature: "",
                description: "",
                maxTemperature: "",
                minTemperature: ""
            ))]
        )
    }
    
    func test_whenForecastFetched_shouldStopLoading() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let givenForecast = Forecast.mock()
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        // when
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        sut.homeViewData.isLoading
            .asObservable()
            .bind(to: isLoadingObserver)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.next(1, Forecast.mock())])
            .bind(to: networkService.getForecastResult)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        XCTAssertEqual(isLoadingObserver.events, [.next(0, true), .next(1, false)])
    }
    
    func test_whenForecastFetched_shouldShowWeatherCells() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let givenForecast = Forecast.mock()
        let cellDatasObserver = scheduler.createObserver([WeatherCellData].self)
        
        // when
        sut.homeViewData.cellDatas
            .asObservable()
            .bind(to: cellDatasObserver)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.next(1, Forecast.mock())])
            .bind(to: networkService.getForecastResult)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        guard let event = cellDatasObserver.events.first else {
            XCTFail("no event")
            return
        }
        
        XCTAssertEqual(event.time, 1)
        XCTAssertEqual(event.value.element?.count, 1)
        XCTAssertEqual(event.value.element?.first?.imageURL, nil)
        XCTAssertEqual(event.value.element?.first?.minTemperature, "")
        XCTAssertEqual(event.value.element?.first?.maxTemperature, "")
    }
    
    func test_whenFetchForecastFailed_shouldShowAlert() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let outputObserver = scheduler.createObserver(HomeViewModelOutput.self)
        
        // when
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        sut.output
            .asObservable()
            .bind(to: outputObserver)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.error(1, TestError.any)])
            .bind(to: networkService.getForecastResult)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        guard let event = outputObserver.events.first else {
            XCTFail("no event")
            return
        }
        XCTAssertEqual(event.time, 1)
        XCTAssertEqual(event.value.element?.isAlert, true)
    }
    
    func test_WhenFetchForecastFailed_shouldStopLoading() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let givenForecast = Forecast.mock()
        let isLoadingObserver = scheduler.createObserver(Bool.self)
        
        // when
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        sut.homeViewData.isLoading
            .asObservable()
            .bind(to: isLoadingObserver)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.error(1, TestError.any)])
            .bind(to: networkService.getForecastResult)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        XCTAssertEqual(isLoadingObserver.events, [.next(0, true), .next(1, false)])
    }
    
    func test_whenDailyForecastSelected_shouldShowDetailView() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let givenForecast = Forecast.mock()
        let outputObserver = scheduler.createObserver(HomeViewModelOutput.self)
        
        // when
        sut.homeViewData.headerData.drive().disposed(by: disposeBag)
        sut.homeViewData.cellDatas.drive().disposed(by: disposeBag)
        sut.output
            .asObservable()
            .bind(to: outputObserver)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.next(1, Forecast.mock())])
            .bind(to: networkService.getForecastResult)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.next(2, 0)])
            .bind(to: sut.homeViewData.selectedItem)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // then
        guard let event = outputObserver.events.first else {
            XCTFail("no event")
            return
        }
        XCTAssertEqual(event.time, 2)
        XCTAssertEqual(event.value.element?.isDetails, true)
    }
    
    func test_whenPullToRefresh_shouldCallGetForecast() {
        // given
        let sut = makeSut()
        let scheduler = TestScheduler(initialClock: 0)
        let givenForecast = Forecast.mock()
        let pullToRefresh = scheduler.createObserver(Void.self)
        
        // when
        sut.homeViewData.pullToRefresh
            .asObservable()
            .bind(to: pullToRefresh)
            .disposed(by: disposeBag)
        
        scheduler
            .createColdObservable([.next(1, ())])
            .bind(to: pullToRefresh)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
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
