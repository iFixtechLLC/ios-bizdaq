//
//  MakeOfferViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MakeOfferViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var offerAmountTextField: ValidatedTextField!
    @IBOutlet weak var termsTextView: ValidatedTextView!
    @IBOutlet weak var timescaleSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var fundingInPlaceYesButton: UIButton!
    @IBOutlet weak var fundingInPlaceNoButton: UIButton!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: MakeOfferViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: MakeOfferViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Binding
    func bind(to viewModel: MakeOfferViewModel) {
        offerAmountTextField.valueDriver
            .drive(onNext: { (value) in
                guard value != nil else { return }
                if let amount = Int(value!) {
                    viewModel.bidAmount = amount
                }
            })
            .disposed(by: bag)
        
        termsTextView.valueDriver
            .drive(onNext: { (value) in
                guard value != nil else { return }
                if let amount = Int(value!) {
                    viewModel.bidAmount = amount
                }
            })
            .disposed(by: bag)
        
        timescaleSelectionBox.valueDriver
            .drive(onNext: { (value) in
                guard value != nil else { return }
                viewModel.timescale = value!
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressMakeOfferButton(_ sender: UIButton) {
        viewModel?.makeOffer(completion: { (success) in
            // TODO: Confirm success?
        })
    }
}
