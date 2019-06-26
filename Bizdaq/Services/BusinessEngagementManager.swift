//
//  BusinessEngagementManager.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 13/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessEngagementManager {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    
    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    func getEngagement(for userSession: UserSession, businessId: Int, completion: @escaping (_ businessEngagement: BusinessEngagement?) -> Void) {
        guard let authToken = userSession.authToken else { completion(nil); return }
        guard let buyerPublicUserId = userSession.user?.publicUser.id else { completion(nil); return }
        
        apiClient.listBusinessEngagements(authToken: authToken,
                                          businessId: "\(businessId)",
                                          buyerPublicUserId: "\(buyerPublicUserId)",
                                          isFullDetailsAccessible: nil,
                                          isFullDetailsPending: nil,
                                          page: nil,
                                          perPage: nil)
            .subscribe(onSuccess: { (response) in
                guard let businessEngagements = response.data?.businessEngagements else { completion(nil); return }
                let matchingEngagements = businessEngagements.filter { $0.business?.id == businessId }
                matchingEngagements.isEmpty ? completion(nil) : completion(matchingEngagements.first!)
                return
            }) { (error) in
                completion(nil)
            }
            .disposed(by: bag)
    }
    
    func createEngagement(userSession: UserSession, businessId: Int, message: String, completion: @escaping (_ businessEngagement: BusinessEngagement?) -> Void) {
        guard userSession.isLoggedIn else { completion(nil); return }
        guard let token = UserSession.shared.authToken else { completion(nil); return }
        
        apiClient.createBusinessEngagement(authToken: token, businessId: businessId, message: message)
            .subscribe(onSuccess: { (response) in
                guard let businessEngagement = response.data?.businessEngagement else { completion(nil); return }
                completion(businessEngagement)
            }) { (error) in
                completion(nil)
            }
            .disposed(by: bag)
    }
}
