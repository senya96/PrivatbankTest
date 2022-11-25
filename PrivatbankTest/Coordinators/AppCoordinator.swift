//
//  AppCoordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit


class AppCoordinator {
    
    static var window: UIWindow?
    
    static func start() {
        showMain()
    }
}


extension AppCoordinator {
    
    private static func showMain() {
        guard let window = window else {
            fatalError("Need window to present flow")
        }
        let navC = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: navC)
        mainCoordinator.setupRoot()
        mainCoordinator.start()
        window.rootViewController = navC
        window.makeKeyAndVisible()
    }
}
