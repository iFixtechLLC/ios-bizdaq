//
//  BuyersDashboard.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyersDashboardViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var messageButtonBorder: UIView!
    @IBOutlet weak var enquiriesCountBorder: UIView!
    @IBOutlet weak var viewingsCountBorder: UIView!
    @IBOutlet weak var offerCountBorder: UIView!
    @IBOutlet weak var grantedAccessCollectionView: DashboardCollectionView!
    @IBOutlet weak var favourtiesAccessCollectionView: DashboardCollectionView!
    @IBOutlet weak var requestedAccessCollectionView: DashboardCollectionView!
    @IBOutlet weak var viewingsCountLabel: UILabel!
    @IBOutlet weak var enquiriesCountLabel: UILabel!
    @IBOutlet weak var offerCountLabel: UILabel!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: BuyerDashboardViewModel?
    
    fileprivate var selectedBusiness: Business?
    
    // MARK: - Lifecycle
    func attach(to viewModel: BuyerDashboardViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        style()
        
        checkUITags()
        setupCollectionViews()
    }
    
    private func checkUITags() {
        guard grantedAccessCollectionView.tag == 0 else { preconditionFailure("grantedAccessCollectionView 'tag' should be 0.") }
        guard favourtiesAccessCollectionView.tag == 1 else { preconditionFailure("favourtiesAccessCollectionView 'tag' should be 1.") }
        guard requestedAccessCollectionView.tag == 2 else { preconditionFailure("requestedAccessCollectionView 'tag' should be 2.") }
    }
    
    private func setupCollectionViews() {
        grantedAccessCollectionView.delegate = self
        grantedAccessCollectionView.emptyMessage = Lexicon.EmptyState.noGrantedAccessBusinesses
        favourtiesAccessCollectionView.delegate = self
        favourtiesAccessCollectionView.emptyMessage = Lexicon.EmptyState.noFavouritesBusinesses
        requestedAccessCollectionView.delegate = self
        requestedAccessCollectionView.emptyMessage = Lexicon.EmptyState.noRequestedAccessBusinesses
    }
    
    static func instance() -> UINavigationController? {
        guard let instance =  UIStoryboard(name: "BuyersDashboard", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    
    // MARK: - Binding
    func bind(to viewModel: BuyerDashboardViewModel) {
        grantedAccessCollectionView.setContentStream(viewModel.grantedAccessBusinesses)
        favourtiesAccessCollectionView.setContentStream(viewModel.favouriteBusinesses)
        requestedAccessCollectionView.setContentStream(viewModel.requestedAccessBusinesses)
        
        viewingsCountLabel.text = "\(viewModel.viewingsCount)"
        enquiriesCountLabel.text = "\(viewModel.enquiryCount)"
        offerCountLabel.text = "\(viewModel.offerCount)"
    }
    
    // MARK: - Styling
    private func style() {
        navigationItem.titleView = UIImageView(image: UIImage(named: Constants.bizdaqNavLogoImageName))
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
        messageButtonBorder.style(rounded: true)
        styleCountBorders()
    }
    
    private func styleCountBorders() {
        enquiriesCountBorder.style(borderWidth: 2.0, borderColor: UIColor(hex: "D3E8F9"), rounded: true)
        offerCountBorder.style(borderWidth: 2.0, borderColor: UIColor(hex: "D3E8F9"), rounded: true)
        viewingsCountBorder.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressMenuButton(_ sender: UIBarButtonItem) {
        Menu.shared.toggle(sender: view.window)
    }
    
    @IBAction func didPressMessagesButton(_ sender: UIButton) {
        // TODO: Implement navigation to messages
    }
    
    @IBAction func didPressViewingsButton(_ sender: UIButton) {
        navigate(to: .viewings, sender: self)
    }
}

// MARK: - Dashboard Collection View Delegate
extension BuyersDashboardViewController: DashboardCollectionViewDelegate {
    
    func dashboardCollectionView(_ collectionView: DashboardCollectionView, didSelect business: Business) {
        selectedBusiness = business
        navigate(to: .businessDetail, sender: self)
    }
    
    func dashboardCollectionView(_ collectionView: DashboardCollectionView, distanceFromContentEnd: CGFloat, contentWidth: CGFloat) {
        guard distanceFromContentEnd < contentWidth/2 else { return }
        switch collectionView.tag {
        case 0:
            viewModel?.loadNextGrantedAccessBusinessesPage()
        case 1:
            viewModel?.loadNextFavouriteBusinessesPage()
        case 2:
            viewModel?.loadNextRequestedAccessBusinessesPage()
        default:
            return
        }
    }
}

// MARK: - Navigation
extension BuyersDashboardViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case businessDetail
        case messages
        case viewings
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .businessDetail:
            guard let authToken = UserSession.shared.authToken else { preconditionFailure("AuthToken not available.") }
            guard let business = selectedBusiness else { preconditionFailure("Business not defined.") }
            guard let destination = segue.destination as? BusinessDetailsViewController else { preconditionFailure("Invalid destination") }
            destination.attach(to: ViewModelFactory.BusinessBrowse.makeBusinessDetailsModel(authToken: authToken, business: business))
            selectedBusiness = nil
        case .messages:
            guard let destination = segue.destination as? ConversationListViewController else { preconditionFailure("Invalid destination") }
            destination.attach(to: ViewModelFactory.Messages.makeConversationListModel())
        case .viewings:
            guard let authToken = UserSession.shared.authToken else { preconditionFailure("AuthToken not available.") }
            guard let destination = segue.destination as? ViewingsCalendarViewController else { preconditionFailure("Invalid destination") }
            destination.attach(to: ViewModelFactory.Viewings.makeViewingCalendarModel(authToken: authToken))
        }
    }
}

