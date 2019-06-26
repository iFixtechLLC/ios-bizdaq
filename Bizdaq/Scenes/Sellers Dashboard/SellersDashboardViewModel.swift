//
//  SellersDashboardViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 06/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SellersDashboardViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient!
    let sellerPublicProfile: PublicUserSellerProfile
    
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
    init(apiClient: APIClient, sellerPublicProfile: PublicUserSellerProfile) {
        self.apiClient = apiClient
        self.sellerPublicProfile = sellerPublicProfile
    }
    
    // MARK: - Private Methods
    private func handle(error: HTTPClient.HTTPClientError) {
        errorSubject.onNext(error)
    }
    
    // MARK: - Public Methods
    func reloadData() {
        businessesSubject.accept([])
        isLoadingNextPage = false
        isLastPage = false
        currentPage = 0
        loadNextPage()
    }
    
    func loadNextPage() {
        guard !isLoadingNextPage else { return }
        guard !isLastPage else { return }
        
        currentPage += 1
        isLoadingNextPage = true
        
        guard let authToken = UserSession.shared.authToken else { return }
        guard let sellerPublicUserId = UserSession.shared.user?.publicUser.id else { return }

        apiClient.listBusinesses(authToken: authToken,
                                 sellerPublicUserId: "\(sellerPublicUserId)",
                                 sectorId: nil,
                                 categoryId: nil,
                                 locationId: nil,
                                 tenure: nil,
                                 askingPriceMin: nil,
                                 askingPriceMax: nil,
                                 page: "\(currentPage)",
                                 perPage: "\(pageCount)",
                                 showInactive: true
            )
            .subscribe(onSuccess: { [weak self, pageCount] (response) in
                guard var businesses = self?.businessesSubject.value else { return }
                let newBusinesses = response.data
                
                if (newBusinesses.count < pageCount) || (newBusinesses.count == 0) {
                    self?.isLastPage = true
                }
                
                businesses.append(contentsOf: newBusinesses)
                self?.businessesSubject.accept(businesses)
                self?.isLoadingNextPage = false
            }) { [weak self] (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                self?.handle(error: error)
            }
            .disposed(by: bag)
    }
}
