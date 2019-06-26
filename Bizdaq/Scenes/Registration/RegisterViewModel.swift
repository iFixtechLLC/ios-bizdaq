//
//  RegisterViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    internal let apiClient: APIClient
    
    var firstName: String?
    private(set) var firstNameValid = false
    var lastName: String?
    private(set) var lastNameValid = false
    var mobile: String?
    private(set) var mobileValid = false
    var email: String?
    private(set) var emailValid = false
    var password: String?
    private(set) var passwordValid = false
    
    var allFieldsValid: Bool {
        return firstNameValid
            && lastNameValid
            && mobileValid
            && emailValid
            && passwordValid
    }
    let allFieldsValidSubject = BehaviorSubject<Bool>(value: false)
    var allFieldsValidDriver: Driver<Bool> { return allFieldsValidSubject.asDriver(onErrorJustReturn: false)}
    
    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    func setFirstName(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.firstName = value }).disposed(by: bag)
    }
    
    func setFirstNameValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in
            self?.firstNameValid = valid
            self?.checkAllFieldsValid()
        }).disposed(by: bag)
    }
    
    func setLastName(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.lastName = value }).disposed(by: bag)
    }
    
    func setLastNameValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in
            self?.lastNameValid = valid
            self?.checkAllFieldsValid()
        }).disposed(by: bag)
    }
    
    func setMobile(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.mobile = value }).disposed(by: bag)
    }
    
    func setMobileValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in
            self?.mobileValid = valid
            self?.checkAllFieldsValid()
        }).disposed(by: bag)
    }
    
    func setEmail(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.email = value }).disposed(by: bag)
    }
    
    func setEmailValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in
            self?.emailValid = valid
            self?.checkAllFieldsValid()
        }).disposed(by: bag)
    }
    
    func setPassword(driver: Driver<String?>) {
        driver.drive(onNext: { [weak self] (value) in self?.password = value }).disposed(by: bag)
    }
    
    func setPasswordValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in
            self?.passwordValid = valid
            self?.checkAllFieldsValid()
        }).disposed(by: bag)
    }
    
    // MARK: - Private Methods
    private func checkAllFieldsValid() {
        let valid = firstNameValid
            && lastNameValid
            && mobileValid
            && emailValid
            && passwordValid
        allFieldsValidSubject.onNext(valid)
    }
}
