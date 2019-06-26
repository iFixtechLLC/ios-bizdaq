//
//  ForgotPasswordViewController.swift
//  Bizdaq
//
//  Created by App Dev on 12/06/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//
import Foundation
import UIKit
import RxSwift
import RxCocoa


class ForgotPasswordViewController: UIViewController, Modelled, Binds {
    @IBOutlet weak var emailField: ValidatedTextField!
    private var viewModel: ForgotPasswordViewModel?
    @IBOutlet weak var submitBtn: UIButton!
    var emailValid:Bool = false
    var apiClient: APIClient?
    
    
    // MARK: - Lifecycle
    func attach(to viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        apiClient = APIClient(httpClient: HTTPClient.shared)
        emailField.setValidationRegex(Constants.Validation.emailRegex)
        emailField.setPlaceholder(Lexicon.Login.emailPlaceholder)
        style()
    }
    // MARK: - Binding
    func bind(to viewModel: ForgotPasswordViewModel) {
        viewModel.setEmailValid(driver: emailField.isValidatedDriver)
    }
    
    
    private func style() {
        submitBtn.style(rounded: true)
        setStatusBarStyle(.lightContent)
        navigationController?.navigationBar.style()
        
    }
  
    @IBAction func recoverBtn(_ sender: Any) {
        let pum = PopupManager()

        viewModel?.attemptSubmiy(email: emailField.textField.text!, success: { [weak self] (success, error) in
            if success {
                pum.presentSimplePopup(then: {
                    self?.navigationController?.popViewController(animated: false)
                }, title: "Email sent", description: "Please follow instructions in the email")
            } else {
                guard let error = error as? HTTPClient.HTTPClientError else {
                    self?.alert(message: Lexicon.Error.unknownError, handler: nil)
                    return
                }
            }
        })
    }
    
    
    
}




