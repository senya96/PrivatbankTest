//
//  UIView+firstResponder.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
