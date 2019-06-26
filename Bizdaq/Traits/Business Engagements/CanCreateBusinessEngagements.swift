//
//  CanCreateBusinessEngagements.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanCreateBusinessEngagements {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func createEngagement(businessId: Int, message: String, completion: @escaping (_ response: Response<BusinessEngagement>) -> Void)
}

// MARK: - Default Implementation
extension CanCreateBusinessEngagements {
    
    private func createEngagement(businessId: Int, message: String, completion: @escaping (_ response: Response<BusinessEngagement>) -> Void) {
        apiClient.createBusinessEngagement(authToken: authToken, businessId: businessId, message: message)
            .subscribe(onSuccess: { (response) in
                guard let businessEngagement = response.data?.businessEngagement else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.success(businessEngagement))
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            }
            .disposed(by: bag)
    }
}
