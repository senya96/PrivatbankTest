//
//  AppCoordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit


final class AppCoordinator {
    
    static var window: UIWindow?
    
    public static func start() {
        showMain()
    }
}


private extension AppCoordinator {
    static func showMain() {
        guard let window = window else {
            fatalError("Need window to present flow")
        }
        let navC = UINavigationController()
        let mainCoordinator = MoviesCoordinator(navigationController: navC)
        mainCoordinator.setupRoot()
        mainCoordinator.start()
        window.rootViewController = navC
        window.makeKeyAndVisible()
    }
}
