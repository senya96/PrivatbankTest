//
//  UIViewController+keyboard.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        navigationController?.navigationBar.topItem?.titleView?.endEditing(true)
    }
}
