//
//  CanGetTopLevelMessages.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanGetTopLevelMessages {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func getTopLevelMessages(completion: @escaping (_ response: Response<TopLevelMessagesResponse.Data.TopLevelMessages>) -> Void)
}

// MARK: - Default Implementation
extension CanGetTopLevelMessages {
    
    func getTopLevelMessages(completion: @escaping (_ response: Response<TopLevelMessagesResponse.Data.TopLevelMessages>) -> Void) {
        apiClient.listTopLevelMessages(authToken: authToken, photoWidth: 50, photoHeight: 50)
            .subscribe(onSuccess: { (response) in
                guard let topLevelMessages = response.data?.topLevelMessages else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.success(topLevelMessages))
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            }
            .disposed(by: bag)
    }
}
