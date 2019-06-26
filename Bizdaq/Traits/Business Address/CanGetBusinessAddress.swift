//
//  CanGetBusinessAddress.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanGetBusinessAddress {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func getBusinessAddress(businessId: Int, completion: @escaping (_ response: Response<BusinessAddress>) -> Void)
}

// MARK: - Default Implementation
extension CanEditBusinessAddress {
    
    func getBusinessAddress(businessId: Int, completion: @escaping (_ response: Response<BusinessAddress>) -> Void) {
        apiClient.getBusinessAddress(authToken: authToken, businessId: businessId)
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
