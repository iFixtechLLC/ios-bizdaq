//
//  FavouriteBusinessesDataSource.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 10/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FavouriteBusinessesDataSource {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    private let buyerPublicUserId: Int
    
    // Pagination
    private let pageCount = 10
    private var currentPage = 0
    private var isLoadingNextPage = false
    private var isLastPage = false
    
    // Streams
    private let businessesSubject = BehaviorRelay<[Business]>(value: [])
    var businesses: Driver<[Business]> { return businessesSubject.asDriver(onErrorJustReturn: []) }
    private let errorSubject = PublishSubject<HTTPClient.HTTPClientError>()
    var errors: Driver<HTTPClient.HTTPClientError> { return errorSubject.asDriver(onErrorJustReturn: .unknown) }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, buyerPublicUserId: Int) {
        self.apiClient = apiClient
        self.buyerPublicUserId = buyerPublicUserId
        loadNextPage()
    }
    
    // MARK: - Private Methods
    private func handle(error: HTTPClient.HTTPClientError) {
        errorSubject.onNext(error)
    }
    
    // MARK: - Public Methods
    func loadNextPage() {
        guard !isLoadingNextPage else { return }
        guard !isLastPage else { return }
        
        currentPage += 1
        isLoadingNextPage = true
        
        guard let authToken = UserSession.shared.authToken else { return }
        apiClient.listSavedBusinesses(authToken: authToken, page: "\(currentPage)", perPage: "\(pageCount)")
            .subscribe(onSuccess: { [weak self, pageCount] (response) in
                guard var businesses = self?.businessesSubject.value else { return }
                guard let newBusinesses = response.data else { return }
                
                if (newBusinesses.count < pageCount) || (newBusinesses.count == 0) {
                    self?.isLastPage = true
                }
                
                businesses.append(contentsOf: newBusinesses)
                self?.businessesSubject.accept(businesses)
                self?.isLoadingNextPage = false
            }, onError: { [weak self] (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                self?.handle(error: error)
            })
            .disposed(by: bag)
    }
}
