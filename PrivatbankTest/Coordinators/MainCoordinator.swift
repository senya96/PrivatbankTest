//
//  MainCoordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    var onComplete: (()->())?
    
}

extension MainCoordinator: CoordinatorSetupable {
    
    func setupRoot() {
        if let mainViewController = MainViewController.storyboardInstance() {
            mainViewController.viewModel = MainViewModel(coordinator: self)
            rootViewController = mainViewController
        }
    }
}
