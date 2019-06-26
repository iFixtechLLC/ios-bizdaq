//
//  BusinessBrowseTabViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import Segmentio

class BusinessBrowseTabViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentioBar: Segmentio!
    @IBOutlet weak var containerView: BusinessBrowseNavigationController!
    @IBOutlet weak var safeAreaBackgroundView: UIView!
    
    // MARK: - Properties
    private var currentFilter: BusinessSearchFilter?
    private var selectedBusiness: Business?
    private weak var businessBrowseViewController: BusinessBrowseViewController?
    
    var filter: BusinessSearchFilter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        style()
        segmentioBar.valueDidChange = { [weak self] segmentio, segmentIndex in
            self?.containerView.setIndex(segmentIndex)
            self?.safeAreaBackgroundView.backgroundColor = segmentIndex == 0
                ? UIColor(hex: "004F86")
                : UIColor.white
        }
    }
    
    static func instance() -> BusinessBrowseTabViewController? {
        guard let instance = UIStoryboard(name: "BusinessBrowse", bundle: Bundle.main).instantiateInitialViewController() as? BusinessBrowseTabViewController else { return nil }
        return instance
    }
    
    // MARK: - Styling
    private func style() {
        segmentioBar.setupWithTitles([Lexicon.BusinessBrowse.firstTabTitle, Lexicon.BusinessBrowse.secondTableTitle])
        segmentioBar.selectedSegmentioIndex = 0
        navigationItem.titleView = UIImageView(image: UIImage(named: Constants.bizdaqNavLogoImageName))
    }
    
    // MARK: - Public Methods
    func navigateToDetailedView(business: Business) {
        selectedBusiness = business
        navigate(to: .businessDetail, sender: self)
    }
    
    func navigateToFilter(filter: BusinessSearchFilter?, from viewController: BusinessBrowseViewController) {
        currentFilter = filter
        businessBrowseViewController = viewController
        navigate(to: .filter, sender: self)
    }
    
    // MARK: - Actions
    @IBAction func didPressMenuButton(_ sender: UIMenuItem) {
        Menu.shared.toggle(sender: view.window)
    }
}

// MARK: - Navigation
extension BusinessBrowseTabViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case navigator
        case businessDetail
        case filter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .navigator:
            guard let destination = segue.destination as? BusinessBrowseNavigationController else { break }
            destination.tabViewController = self
            destination.filter = filter
            containerView = destination
        case .businessDetail:
            guard let business = selectedBusiness else { preconditionFailure("Business not defined.") }
            guard let destination = segue.destination as? BusinessDetailsViewController else { preconditionFailure("Invalid destination.") }
            destination.attach(to: ViewModelFactory.BusinessBrowse.makeBusinessDetailsModel(authToken: UserSession.shared.authToken, business: business))
            selectedBusiness = nil
        case .filter:
            guard let destination = segue.destination as? BusinessBrowseFilterViewController else { break }
            destination.attach(to: ViewModelFactory.BusinessBrowse.makeBusinessFilterModel(filter: currentFilter))
            currentFilter = nil
            destination.delegate = businessBrowseViewController
            break
        }
    }
}
