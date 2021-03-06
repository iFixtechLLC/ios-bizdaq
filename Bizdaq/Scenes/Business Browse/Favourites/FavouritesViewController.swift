//
//  BusinessFavouritesViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD

final class FavouritesViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: EmptyStateView!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: FavouritesViewModel?
    
    private var businesses = [Business]()
    weak var tabViewController: BusinessBrowseTabViewController?
    
    private let progressHUD = JGProgressHUD(style: .dark)
    
    // MARK: - Lifecycle
    func attach(to viewModel: FavouritesViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        progressHUD.parallaxMode = .alwaysOff

        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserSession.shared.isLoggedIn {
            guard let authToken = UserSession.shared.authToken else { return }
            viewModel?.setAuthenticationToken(authToken)
        } else {
            viewModel?.invalidateAuthentication()
        }
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 387.0
        tableView.register(UINib(nibName: "BusinessListingCell", bundle: Bundle.main), forCellReuseIdentifier: "businessListingCell")
    }
    
    // MARK: - Binding
    func bind(to viewModel: FavouritesViewModel) {
        viewModel.businessDriver
            .drive(onNext: { [weak self] (businesses) in
                self?.businesses = businesses
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        viewModel.errorsDriver
            .drive(onNext: { [weak self] _ in
                self?.emptyStateView.showConnectionEmptyState(tryAgainHandler: { [weak self] in
                    self?.viewModel?.reload()
                })
            })
            .disposed(by: bag)
        
        viewModel.isLoadingDriver
            .drive(onNext: { [weak self] (loading) in
                guard let `self` = self else { return }
                
                if !loading { self.progressHUD.dismiss(animated: true) }
                
                if loading && self.businesses.isEmpty {
                    self.progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
                    self.progressHUD.show(in: self.view, animated: true)
                    self.emptyStateView.hideAllEmptyStates()
                } else if !loading && self.businesses.isEmpty {
                    self.emptyStateView.showNoFavouritesEmptyState()
                }
            })
            .disposed(by: bag)
    }
}

// MARK: - UITableView Delegate & Data Source
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "businessListingCell", for: indexPath) as? BusinessListingCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(for: businesses[indexPath.row])
        cell.setFavouriteButtonHandler { [weak self] (isFavourited) in
            guard let businesses = self?.businesses else { return }
            self?.viewModel?.setFavouritedState(save: !isFavourited, business: businesses[indexPath.row], completionHandler: { [weak self] (success) in
                if success {
                    self?.businesses[indexPath.row].isSaved = !isFavourited
                    cell.setFavourited(state: !isFavourited)
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabViewController?.navigateToDetailedView(business: businesses[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height*2 {
            viewModel?.loadNextPage()
        }
    }
}
