//
//  ForgotPasswordViewModal.swift
//  Bizdaq
//
//  Created by App Dev on 12/06/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class ForgotPasswordViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIProtocol
    var emailValid = false
    
    
    // MARK: - Lifecycle
    init(apiClient: APIProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    func setEmailValid(driver: Driver<Bool>) {
        driver.drive(onNext: { [weak self] (valid) in self?.emailValid = valid }).disposed(by: bag)
    }
    
    func attemptSubmiy(email: String, success: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard email.matches(predicate: Constants.Validation.emailRegex) else {
            success(false, nil)
            return
        }
        apiClient.recoverPassword(emailAddress: email)
            .subscribe(onSuccess: { (response) in
                if response.success {
                    success(true, nil)
                }else{
                    success(false, nil)
                }
            }) { (error) in
                success(false, error)
            }
            .disposed(by: bag)
    }
}
