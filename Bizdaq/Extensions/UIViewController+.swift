//
//  UIViewController+.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func show(navigationBar: Bool, animated: Bool) {
        navigationController?.setNavigationBarHidden(!navigationBar, animated: animated)
    }
    
    func show(backButton: Bool, animated: Bool) {
        navigationItem.setHidesBackButton(!backButton, animated: animated)
    }
    
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        UIApplication.shared.statusBarStyle = style
    }
    
    func alert(title: String = "", message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func hideKeyboardWhenTappedOnView(specificView: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        specificView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }}
