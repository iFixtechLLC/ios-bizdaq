//
//  CanListBusinessViewings.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanListBusinessViewings {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func listEngagementViewings(businessId: Int?,
                                buyerPublicUserId: Int?,
                                perPage: Int?,
                                page: Int?,
                                monthYear: String?,
                                completion: @escaping (_ response: Response<[BusinessEngagementViewing]>) -> Void)
}

// MARK: - Default Implementation
extension CanListBusinessViewings {
    
    func listEngagementViewings(businessId: Int? = nil,
                                buyerPublicUserId: Int? = nil,
                                perPage: Int? = nil,
                                page: Int? = nil,
                                monthYear: String? = nil,
                                completion: @escaping (_ response: Response<[BusinessEngagementViewing]>) -> Void) {
        apiClient.listBusinessEngagementViewings(authToken: authToken,
                                                 businessId: businessId,
                                                 buyerPublicUserId: buyerPublicUserId,
                                                 perPage: perPage,
                                                 page: page,
                                                 monthYear: monthYear)
            .subscribe(onSuccess: { (response) in
                guard let viewings = response.data?.businessEngagementViewings else {
                    completion(.error(HTTPClient.HTTPClientError.unknown)); return
                }
                completion(.success(viewings))
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            }
            .disposed(by: bag)
        
    }
}
