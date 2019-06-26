//
//  LoginViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIProtocol
    let modallyPresented: Bool
    
    var emailValid = false
    var passwordValid = false
    
    var allFieldsValid: Bool {
        return emailValid
            && passwordValid
    }
    
    // MARK: - Lifecycle
    init(apiClient: APIProtocol, modallyPresented: Bool) {
        self.apiClient = apiClient
        self.modallyPresented = modallyPresented
    }
    
    // MARK: - Public Methods
    func setEmailValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in self?.emailValid = valid }).disposed(by: bag)
    }
    
    func setPasswordValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in self?.passwordValid = valid }).disposed(by: bag)
    }
    
    func attemptLogin(email: String, password: String, success: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard email.matches(predicate: Constants.Validation.emailRegex)
            && password.matches(predicate: Constants.Validation.passwordRegex) else {
                success(false, nil)
                return
        }
        
        apiClient.login(emailAddress: email, password: password)
            .subscribe(onSuccess: { (response) in
                UserSession.shared.setActiveUser(response.data.user)
                success(true, nil)
            }) { (error) in
                success(false, error)
            }
            .disposed(by: bag)
    }
}
