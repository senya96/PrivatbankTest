//
//  PaginatedTableView.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit
import Foundation

// MARK: - PaginatedTableView DataSource

@objc public protocol PaginatedTableViewDataSource: AnyObject {
    func numberOfSections(in tableView: UITableView) -> Int
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    @objc optional func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    @objc optional func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
}

// MARK: - PaginatedTableView Delegate

@objc public protocol PaginatedTableViewDelegate: AnyObject {
    func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: @escaping (Bool) -> Void, onError: @escaping (Error) -> Void)
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
}

// MARK: - A wrapper around table view to make pagination easier and reuseable.

public class PaginatedTableView: UITableView {
    
    // Infinite scrolling
    // Page size can be changed from view controller as well
    public var pageSize = 20
    private var hasMoreData = true
    private(set) var currentPage = 1
    private(set) var isLoading = false
    
    // First page can vary for different APIs thus can be changed from the VC
    public var firstPage = 1
    
    // Table view settings
    private var sections = 0
    public var loadMoreViewHeight: CGFloat = automaticDimension
    public var heightForHeaderInSection: CGFloat = 0
    public var titleForHeaderInSection = ""
    
    // Only delegates you want to assign value to while using this wrapper
    weak open var paginatedDelegate: PaginatedTableViewDelegate?
    weak open var paginatedDataSource: PaginatedTableViewDataSource?
    
    // custom refresh logic after data is loaded, when you do not
    // want to call tableView.reloadData() and want to refresh
    // certain sections instead
    public var customReloadDataBlock: (() -> Void)?
    
    // initWithFrame to init view from code
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // common func to init our view
    private func setupView() {
        self.delegate = self
        self.dataSource = self
        self.prefetchDataSource = self
        self.alwaysBounceVertical = true
        
        // register load more cell
        self.register(LoadMoreCell.self, forCellReuseIdentifier: LoadMoreCell.identifier)
    }
}

// MARK: - PaginatedTableView Delegates and Data Source methods

extension PaginatedTableView: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return item for loader in case of last section
        if section == sections - 1 {
            // always have 1 row for the loader section - hide it using a zero height in
            // heightForRowAt:
            return 1
        } else {
            return paginatedDataSource?.tableView(tableView, numberOfRowsInSection: section) ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If it is loading section
        if indexPath.section == sections - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadMoreCell.identifier, for: indexPath) as? LoadMoreCell else {
                fatalError("The dequeued cell is not an instance of LoadMoreCell.")
            }
            cell.activityIndicator.hidesWhenStopped = true
            if self.isLoading {
                cell.activityIndicator.startAnimating()
            } else {
                cell.activityIndicator.stopAnimating()
            }
            return cell
        } else {
            // return whatever cells user wants to
            return paginatedDataSource?.tableView(tableView, cellForRowAt: indexPath) ?? UITableViewCell()
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return paginatedDelegate?.tableView?(tableView, estimatedHeightForRowAt: indexPath) ?? estimatedRowHeight
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        paginatedDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        paginatedDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // Add one section for loader
        sections = 1
        
        // Add sections to one for loader
        if let numberOfSections = paginatedDataSource?.numberOfSections(in: tableView) {
            sections += numberOfSections
        }
        return sections
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return paginatedDelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paginatedDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeaderInSection
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return paginatedDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? heightForHeaderInSection
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == sections - 1 {
            // the section that has the loading indicator
            let isRefreshing = refreshControl?.isRefreshing ?? false
            if !isRefreshing && self.isLoading {
                return loadMoreViewHeight
            }
            return 0.0
        }
        return paginatedDelegate?.tableView(tableView, heightForRowAt: indexPath) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        paginatedDataSource?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return paginatedDataSource?.tableView?(tableView, editingStyleForRowAt: indexPath) ?? .none
    }
}

// MARK: - PaginatedTableView prefetching data source

extension PaginatedTableView: UITableViewDataSourcePrefetching {
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.section == sections - 1 }) {
            load()
        }
    }
}

// MARK: - PaginatedTableView helper functions

extension PaginatedTableView {
    
    public func loadData(refresh: Bool = false) {
        load(refresh: refresh)
    }
    
    @objc fileprivate func handleRefreshtableView(_ refreshControl: UIRefreshControl) {
        load(refresh: true)
    }
    
    // All loading logic goes here i.e. showing/hiding of loaders and pagination
    private func load(refresh: Bool = false) {
        
        // reset page number if refresh
        if refresh {
            currentPage = firstPage
            hasMoreData = true
        }
        
        // return if already loading or dont have any more data
        if !hasMoreData || isLoading { return }
        
        // start loading
        isLoading = true
        paginatedDelegate?.loadMore(currentPage, pageSize, onSuccess: { hasMore in
            self.hasMoreData = hasMore
            self.currentPage += 1
            self.isLoading = false
            if self.customReloadDataBlock != nil {
                self.customReloadDataBlock?()
            } else {
                self.reloadData()
            }
        }, onError: { _ in
            self.isLoading = false
        })
    }
    
    // Scroll to end detector
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            load()
        }
        
        paginatedDelegate?.scrollViewDidScroll?(scrollView)
    }
}
