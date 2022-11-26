//
//  MovieListViewController.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class MovieListViewController: BaseViewController {
    var viewModel: MovieListViewModel?
    
    @IBOutlet private weak var tableView: PaginatedTableView?
    
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
    
    private func setupTableView() {
        tableView?.paginatedDelegate = self
        tableView?.paginatedDataSource = self
        MovieCell.register(in: tableView)
    }
    
    private func bindViewModel() {
        viewModel?.movies.bind { [weak self] movies in
            print("Movies: \(movies.count)")
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
        
        viewModel?.search(query: text)
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
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: @escaping (Bool) -> Void, onError: ((Error) -> Void)?) {
        viewModel?.getNextPage(completion: onSuccess)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        PaginatedTableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PaginatedTableViewDataSource
extension MovieListViewController: PaginatedTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movies.value.count ?? 0
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
