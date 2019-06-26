//
//  RegisterViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import IHKeyboardAvoiding

class RegisterViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var firstNameField: ValidatedTextField!
    @IBOutlet weak var lastNameField: ValidatedTextField!
    @IBOutlet weak var mobileField: ValidatedTextField!
    @IBOutlet weak var emailField: ValidatedTextField!
    @IBOutlet weak var passwordField: ValidatedTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: RegisterViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        
        setupFieldValidation()
        setupFieldPlaceholders()
        style()
        self.hideKeyboardWhenTappedAround() //before Keyboardavoid
        KeyboardAvoiding.avoidingView = scrollView
    }
    
    private func setupFieldValidation() {
        firstNameField.setValidationRegex(Constants.Validation.firstNameRegex)
        lastNameField.setValidationRegex(Constants.Validation.lastNameRegex)
        mobileField.setValidationRegex(Constants.Validation.mobileRegex)
        emailField.setValidationRegex(Constants.Validation.emailRegex)
        passwordField.setValidationRegex(Constants.Validation.passwordRegex)
    }
    
    private func setupFieldPlaceholders() {
        firstNameField.setPlaceholder(Lexicon.Registration.firstNamePlaceholder)
        lastNameField.setPlaceholder(Lexicon.Registration.lastNamePlaceholder)
        mobileField.setPlaceholder(Lexicon.Registration.mobilePlaceholder)
        emailField.setPlaceholder(Lexicon.Registration.emailPlaceholder)
        passwordField.setPlaceholder(Lexicon.Registration.passwordPlaceholder)
    }
    
    // MARK: - Styling
    private func style() {
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
        passwordField.setSecureText(true)
        registerButton.style(rounded: true)
    }
    
    // MARK: - Binding
    func bind(to viewModel: RegisterViewModel) {
        viewModel.setFirstName(driver: firstNameField.valueDriver)
        viewModel.setFirstNameValid(driver: firstNameField.isValidatedDriver)
        viewModel.setLastName(driver: lastNameField.valueDriver)
        viewModel.setLastNameValid(driver: lastNameField.isValidatedDriver)
        viewModel.setMobile(driver: mobileField.valueDriver)
        viewModel.setMobileValid(driver: mobileField.isValidatedDriver)
        viewModel.setEmail(driver: emailField.valueDriver)
        viewModel.setEmailValid(driver: emailField.isValidatedDriver)
        viewModel.setPassword(driver: passwordField.valueDriver)
        viewModel.setPasswordValid(driver: passwordField.isValidatedDriver)
        
        viewModel.allFieldsValidDriver
            .drive(onNext: { [weak self] (valid) in
                self?.registerButton.backgroundColor = valid ? Theme.UIElements.activeButtonColor : Theme.UIElements.inactiveButtonColor
            })
            .disposed(by: bag)
    }
}
