//
//  Coordinator.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 11/05/2024.
//

import UIKit

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
    
    init(navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showHomeView() {
        let viewModel = HomeViewModel(coordinator: self)
        let controller: HomeViewController = UIStoryboard.main.instantiateViewController()
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: false)
    }

    func showDetailView(withForecasts forecasts: [DailyForecast]) {
        let viewModel = DetailViewModel(forecasts: forecasts)
        let controller: DetailViewController = UIStoryboard.main.instantiateViewController()
        controller.viewModel = viewModel
        navigationController.pushViewController(controller, animated: true)
    }
    
    func showAlert(viewModel: AlertViewModel) {
        var alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: viewModel.style)
        viewModel.actions.forEach { action in
            let action = UIAlertAction(title: action.title, style: action.style, handler: { _ in action.onTapped?() })
            alertController.addAction(action)
        }
        navigationController.present(alertController, animated: true)
    }
}
