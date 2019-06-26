//
//  BusinessBrowseViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BusinessBrowseViewModel {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private let apiClient: APIProtocol
    private let favouritesManager: FavouritesManager
    
    private var authToken: AuthToken?
    
    // Pagination
    private var isLastPage = false
    private let firstPageIndex = 1
    private var currentPage = 1
    private let cellsPerPage = 10
    
    var filter: BusinessSearchFilter? {
        didSet {
            debugPrint("RAMIREZ: RELOADING!!!")
            reload()
        }
    }
    
    // Streams
    private let businesses = BehaviorRelay<[Business]>(value: [])
    var businessDriver: Driver<[Business]> { return businesses.asDriver(onErrorJustReturn: []) }
    private let errors = PublishSubject<String?>()
    var errorsDriver: Driver<String?> { return errors.asDriver(onErrorJustReturn: nil) }
    private let isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> { return isLoading.asDriver(onErrorJustReturn: false) }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, authToken: AuthToken?, favouritesManager: FavouritesManager, filter: BusinessSearchFilter? = nil) {
        self.apiClient = apiClient
        self.filter = filter
        self.authToken = authToken
        self.favouritesManager = favouritesManager
        currentPage = firstPageIndex
        loadNextBusinesses()
    }

    // MARK: - Private Methods
    private func loadNextBusinesses() {
        isLoading.accept(true)
        apiClient.listBusinesses(authToken: authToken,
                                 sellerPublicUserId: nil,
                                 sectorId: filter?.sectorId != nil ? "\(filter!.sectorId!)" : nil,
                                 categoryId: filter?.categoryId != nil ? "\(filter!.categoryId!)" : nil,
                                 locationId: filter?.locationId != nil ? "\(filter!.locationId!)" : nil,
                                 tenure: filter?.tenure,
                                 askingPriceMin: filter?.price?.min != nil ? "\(filter!.price!.min)" : nil,
                                 askingPriceMax: filter?.price?.max != nil ? "\(filter!.price!.max)" : nil,
                                 page: "\(currentPage)",
                                 perPage: "\(cellsPerPage)",
                                 showInactive: nil)
            .subscribe(onSuccess: { [weak self] (response) in
                debugPrint("GO SUCCESS")
                if var businessArray = self?.businesses.value {
                    businessArray.append(contentsOf: response.data)
                    self?.businesses.accept(businessArray)
                    if response.data.count < 10 { self?.isLastPage = true }
                }
                self?.isLoading.accept(false)
            }) { (error) in
                debugPrint(error)

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
            loadNextBusinesses()
        }
    }
    
    func setAuthenticationToken(_ token: AuthToken) {
        if authToken == nil {
            authToken = token
            businesses.accept([])
            currentPage = firstPageIndex
            
            if !isLoading.value && !isLastPage {
                isLoading.accept(false)
                loadNextBusinesses()
            }
        }
    }
    
    func invalidateAuthentication() {
        if authToken != nil {
            authToken = nil
        }
    }
    
    func setFavouritedState(save: Bool, business: Business, completionHandler: @escaping (_ success: Bool) -> Void) {
        guard let id = business.id else { completionHandler(false); return }
        
        if save {
            favouritesManager.addFavourite(businessId: id, completionHandler: completionHandler)
        } else {
            favouritesManager.removeFavourite(businessId: id, businessName: business.name ?? Lexicon.Favourites.noName, completionHandler: completionHandler)
        }
    }

    func reload() {
        currentPage = firstPageIndex
        isLastPage = false
        businesses.accept([])
        isLoading.accept(false)
        loadNextBusinesses()
    }
}
