//
//  LoginViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: ValidatedTextField!
    @IBOutlet weak var passwordTextField: ValidatedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: LoginViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        
        setupFieldValidation()
        setupFieldPlaceholders()
        style()
        if(Constants.Networking.development){
            autologin(autologin: false)
        }
        
        //
    }
    private func autologin(autologin: Bool){
        // TODO: Remove temp auto-login
        emailTextField.textField.text = "jl4@dreamr.uk"
        passwordTextField.textField.text = "Password123"
        //emailTextField.textField.text = "bizdaq"
        //passwordTextField.textField.text = "letmeinbizdaq"
        if(autologin){
         login()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    // MARK: - Styling
    private func style() {
        loginButton.style(rounded: true)
        registerButton.style(rounded: true)
        registerButton.isHidden = viewModel!.modallyPresented
        if !viewModel!.modallyPresented { navigationItem.rightBarButtonItem = nil }
        setStatusBarStyle(.lightContent)
        navigationController?.navigationBar.style()
        passwordTextField.setSecureText(true)
        
    }
    
    // MARK: - Binding
    func bind(to viewModel: LoginViewModel) {
        viewModel.setEmailValid(driver: emailTextField.isValidatedDriver)
        viewModel.setPasswordValid(driver: passwordTextField.isValidatedDriver)
        
        Driver.combineLatest(emailTextField.isValidatedDriver,
                             passwordTextField.isValidatedDriver)
            .drive(onNext: { [weak self] (emailValid, passwordValid) in
                self?.loginButton.backgroundColor = (emailValid && passwordValid)
                    ? Theme.UIElements.activeButtonColor
                    : Theme.UIElements.inactiveButtonColor
            })
            .disposed(by: bag)
    }
    
    // MARK: - Private Methods
    private func setupFieldValidation() {
        emailTextField.setValidationRegex(Constants.Validation.emailRegex)
        passwordTextField.setValidationRegex(Constants.Validation.passwordRegex)
    }
    
    private func setupFieldPlaceholders() {
        emailTextField.setPlaceholder(Lexicon.Login.emailPlaceholder)
        passwordTextField.setPlaceholder(Lexicon.Login.passwordPlaceholder)
    }
    
    private func login() {
        viewModel?.attemptLogin(email: emailTextField.textField.text!,
                                password: passwordTextField.textField.text!,
                                success: { [weak self] (success, error) in
            if success {
                if self?.viewModel?.modallyPresented == true {
                    self?.dismiss(animated: true, completion: nil); return
                }
                
                // TODO: Navigate to correct screen once seller registration is implemented (Buyer/Seller have different destinations)
                Menu.shared.reintialise(sender: self?.view.window)
                if UserSession.shared.user?.publicUser.publicUserSellerProfile != nil {
                    Menu.shared.menuView?.setSellerDashboardAsRoot()
                }else if UserSession.shared.user?.publicUser.publicUserBuyerProfile != nil {
                    Menu.shared.menuView?.setBuyersDashboardAsRoot()
                }else {
                    self?.navigate(to: .businessBrowse, sender: self)
                }
            } else {
                guard let error = error as? HTTPClient.HTTPClientError else {
                    self?.alert(message: Lexicon.Error.unknownError, handler: nil)
                    return
                }
                self?.handle(error: error)
            }
        })
    }
    
    private func handle(error: HTTPClient.HTTPClientError) {
        switch error {
            case .notConnected:
                alert(message: Lexicon.Error.internetConnection, handler: nil)
            default:
                alert(message: Lexicon.Login.Error.invalidCredentials, handler: nil)
        }
    }

    // MARK: - Actions
    @IBAction func didPressLoginButton(_ sender: UIButton) {
    print("login pressed")
        if viewModel!.allFieldsValid || Constants.Networking.development {
            print("login valid")

            login()
        }
    }
    @IBAction func forgotPasswordBtn(_ sender: Any) {
        navigate(to: .recoverPassword, sender: sender)
    }
    
    @IBAction func didPressCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Navigation
extension LoginViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case register
        case businessBrowse
        case registerSeller
        case sellerDash
        case buyerDash
        case recoverPassword
    }
    
    static func instance() -> UINavigationController? {
        guard let instance =  UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .register:
            guard let registerViewController = segue.destination as? BuyerRegisterViewController else { break }
            registerViewController.attach(to: ViewModelFactory.Registration.makeRegistrationModel())
        case .registerSeller:
            debugPrint("🚕 NAVIGATE to register for seller")
            guard let registerViewController = segue.destination as? SellerRegisterViewController else { break }
            registerViewController.attach(to: ViewModelFactory.Registration.makeSellerRegistrationModel())
        case .sellerDash:

            
            break
            
        case .recoverPassword:
            
            debugPrint("🚕 NAVIGATE to recover")
            guard let recoverViewController = segue.destination as? ForgotPasswordViewController else { break }
            recoverViewController.attach(to: ViewModelFactory.Login.makeRecoveryModel())
        case .buyerDash:
            guard let viewController = segue.destination as? BuyersDashboardViewController else { break }
            guard let buyerId = UserSession.shared.user?.publicUser.publicUserBuyerProfile?.id else { return }
            let viewModel = ViewModelFactory.BuyersDashboard.makeBuyersDashboardViewModel(buyerPublicUserId: buyerId)
            viewController.attach(to: viewModel)
            break
        case .businessBrowse:
            break
        }
    }
}

