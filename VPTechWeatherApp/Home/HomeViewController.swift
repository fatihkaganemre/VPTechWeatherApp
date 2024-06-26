//
//  HomeViewController.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import UIKit
import RxCocoa
import RxSwift

struct HomeViewData {
    let isLoading: Driver<Bool>
    let headerData: Driver<HomeHeaderData?>
    let cellDatas: Driver<[WeatherCellData]>
    let selectedItem: PublishRelay<Int>
    let pullToRefresh: PublishRelay<Void>
}

class HomeViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    var viewModel: HomeViewModelProtocol!
    private var headerView: HomeHeaderView?
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

        viewModel.homeViewData.cellDatas
            .drive(tableView.rx.items(
                cellIdentifier: WeatherCell.reuseIdentifier,
                cellType: WeatherCell.self
            )) { (row, data, cell) in cell.bind(withData: data) }
            .disposed(by: disposeBag)
        
        viewModel.homeViewData.headerData
            .drive(onNext: { [weak self] data in 
                self?.headerView?.isHidden = data == nil
                guard let data = data else { return }
                self?.headerView?.bind(withData: data)
            })
            .disposed(by: disposeBag)
        
        viewModel.homeViewData.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.tableView.isHidden = isLoading
                if isLoading {
                    self?.loader.startAnimating()
                } else {
                    self?.loader.stopAnimating()
                    self?.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.registerNib(WeatherCell.self)
        setupTableHeaderView()
        setupTableRefreshControl()
        
        tableView.rx
            .itemSelected
            .map {  $0.row }
            .bind(to: viewModel.homeViewData.selectedItem)
            .disposed(by: disposeBag)
    }
    
    private func setupTableHeaderView() {
        headerView = HomeHeaderView.loadFromNib()
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        headerView?.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
    
    private func setupTableRefreshControl() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { Void() }
            .bind(to: viewModel.homeViewData.pullToRefresh)
            .disposed(by: disposeBag)
        
    }
}
