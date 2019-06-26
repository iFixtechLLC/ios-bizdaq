//
//  BusinessBrowseNavigator.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class BusinessBrowseNavigationController: UINavigationController {
    
    // MARK: - Properties
    private var browseViewController: BusinessBrowseViewController?
    private var favouritesViewController: FavouritesViewController?
    
    weak var tabViewController: BusinessBrowseTabViewController?
    
    enum ViewControllerIdentifier: String {
        case browse = "businessBrowseViewController"
        case favourites = "favouritesViewController"
    }
    
    var filter: BusinessSearchFilter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        instantiateViewControllers()
        setViewController(identifier: .browse)
    }
    
    // MARK: - Public Methods
    func setIndex(_ index: Int) {
        var selectedIndex = index
        if selectedIndex < 0 { selectedIndex = 0 }
        if selectedIndex > 1 { selectedIndex = 1 }
        if selectedIndex == 0 {
            setViewController(identifier: .browse)
        } else {
            setViewController(identifier: .favourites)
        }
    }
    
    // MARK: - Private Methods
    private func instantiateViewControllers() {
        let storyboard = UIStoryboard(name: "BusinessBrowse", bundle: Bundle.main)
        
        browseViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.browse.rawValue) as? BusinessBrowseViewController
        browseViewController?.attach(to: ViewModelFactory.BusinessBrowse.makeBusinessBrowseModel(filter: filter))
        if let parent = tabViewController { browseViewController?.tabViewController = parent }
        
        favouritesViewController = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.favourites.rawValue) as? FavouritesViewController
        favouritesViewController?.attach(to: ViewModelFactory.BusinessBrowse.makeFavouritesViewModel(authToken: UserSession.shared.authToken))
        if let parent = tabViewController { favouritesViewController?.tabViewController = parent }
    }
    
    private func setViewController(identifier: ViewControllerIdentifier) {
        switch identifier {
        case .browse:
            guard let vc = browseViewController else { break }
            setViewControllers([vc], animated: false)
        case .favourites:
            guard let vc = favouritesViewController else { break }
            setViewControllers([vc], animated: false)
        }
    }
}
