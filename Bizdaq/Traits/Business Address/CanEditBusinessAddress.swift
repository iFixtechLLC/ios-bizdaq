//
//  CanEditBusinessAddress.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanEditBusinessAddress {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func editBusinessAddress(businessId: Int,
                             line1: String?,
                             line2: String?,
                             line3: String?,
                             townCity: String?,
                             postcode: String?,
                             completion: @escaping (_ response: Response<BusinessAddress>) -> Void)
}

// MARK: - Default Implementation
extension CanEditBusinessAddress {
    
    func editBusinessAddress(businessId: Int,
                             line1: String?,
                             line2: String?,
                             line3: String?,
                             townCity: String?,
                             postcode: String?,
                             completion: @escaping (_ response: Response<BusinessAddress>) -> Void) {
        apiClient.editBusinessAddress(authToken: authToken,
                                      businessId: businessId,
                                      line1: line1,
                                      line2: line2,
                                      line3: line3,
                                      townCity: townCity,
                                      postcode: postcode)
            .subscribe(onSuccess: { (response) in
                guard let address = response.data?.address else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.success(address))
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            }
            .disposed(by: bag)
    }
}
