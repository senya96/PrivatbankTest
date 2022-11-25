//
//  BaseViewModel.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

class BaseViewModel<T: BaseCoordinator> {
    let coordinator: T
    init(coordinator: T) {
        self.coordinator = coordinator
    }
}
