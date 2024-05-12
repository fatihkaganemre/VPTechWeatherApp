//
//  Coordinator.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 11/05/2024.
//

import UIKit
import RxSwift

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
}

protocol AppCoordinatorProtocol {
    func showDetailView(withForecasts forecasts: [DailyForecast])
    func showHomeView()
    func showAlert(viewModel: AlertViewModel)
}

class AppCoordinator: Coordinator, AppCoordinatorProtocol {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dependencies: DependencyContainerProtocol
    private var disposeBag = DisposeBag()
    
    init(navigationController : UINavigationController, dependencies: DependencyContainerProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func showHomeView() {
        let controller = dependencies.makeHomeViewController()
        controller.viewModel?.output.bind(onNext: { [weak self] output in
            switch output {
                case .alert(let alertViewModel): self?.showAlert(viewModel: alertViewModel)
                case .details(forecasts: let forecasts): self?.showDetailView(withForecasts: forecasts)
            }
        }).disposed(by: disposeBag)
        navigationController.pushViewController(controller, animated: false)
    }

    func showDetailView(withForecasts forecasts: [DailyForecast]) {
        let controller = dependencies.makeDetailsViewController(forecasts: forecasts)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showAlert(viewModel: AlertViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: viewModel.style)
        viewModel.actions.forEach { action in
            let action = UIAlertAction(title: action.title, style: action.style, handler: { _ in action.onTapped?() })
            alertController.addAction(action)
        }
        navigationController.present(alertController, animated: true)
    }
}
