//
//  AddPhotosViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddPhotosViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    private let businessId: Int
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, businessId: Int) {
        self.apiClient = apiClient
        self.businessId = businessId
    }
    
    // MARK: - Public Methods
    func uploadPhotos(images: [UIImage], completion: @escaping (_ success: Bool) -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        var files = [String: UIImage]()
        var count = 0
        images.forEach { (image) in
            count+=1
            files["business_photo"+String(count)] = image
        }
        apiClient.uploadBusinessPhotos(authToken: authToken,
                                       businessId: "\(businessId)",
                                       files: files)
            .subscribe(onSuccess: { (response) in
                debugPrint(response)
                completion(response.success ?? false)
            }) { (error) in
                debugPrint(error)
                completion(false)
            }
            .disposed(by: bag)
    }
}
