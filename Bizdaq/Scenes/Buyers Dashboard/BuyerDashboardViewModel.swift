//
//  BuyerDashboardViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyerDashboardViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIClient!
    
    // Streams
    private let grantedAccessDataSource: GrantedAccessBusinessesDataSource!
    var grantedAccessBusinesses: Driver<[Business]> { return grantedAccessDataSource.businesses }
    private let favouriteDataSource: FavouriteBusinessesDataSource!
    var favouriteBusinesses: Driver<[Business]> { return favouriteDataSource.businesses }
    private let requestedAccessDataSource: RequestedAccessBusinessesDataSource!
    var requestedAccessBusinesses: Driver<[Business]> { return requestedAccessDataSource.businesses }
    
    var enquiryCount: Int { return UserSession.shared.user?.publicUser.publicUserBuyerProfile?.enquiryCount ?? 0 }
    var viewingsCount: Int { return UserSession.shared.user?.publicUser.publicUserBuyerProfile?.viewingCount ?? 0 }
    var offerCount: Int { return UserSession.shared.user?.publicUser.publicUserBuyerProfile?.offerCount ?? 0 }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, buyerPublicUserId: Int) {
        self.apiClient = apiClient
        self.grantedAccessDataSource = GrantedAccessBusinessesDataSource(apiClient: apiClient, buyerPublicUserId: buyerPublicUserId)
        self.favouriteDataSource = FavouriteBusinessesDataSource(apiClient: apiClient, buyerPublicUserId: buyerPublicUserId)
        self.requestedAccessDataSource = RequestedAccessBusinessesDataSource(apiClient: apiClient, buyerPublicUserId: buyerPublicUserId)
    }
    
    // MARK: - Public Methods
    func loadNextGrantedAccessBusinessesPage() {
        grantedAccessDataSource.loadNextPage()
    }
    
    func loadNextFavouriteBusinessesPage() {
        favouriteDataSource.loadNextPage()
    }
    
    func loadNextRequestedAccessBusinessesPage() {
        requestedAccessDataSource.loadNextPage()
    }
}
