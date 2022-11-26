//
//  MovieListViewController.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

final class MovieListViewController: BaseViewController {
    var viewModel: MovieListViewModel?
    
    @IBOutlet private weak var tableView: PaginatedTableView?
    @IBOutlet private weak var nothingToShowL: UILabel?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for movies..."
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.becomeFirstResponder()
        bindViewModel()
    }
}

private extension MovieListViewController {
    func setupTableView() {
        tableView?.paginatedDelegate = self
        tableView?.paginatedDataSource = self
        MovieCell.register(in: tableView)
    }
    
    func bindViewModel() {
        viewModel?.movies.bind { [weak self] movies in
            self?.tableView?.reloadData()
        }
    }
}



extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        
        viewModel?.search(query: text) { [weak self] error in
            self?.showErrorAlert(with: error)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel?.clearResults()
        }
    }
}

extension MovieListViewController: StoryboardInstantiable {
    static var storyboardName: String {
        Storyboard.movies.rawValue
    }
}


// MARK: - PaginatedTableViewDelegate

extension MovieListViewController: PaginatedTableViewDelegate {
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: @escaping (Bool) -> Void, onError: @escaping (Error) -> Void) {
        viewModel?.getNextPage { success, error in
            onSuccess(success)
            if let error = error {
                onError(error)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        PaginatedTableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movies = viewModel?.movies.value, movies.indices.contains(indexPath.row) else { return }
        viewModel?.openMovie(movies[indexPath.row])
    }
}

// MARK: - PaginatedTableViewDataSource
extension MovieListViewController: PaginatedTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = viewModel?.movies.value.count ?? 0
        tableView.isHidden = numberOfRows == 0
        nothingToShowL?.isHidden = numberOfRows != 0
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movies = viewModel?.movies.value, movies.indices.contains(indexPath.row) else {
            return UITableViewCell()
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell {
            cell.commonInit(movies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension MovieListViewController {
    func showErrorAlert(with error: Error?) {
        guard let error = error else { return }
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
