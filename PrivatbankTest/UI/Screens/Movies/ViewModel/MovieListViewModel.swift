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
    
    public func search(query: String) {
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
                fatalError("API ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    public func getNextPage(completion: @escaping (_ success: Bool) -> Void) {
        guard !isLastPage, !currentQuery.isEmpty else {
            completion(true)
            return
        }
        currentPage += 1
        
        coordinator.search(query: currentQuery, page: currentPage) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                strongSelf.movies.value += response.results ?? []
                strongSelf.isLastPage = response.totalPages == strongSelf.currentPage
                completion(true)
            case .failure(let error):
                completion(false)
                fatalError("API ERROR: \(error.localizedDescription)")
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
