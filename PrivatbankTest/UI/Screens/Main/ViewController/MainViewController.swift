//
//  MainViewController.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class MainViewController: BaseViewController {
    var viewModel: MainViewModel?
    
    @IBOutlet private weak var tableView: UITableView?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for movies..."
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
}



extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        
//        viewModel?.searchUsers(query: text)
    }
}

extension MainViewController: StoryboardInstantiable {
    static var storyboardName: String {
        Storyboard.main.rawValue
    }
}
