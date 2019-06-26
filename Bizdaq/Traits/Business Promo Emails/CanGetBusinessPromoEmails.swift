//
//  CanGetBusinessPromoEmails.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 23/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanGetBusinessPromoEmails {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func getBusinessPromoEmails(businessId: Int, completion: @escaping (_ response: Response<[PromoEmails]>) -> Void)
}

// MARK: - Default Implementation
extension CanGetBusinessPromoEmails {
    
    func getBusinessPromoEmails(businessId: Int, completion: @escaping (_ response: Response<[PromoEmails]>) -> Void) {
        apiClient.getBusinessPromoEmails(authToken: authToken, businessId: businessId)
            .subscribe(onSuccess: { (response) in
                guard let promoEmails = response.data?.promoEmails else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.success(promoEmails))
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            }
            .disposed(by: bag)
    }
}
