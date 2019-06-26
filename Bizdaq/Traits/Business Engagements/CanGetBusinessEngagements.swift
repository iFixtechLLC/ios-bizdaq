//
//  CanGetBusinessEngagements.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanGetBusinessEngagements {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func getEngagement(businessId: Int, completion: @escaping (_ response: Response<BusinessEngagement>) -> Void)
}

// MARK: - Default Implementation
extension CanGetBusinessEngagements {
    
    private func getEngagement(businessId: Int, buyerPublicUserId: Int, completion: @escaping (_ response: Response<BusinessEngagement>) -> Void) {
        apiClient.listBusinessEngagements(authToken: authToken,
                                          businessId: "\(businessId)",
                                          buyerPublicUserId: "\(buyerPublicUserId)",
                                          isFullDetailsAccessible: nil,
                                          isFullDetailsPending: nil,
                                          page: nil,
                                          perPage: nil)
            .subscribe(onSuccess: { (response) in
                guard let businessEngagements = response.data?.businessEngagements else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                let matchingEngagements = businessEngagements.filter { $0.business?.id == businessId }
                matchingEngagements.isEmpty ? completion(.error(HTTPClient.HTTPClientError.unknown)) : completion(.success(matchingEngagements.first!))
            }, onError: { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            })
            .disposed(by: bag)
    }
}
