//
//  ViewingsCalendarViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewingsCalendarViewModel: CanListBusinessViewings {
    
    // MARK: - Properties
    let apiClient: APIClient
    let authToken: AuthToken
    let bag = DisposeBag()
    
    // Viewings
    let dateFormatter = DateFormatter()
    private let viewingsSubject = BehaviorSubject<[BusinessEngagementViewing]>(value: [])
    var viewingDates: Driver<[Date?]> {
        return viewingsSubject.map {
            $0.filter { $0.isViewingDateTimeAgreed ?? false && $0.viewingDateTime != nil }
                .map({ [weak self] (viewing) -> Date? in
                    guard let `self` = self else { return nil }
                    let viewingDateTime = viewing.viewingDateTime ?? String()
                    self.dateFormatter.dateFormat = "yyyy MM dd"
                    return self.dateFormatter.date(from: viewingDateTime)
                })
        }.asDriver(onErrorJustReturn: [])
    }
    var viewings: Driver<[BusinessEngagementViewing]> {
        return viewingsSubject.asDriver(onErrorJustReturn: [])
    }
    
    // Table View
    var numberOfSections = 1
    var numberOfRows = 1

    // MARK: - Lifecycle
    init(apiClient: APIClient, authToken: AuthToken) {
        self.apiClient = apiClient
        self.authToken = authToken
        fetchViewings()
    }
    
    // MARK: - Private Methods
    private func fetchViewings() {
        guard let userId = UserSession.shared.user?.publicUser.id else { return }
        listEngagementViewings(buyerPublicUserId: userId) { [weak self] (response) in
            switch response {
            case .success(let viewings):
                self?.numberOfRows = viewings.count + 1
                self?.viewingsSubject.onNext(viewings)
            case .error(_):
                break
            }
        }
    }
}
