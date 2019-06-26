//
//  MakeOfferViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MakeOfferViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    private let businessEngagementId: Int
    
    // MARK: - Properties
    var bidAmount: Int?
    var terms: String?
    var timescale: String?
    var isFundingInPlace: Bool?
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, businessEngagementId: Int) {
        self.apiClient = apiClient
        self.businessEngagementId = businessEngagementId
    }
    
    // MARK: - Private Methods
    private func createBid(bidAmount: Int, terms: String?, timescale: String?, isFundingInPlace: Bool?, completion: @escaping (_ success: Bool) -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        // TODO: Remove "yes" and "no" in-line strings when options are provided by the API in the Dynamic Lexicon
        apiClient.createBusinessEngagementBid(authToken: authToken,
                                              businessEngagementId: businessEngagementId,
                                              bidAmount: bidAmount,
                                              terms: terms,
                                              timescale: timescale,
                                              isFundingInPlace: isFundingInPlace ?? false ? "yes" : "no")
            .subscribe(onSuccess: { (response) in
                completion(true)
            }) { (error) in
                completion(false)
            }
            .disposed(by: bag)
    }
    
    // MARK: - Public Methods
    func makeOffer(completion: @escaping (_ success: Bool) -> Void) {
        guard bidAmount != nil else { return }
        createBid(bidAmount: bidAmount!, terms: terms, timescale: timescale, isFundingInPlace: isFundingInPlace, completion: completion)
    }
}
