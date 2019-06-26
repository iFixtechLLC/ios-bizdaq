//
//  CanCreateMessages.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 16/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift

protocol CanCreateMessages {
    
    // MARK: - Properties
    var apiClient: APIClient { get }
    var authToken: AuthToken { get }
    var bag: DisposeBag { get }
    
    // MARK: - Methods
    func createMessage(content: String, engagementId: Int, completion: @escaping (_ response: Response<Message>) -> Void)
}

// MARK: - Default Implementation
extension CanCreateMessages {
    
    func createMessage(content: String, engagementId: Int, completion: @escaping (_ response: Response<Message>) -> Void) {
        apiClient.createMessage(authToken: authToken, engagementId: engagementId, content: content)
            .subscribe(onSuccess: { (response) in
                guard let message = response.data?.message else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.success(message))
            }, onError: { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { completion(.error(HTTPClient.HTTPClientError.unknown)); return }
                completion(.error(error))
            })
            .disposed(by: bag)
    }
}
