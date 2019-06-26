//
//  FavouritesViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 22/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FavouritesViewModel {
    
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
    
    // Streams
    private let businesses = BehaviorRelay<[Business]>(value: [])
    var businessDriver: Driver<[Business]> { return businesses.asDriver(onErrorJustReturn: []) }
    private let errors = PublishSubject<String?>()
    var errorsDriver: Driver<String?> { return errors.asDriver(onErrorJustReturn: nil) }
    private let isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> { return isLoading.asDriver(onErrorJustReturn: false) }
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, authToken: AuthToken?, favouritesManager: FavouritesManager) {
        self.apiClient = apiClient
        self.favouritesManager = favouritesManager
        if authToken != nil {
            self.authToken = authToken
            loadNextBusinesses(authToken: authToken!)
        }
        currentPage = firstPageIndex
    }
    
    // MARK: - Private Method
    private func loadNextBusinesses(authToken: AuthToken) {
        isLoading.accept(true)
        apiClient.listSavedBusinesses(authToken: authToken, page: "\(currentPage)", perPage: "\(cellsPerPage)")
            .subscribe(onSuccess: { [weak self] (response) in
                if var businessArray = self?.businesses.value {
                    guard response.data != nil else { return }
                    businessArray.append(contentsOf: response.data!)
                    self?.businesses.accept(businessArray)
                    if response.data!.count < 10 { self?.isLastPage = true }
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
        if !isLoading.value && !isLastPage && authToken != nil {
            currentPage += 1
            loadNextBusinesses(authToken: authToken!)
        }
    }
    
    func setAuthenticationToken(_ token: AuthToken) {
        authToken = token
        reload()
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
        if authToken != nil {
            loadNextBusinesses(authToken: authToken!)
        }
    }
}
