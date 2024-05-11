//
//  DetailViewController.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var headerBackgroundView: UIView!
    var viewModel: DetailViewModel?
    private var headerView: DetailHeaderView!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupHeaderView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.registerNib(WeatherCell.self)
    }
    
    private func setupHeaderView() {
        headerView = DetailHeaderView.loadFromNib()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerBackgroundView.addSubview(headerView)
        if let data = viewModel?.headerData() {
            headerView.bind(withData: data)
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: headerBackgroundView.topAnchor, constant: 16),
            headerView.bottomAnchor.constraint(equalTo: headerBackgroundView.bottomAnchor, constant: -16),
            headerView.leadingAnchor.constraint(equalTo: headerBackgroundView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: headerBackgroundView.trailingAnchor, constant: -16),
        ])
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellDatas.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: WeatherCell  = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let data = viewModel?.cellDatas[indexPath.row] {
            cell.bind(withData: data)
        }
        return cell
    }
}

