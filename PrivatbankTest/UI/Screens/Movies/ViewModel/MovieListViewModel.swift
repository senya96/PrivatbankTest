//
//  MovieListViewModel.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

class MovieListViewModel: BaseViewModel<MoviesCoordinator> {
    public var movies: Dynamic<[MovieObject]> = Dynamic([])
    public var currentPage: Int = 0
    public var isLastPage = false
    private var currentQuery: String = ""
    
    public func search(query: String, onError: @escaping (_ error: Error?) -> Void) {
        currentPage = 1
        isLastPage = false
        movies.value = []
        currentQuery = query
        coordinator.search(query: query) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.movies.value = response.results ?? []
                strongSelf.isLastPage = response.totalPages == strongSelf.currentPage
            case .failure(let error):
                onError(error)
            }
        }
    }
    
    public func getNextPage(completion: @escaping (_ hasMoreData: Bool, _ error: Error?) -> Void) {
        guard !isLastPage, !currentQuery.isEmpty else {
            completion(false, nil)
            return
        }
        
        coordinator.search(query: currentQuery, page: currentPage + 1) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                self?.currentPage += 1
                strongSelf.movies.value += response.results ?? []
                strongSelf.isLastPage = response.totalPages == strongSelf.currentPage
                var hasMoreData = false
                if let page = response.page, let totalPages = response.totalPages {
                    hasMoreData = page < totalPages
                }
                completion(hasMoreData, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    public func clearResults() {
        currentPage = 0
        isLastPage = false
        currentQuery = ""
        movies.value = []
    }
    
    public func openMovie(_ movie: MovieObject) {
        coordinator.openMovie(movie)
    }
}
