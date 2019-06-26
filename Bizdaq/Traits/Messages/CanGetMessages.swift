//
//  CanGetMessages.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanGetMessages {

    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func getMessages(engagementId: Int, perPage: Int, page: Int, completion: @escaping (_ response: Response<[Message]>) -> Void)
}

// MARK: - Default Implementation
extension CanGetMessages {
    
    func getMessages(engagementId: Int, perPage: Int, page: Int, completion: @escaping (_ response: Response<[Message]>) -> Void) {
        apiClient.listMessagesByEngagement(authToken: authToken, engagementId: engagementId, perPage: perPage, page: page)
            .subscribe(onSuccess: { (response) in
                guard let messages = response.data?.messages else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.success(messages))
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            }
            .disposed(by: bag)
    }
}
