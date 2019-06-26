//
//  RejectedOffersViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RejectedOffersViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIProtocol
    
    // Pagination
    private var isLastPage = false
    private let firstPageIndex = 1
    private var currentPage = 1
    private let cellsPerPage = 10
    
    // Streams
    private let engagementBids = BehaviorRelay<[BusinessEngagementBid]>(value: [])
    var engagementBidsDriver: Driver<[BusinessEngagementBid]> { return engagementBids.asDriver(onErrorJustReturn: []) }
    private let errors = PublishSubject<String?>()
    var errorsDriver: Driver<String?> { return errors.asDriver(onErrorJustReturn: nil) }
    private let isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> { return isLoading.asDriver(onErrorJustReturn: false) }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        currentPage = firstPageIndex
        loadNextEngagementBids()
    }
    
    // MARK: - Private Methods
    private func loadNextEngagementBids() {
        guard let authToken = UserSession.shared.authToken else { return }
        
        isLoading.accept(true)
        apiClient.listBusinessEngagementBids(authToken: authToken,
                                             businessId: nil,
                                             buyerPublicUserId: nil,
                                             isPending: nil,
                                             isRejected: true,
                                             isAccepted: nil,
                                             perPage: "\(cellsPerPage)",
                                             page: "\(currentPage)")
            .subscribe(onSuccess: { [weak self] (response) in
                if var array = self?.engagementBids.value {
                    guard let responseBids = response.data?.businessEngagementBids else { self?.isLoading.accept(false); return }
                    array.append(contentsOf: responseBids)
                    self?.engagementBids.accept(array)
                    if responseBids.count < 10 { self?.isLastPage = true }
                }
                self?.isLoading.accept(false)
            }) { (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                switch error {
                case .notConnected:
                    self.errors.onNext(Lexicon.Error.internetConnection)
                default:
                    break
                }
            }
            .disposed(by: bag)
    }
    
    // MARK: - Public Methods
    func loadNextPage() {
        if !isLoading.value && !isLastPage {
            currentPage += 1
            loadNextEngagementBids()
        }
    }
}
