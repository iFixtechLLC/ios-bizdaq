//
//  ModalBuyerRegisterViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ModalBuyerRegisterViewController: RegisterViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: ModalBuyerRegisterViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: ModalBuyerRegisterViewModel) {
        super.attach(to: viewModel)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func register() {
        viewModel!.registerAccount(firstName: firstNameField.textField.text!,
                                   lastName: lastNameField.textField.text!,
                                   mobile: mobileField.textField.text!,
                                   email: emailField.textField.text!,
                                   password: passwordField.textField.text!) { [weak self] (success, error) in
            if success {
                self?.dismiss(animated: true, completion: nil)
            } else {
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                self?.handle(error: error)
            }
        }
    }
    
    private func handle(error: HTTPClient.HTTPClientError?) {
        guard let error = error else { alert(message: Lexicon.Error.unknownError, handler: nil); return }
        switch error {
        case .notConnected:
            alert(message: Lexicon.Error.internetConnection, handler: nil)
        default:
            alert(message: Lexicon.Registration.Error.accountExists, handler: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction func didPressClearButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        if viewModel!.allFieldsValid {
            register()
        }
    }
}
