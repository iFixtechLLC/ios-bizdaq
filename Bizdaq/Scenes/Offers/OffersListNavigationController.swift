//
//  OffersListNavigationController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class OffersListNavigationController: UINavigationController {
    
    // MARK: - Properties
    private var pendingOffersViewController: PendingOffersViewController?
    private var rejectedOffersViewController: RejectedOffersViewController?
    
    weak var tabViewController: OffersListTabViewController?
    
    enum ViewControllerIdentifier: String {
        case pending = "pendingOffersViewController"
        case rejected = "rejectedOffersViewController"
    }
    
    var filter: BusinessSearchFilter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        instantiateViewControllers()
        setViewController(identifier: .pending)
    }
    
    // MARK: - Public Methods
    func setIndex(_ index: Int) {
        var selectedIndex = index
        if selectedIndex < 0 { selectedIndex = 0 }
        if selectedIndex > 1 { selectedIndex = 1 }
        if selectedIndex == 0 {
            setViewController(identifier: .pending)
        } else {
            setViewController(identifier: .rejected)
        }
    }
    
    // MARK: - Private Methods
    private func instantiateViewControllers() {
        let storyboard = UIStoryboard(name: "Offers", bundle: Bundle.main)
        
        pendingOffersViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.pending.rawValue) as? PendingOffersViewController
        pendingOffersViewController?.attach(to: ViewModelFactory.Offers.makePendingOffersModel())
        
        rejectedOffersViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.rejected.rawValue) as? RejectedOffersViewController
        rejectedOffersViewController?.attach(to: ViewModelFactory.Offers.makeRejectedOffersModel())
    }
    
    private func setViewController(identifier: ViewControllerIdentifier) {
        switch identifier {
        case .pending:
            guard let vc = pendingOffersViewController else { break }
            setViewControllers([vc], animated: false)
        case .rejected:
            guard let vc = rejectedOffersViewController else { break }
            setViewControllers([vc], animated: false)
        }
    }
}
