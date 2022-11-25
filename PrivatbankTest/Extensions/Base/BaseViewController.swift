//
//  BaseViewController.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet private(set) weak var scrollView: UIScrollView?
    private var scrollViewContentOffset: CGPoint?
    
    var onNavigateBack: (() -> Void)?
    var onWillStartPresenting: (() -> Void)?
    var onDidStartPresenting: (() -> Void)?
    var onFinishPresenting: (() -> Void)?
    var onDidLoad: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDidLoad?()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        onWillStartPresenting?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onDidStartPresenting?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onFinishPresenting?()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction internal func onNavigateBackDidTap(_ sender: AnyObject?) {
        onNavigateBack?()
    }
    
    func getActiveField() -> UIView? {
        return view.window?.firstResponder
    }
}

private extension BaseViewController {
    
    func subscribeToKeyboardNotifications() {
        // Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        // Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        // Need to calculate keyboard exact size due to Apple suggestions
        guard let scrollView = scrollView else {return}
        guard let info: NSDictionary = notification.userInfo as NSDictionary? else {return}
        scrollViewContentOffset = scrollView.contentOffset
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize?.height ?? 0.0, right: 0.0)

        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var aRect: CGRect = view.frame
        aRect.size.height -= keyboardSize?.height ?? 0
        if let activeFieldPresent = getActiveField(), let origin = activeFieldPresent.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: scrollView)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            scrollView.scrollRectToVisible(CGRect(x: childStartPoint.x, y: childStartPoint.y, width: activeFieldPresent.frame.width, height: activeFieldPresent.frame.height), animated: true)
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {
        // Once keyboard disappears, restore original positions
        guard let scrollView = scrollView else {return}
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        if let contentOffset = scrollViewContentOffset, scrollView.contentSize.height > scrollView.frame.size.height {
            scrollView.setContentOffset(contentOffset, animated: true)
        }
        scrollViewContentOffset = nil

    }
}
