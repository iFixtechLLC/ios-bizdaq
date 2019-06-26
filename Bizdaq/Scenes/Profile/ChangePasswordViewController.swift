//
//  ChangePasswordViewController.swift
//  Bizdaq
//
//  Created by App Dev on 12/04/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var newPassword: UITextField!
    var apiClient: APIClient?
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        apiClient = APIClient(httpClient: HTTPClient.shared)

        newPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        
    }

    @IBAction func didPressChangePasswordButton(_ sender: Any) {
        guard let pass1 = newPassword.text else { return }
        guard let pass2 = confirmPassword.text else { return }

        if pass1 != pass2{
            PopupManager().presentSimplePopup(then: {}, title: "Passwords do not match", description: "Please enter matching passwords")
            return
        }
        
        if (pass1.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil) {
            PopupManager().presentSimplePopup(then: {}, title: "Password not strong enough", description: "Passwords need to be at least 1 uppercase character")
            return
        }
        if (pass1.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil) {
            PopupManager().presentSimplePopup(then: {}, title: "Password not strong enough", description: "Passwords need to be at least 1 lowercase character")
            return
        }
        if (pass1.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil) {
            PopupManager().presentSimplePopup(then: {}, title: "Password not strong enough", description: "Passwords need to be at least 1 number")
            return
        }
        if pass1.count < 8 {
            PopupManager().presentSimplePopup(then: {}, title: "Password not strong enough", description: "Passwords need to be at least 8 characters")
            return
        }
        
        let disposeBag = DisposeBag()
        apiClient?.changePassword(authToken: UserSession.shared.authToken!, password: pass1, confirmPassword: pass2).subscribe(onSuccess: { (response) in
            if response.success {
                PopupManager().presentSimplePopup(then: {
                    Menu.shared.menuView?.setProfileAsRoot()
                }, title: "Success", description: response.data.feedback)
            }
        }, onError: { (error) in
            PopupManager().presentSimplePopup(then: {}, title: "Error", description: error.localizedDescription)
            return
        }).disposed(by: disposeBag)
        
        
    }
    

}
