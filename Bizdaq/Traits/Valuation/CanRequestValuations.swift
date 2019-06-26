//
//  CanRequestValuations.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanRequestValuations {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken? { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func requestValuation(sectorId: String,
                          tenure: String,
                          annualTurnover: String,
                          postcode: String,
                          userName: String?,
                          emailAddress: String,
                          phoneNumber: String,
                          completion: @escaping (_ response: Response<ValuationResult>) -> Void)
    
    func completeValuation(sectorId: String,
                           tenure: String,
                           annualTurnover: String,
                           postcode: String,
                           userName: String?,
                           emailAddress: String,
                           phoneNumber: String,
                           metricData: [String: String],
                           completion: @escaping (_ response: Response<BasicBusinessValuation>) -> Void)
}

// MARK: - Default Implementation
extension CanRequestValuations {
    func requestValuation(sectorId: String,
                          tenure: String,
                          annualTurnover: String,
                          postcode: String,
                          userName: String?,
                          emailAddress: String,
                          phoneNumber: String,
                          completion: @escaping (_ response: Response<ValuationResult>) -> Void) {
        let disposable = apiClient.post(Endpoint.startValuation(authToken: authToken,
                                                                businessSectorId: sectorId,
                                                                tenure: tenure,
                                                                annualTurnover: annualTurnover,
                                                                businessPostcode: postcode,
                                                                userName: userName,
                                                                emailAddress: emailAddress,
                                                                phoneNumber: phoneNumber)) as Single<CreateBusinessValuationResponse>
        disposable.subscribe(onSuccess: { (response) in
            if let widgets = response.data?.widgets {
                completion(.success(ValuationResult.widgets(widgets)))
            } else if let valuation = response.data?.basicBusinessValuation {
                completion(.success(ValuationResult.valuation(valuation)))
            } else {
                completion(.error(HTTPClient.HTTPClientError.unknown))
            }
        }) { (error) in
        guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
            completion(.error(error))
        }
        .disposed(by: bag)
    }
    
    func completeValuation(sectorId: String,
                           tenure: String,
                           annualTurnover: String,
                           postcode: String,
                           userName: String?,
                           emailAddress: String,
                           phoneNumber: String,
                           metricData: [String: String],
                           completion: @escaping (_ response: Response<BasicBusinessValuation>) -> Void) {
        let disposable = apiClient.post(Endpoint.completeValuation(authToken: authToken,
                                                                   businessSectorId: sectorId,
                                                                   tenure: tenure,
                                                                   annualTurnover: annualTurnover,
                                                                   businessPostcode: postcode,
                                                                   userName: userName,
                                                                   emailAddress: emailAddress,
                                                                   phoneNumber: phoneNumber,
                                                                   metricData: metricData)) as Single<CreateBusinessValuationResponse>
        disposable.subscribe(onSuccess: { (response) in
            guard let valuation = response.data?.basicBusinessValuation else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
            completion(.success(valuation))
        }) { (error) in
            guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
            completion(.error(error))
        }
        .disposed(by: bag)
    }
}
