//
//  BuyerEngagementsViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BuyerEngagementsViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient
    private let business: Business
    
    // Pagination
    private let pageCount = 20
    private var currentPage = 0
    private var isLoadingNextPage = false
    private var isLastPage = false
    private var searchString: String?
    
    // Streams
    private var retrievedEngagements = [BusinessEngagement]()
    private let engagementsSubject = BehaviorRelay<[BusinessEngagement]>(value: [])
    var engagements: Driver<[BusinessEngagement]> { return engagementsSubject.asDriver(onErrorJustReturn: []) }
    private let errorSubject = PublishSubject<HTTPClient.HTTPClientError>()
    var errors: Driver<HTTPClient.HTTPClientError> { return errorSubject.asDriver(onErrorJustReturn: .unknown) }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, business: Business) {
        self.apiClient = apiClient
        self.business = business
        loadNextPage()
    }
    
    // MARK: - Private Methods
    private func handle(error: HTTPClient.HTTPClientError) {
        errorSubject.onNext(error)
    }
    
    // MARK: - Private Methods
    private func review(engagement: BusinessEngagement, action: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let authToken = UserSession.shared.authToken else { return }
        guard let engagementId = engagement.id else { return }
        apiClient.reviewEngagement(authToken: authToken, businessEngagementId: engagementId, action: action)
            .subscribe(onSuccess: { [weak self] (response) in
                guard let engagement = response.data?.businessEngagement else { completion(false); return }
                self?.update(engagement: engagement)
                completion(true)
            }) { (_) in
                completion(false)
            }
            .disposed(by: bag)
    }
    
    private func update(engagement: BusinessEngagement) {
        var engagements = engagementsSubject.value
        let index = engagements.firstIndex { (oldEngagement) -> Bool in
            return engagement.id == oldEngagement.id
        }
        guard index != nil else { return }
        engagements[index!] = engagement
        engagementsSubject.accept(engagements)
    }
    
    // MARK: - Public Methods
    func loadNextPage() {
        guard searchString == nil else { return }
        guard !isLoadingNextPage else { return }
        guard !isLastPage else { return }
        
        currentPage += 1
        isLoadingNextPage = true
        
        guard let authToken = UserSession.shared.authToken else { return }
        guard let businessId = business.id else { return }
        apiClient.listBusinessEngagements(authToken: authToken,
                                          businessId: "\(businessId)",
                                          buyerPublicUserId: nil,
                                          isFullDetailsAccessible: nil,
                                          isFullDetailsPending: nil,
                                          page: "\(currentPage)",
                                          perPage: "\(pageCount)")
            .subscribe(onSuccess: { [weak self, pageCount] (response) in
                guard var engagements = self?.retrievedEngagements else { return }
                guard let newEngagements = response.data?.businessEngagements else { return }
                
                if (newEngagements.count < pageCount) || (newEngagements.count == 0) {
                    self?.isLastPage = true
                }
                
                engagements.append(contentsOf: newEngagements)
                self?.retrievedEngagements = engagements
                self?.engagementsSubject.accept(engagements)
                self?.isLoadingNextPage = false
            }) { [weak self] (error) in
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                self?.handle(error: error)
            }.disposed(by: bag)
    }
    
    func decline(engagement: BusinessEngagement, completion: @escaping (_ success: Bool) -> Void) {
        guard engagement.isFullDetailsRequested ?? false && !(engagement.isFullDetailsAccessible ?? false) else { return }
        review(engagement: engagement, action: "decline", completion: completion)
    }
    
    func accept(engagement: BusinessEngagement, completion: @escaping (_ success: Bool) -> Void) {
        guard engagement.isFullDetailsRequested ?? false && !(engagement.isFullDetailsAccessible ?? false) else { return }
        review(engagement: engagement, action: "accept", completion: completion)
    }
    
    func withdraw(engagement: BusinessEngagement, completion: @escaping (_ success: Bool) -> Void) {
        guard engagement.isFullDetailsAccessible ?? false else { return }
        review(engagement: engagement, action: "withdraw", completion: completion)
    }
    
    func search(value: String?) {
        searchString = value
        if searchString != nil {
            let visibleEngagements = retrievedEngagements.filter({ (engagement) -> Bool in
                return false
            })
            engagementsSubject.accept(visibleEngagements)
        } else {
            engagementsSubject.accept(retrievedEngagements)
        }
    }
}
