//
//  HomeViewController.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    var viewModel: HomeViewModel?
    private var headerView: HomeHeaderView?
    private var dailyForecasts: [DailyForecast] = []
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        viewModel?.fetchForecast()
        viewModel?.cellData()
            .drive(tableView.rx.items(
                cellIdentifier: WeatherCell.reuseIdentifier,
                cellType: WeatherCell.self
            )) { (row, data, cell) in cell.bind(withData: data) }
            .disposed(by: disposeBag)
        
        viewModel?.headerData()
            .drive(onNext: { [weak self] data in
                guard let data = data else { return }
                self?.headerView?.bind(withData: data)
                self?.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel?.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.tableView.isHidden = isLoading
                isLoading ? self?.loader.startAnimating() : self?.loader.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.registerNib(WeatherCell.self)
        setupTableHeaderView()
        setupTableRefreshControl()
        tableView.rx.itemSelected.subscribe { [weak self] item in
            guard let row = item.element?.row else { return }
            self?.viewModel?.showDetailView(forRow: row)
        }.disposed(by: disposeBag)
    }
    
    private func setupTableHeaderView() {
        headerView = HomeHeaderView.loadFromNib()
        tableView.tableHeaderView = headerView
    }
    
    private func setupTableRefreshControl() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in self?.viewModel?.fetchForecast(isPullToRefresh: true) })
            .disposed(by: disposeBag)
        
    }
}
