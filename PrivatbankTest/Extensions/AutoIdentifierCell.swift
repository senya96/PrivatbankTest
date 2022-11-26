//
//  AutoIdentifierCell.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

/// Protocol for cell identifying easier.
public protocol AutoIndentifierCell: AnyObject {
    static var identifier: String { get }
    static var nibName: String { get }
    
    static func register(in view:UITableView?)
}

//MARK: - UITableViewCell
public extension AutoIndentifierCell where Self: UITableViewCell {
    
    static var identifier: String {
        return self.nibName
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static func register(in view:UITableView?) {
        view?.register(UINib(nibName: self.nibName, bundle: nil), forCellReuseIdentifier: self.identifier)
    }
}
