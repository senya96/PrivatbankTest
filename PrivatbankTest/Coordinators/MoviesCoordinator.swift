//
//  MoviesCoordinator.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class MoviesCoordinator: BaseCoordinator {
    var onComplete: (()->())?
    
}

extension MoviesCoordinator: CoordinatorSetupable {
    
    func setupRoot() {
        if let mainViewController = MovieListViewController.storyboardInstance() {
            mainViewController.viewModel = MovieListViewModel(coordinator: self)
            rootViewController = mainViewController
        }
    }
}

//MARK: - API
extension MoviesCoordinator {
    public func search(query: String, page: Int = 1, completion: @escaping (Result<SearchMovieResponseObject, Error>) -> Void) {
        APIManager.Movies.search(query: query, page: page, completion: completion)
    }
}
