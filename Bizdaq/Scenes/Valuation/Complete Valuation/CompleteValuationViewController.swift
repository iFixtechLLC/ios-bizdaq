//
//  CompleteValuationViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/11/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class CompleteValuationViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var sectorLabel: UILabel!
    @IBOutlet weak var interestCountLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: CreateBusinessValuationResponse?
    
    // MARK: - Lifecycle
    func attach(to viewModel: CreateBusinessValuationResponse) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined") }
        bind(to: viewModel)
    }
    
    // MARK: - Binding
    func bind(to viewModel: CreateBusinessValuationResponse) {
        guard let basicValuation = viewModel.data?.basicBusinessValuation else { return }
        let lowerRange = "£\(basicValuation.estimatedValueLower ?? String())"
        let upperRange = "£\(basicValuation.estimatedValueUpper ?? String())"
        rangeLabel.text = "\(lowerRange) - \(upperRange)"
        
        let sector = DynamicLexicon.Business.sectors?.filter { $0.id == basicValuation.businessSectorId }.first
        sectorLabel.text = "Bizdaq buyers actively looking for \(sector?.name ?? ("N/A")):"
        
        let interestedParties = viewModel.data?.interestedPartiesCount ?? 0
        interestCountLabel.text = "\(interestedParties)"
        
        sectorLabel.isHidden = interestedParties == 0
        interestCountLabel.isHidden = interestedParties == 0
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didPressSellBusinessButton(_ sender: Any) {
        if UserSession.shared.authToken != nil {
            navigate(to: .buildAdvert, sender: self)
        }else{
            navigate(to: .registerSeller, sender: self)

        }
        
    }
}



// MARK: - Navigation
extension CompleteValuationViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case buildAdvert
        case registerSeller
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .buildAdvert:
            guard let destination = segue.destination as? BuildAdvertStepOneViewController else { return }
            destination.attach(to: ViewModelFactory.BuildAdvert.makeBuildAdvertViewModel(advertParameters: nil, isModal: true))
        case .registerSeller:
            guard let registerViewController = segue.destination as? SellerRegisterViewController else { break }
            registerViewController.attach(to: ViewModelFactory.Registration.makeSellerRegistrationModel())
        }
    }
}

