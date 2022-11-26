//
//  BaseCoordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    public var rootViewController: UIViewController
    public var childCoordinators: [Coordinator] = []
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        rootViewController = UIViewController()
    }
    
    public func start() {
        navigationController.pushViewController(rootViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
