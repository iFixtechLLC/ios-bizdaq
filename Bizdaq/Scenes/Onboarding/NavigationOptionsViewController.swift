//
//  NavigationOptionsViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class NavigationOptionsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topButtonView: UIView!
    @IBOutlet weak var middleButtonView: UIView!
    @IBOutlet weak var bottomButtonView: UIView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        setStatusBarStyle(.lightContent)
        let borderColor = Theme.UIElements.defaultBorderColor
        topButtonView.style(borderWidth: 1.0, borderColor: borderColor, rounded: true)
        middleButtonView.style(borderWidth: 1.0, borderColor: borderColor, rounded: true)
        bottomButtonView.style(borderWidth: 1.0, borderColor: borderColor, rounded: true)
    }
}

// MARK: - Navigation
extension NavigationOptionsViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case buyBusiness
        case sellerRegister
        case valuation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .buyBusiness:
            guard let businessSearchViewController = segue.destination as? BusinessSearchViewController else { preconditionFailure("Invalid destination type") }
            businessSearchViewController.attach(to: ViewModelFactory.BusinessSearch.makeBusinessSearchModel())
            businessSearchViewController.show(backButton: false, animated: false)
        case .sellerRegister:
            guard let sellerRegisterViewController = segue.destination as? SellerRegisterViewController else { preconditionFailure("Invalid destination type") }
            sellerRegisterViewController.attach(to: ViewModelFactory.Registration.makeSellerRegistrationModel())
            sellerRegisterViewController.show(backButton: true, animated: false)
        case .valuation:
            guard let valuationViewController = segue.destination as? ValuationViewController else { preconditionFailure("Invalid destination type") }
            valuationViewController.attach(to: ViewModelFactory.Valuation.makeValuationModel(authToken: UserSession.shared.authToken))
            valuationViewController.show(backButton: true, animated: false)
        }
    }
}
