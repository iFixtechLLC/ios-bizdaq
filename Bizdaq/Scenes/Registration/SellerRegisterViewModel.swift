//
//  SellerRegisterViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SellerRegisterViewModel: RegisterViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var business: Business?
    // MARK: - Public Methods
    func registerAccount(firstName: String,
                         lastName: String,
                         mobile: String,
                         email: String,
                         password: String,
                         success: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard allFieldsValid else { success(false, nil); return }
        apiClient.registerSeller(firstName: firstName,
                                 lastName: lastName,
                                 mobilePhone: mobile,
                                 emailAddress: email,
                                 password: password)
            .subscribe(onSuccess: { (response) in
                UserSession.shared.setActiveUser(response.data.user)
                self.business = response.data.business
                success(true, nil)
            }) { (error) in
                success(false, error)
            }
            .disposed(by: bag)
    }
}
