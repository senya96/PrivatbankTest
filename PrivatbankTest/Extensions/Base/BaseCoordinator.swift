//
//  BaseCoordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var rootViewController: UIViewController
    var childCoordinators: [Coordinator] = []
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        rootViewController = UIViewController()
    }
    
    func start() {
        navigationController.pushViewController(rootViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
