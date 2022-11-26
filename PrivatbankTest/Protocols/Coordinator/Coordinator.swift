//
//  Coordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController {get set}
    var rootViewController: UIViewController {get}
    var childCoordinators: [Coordinator] {get set}
    
    init(navigationController: UINavigationController)
    func start()
}
