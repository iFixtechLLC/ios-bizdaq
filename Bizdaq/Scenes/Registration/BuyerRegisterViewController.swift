//
//  BuyerRegisterViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BuyerRegisterViewController: RegisterViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var hearAboutUsSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var businessSectorsTableView: MultipleSelectionTableView!
    @IBOutlet weak var businessSectorsTableHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: BuyerRegisterViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: BuyerRegisterViewModel) {
        super.attach(to: viewModel)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        super.viewDidLoad()
        bind(to: viewModel)
        
        hearAboutUsSelectionBox.setOptions(viewModel.hearAboutUsOptions)
        businessSectorsTableView.setOptions(viewModel.businessSectorOptions)
        businessSectorsTableHeightConstraint.constant = businessSectorsTableView.contentHeight
        
        //ignore sectors
        businessSectorsTableView.isHidden = true
        businessSectorsTableHeightConstraint.constant = 0
    }
    
    // MARK: - Binding
    func bind(to viewModel: BuyerRegisterViewModel) {
        viewModel.setHearAboutUs(driver: hearAboutUsSelectionBox.valueDriver)
        viewModel.setSectorIds(driver: businessSectorsTableView.selectedIndicesDriver)
    }
    
    // MARK: - Private Methods
    private func register() {
        viewModel?.registerAccount(success: { [weak self] (success, error) in
            if success {
                self?.navigate(to: .businessBrowse, sender: self)
            } else {
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                self?.handle(error: error)
            }
        })
    }
    
    private func handle(error: HTTPClient.HTTPClientError?) {
        guard let error = error else { alert(message: Lexicon.Error.unknownError, handler: nil); return }
        switch error {
        case .notConnected:
            alert(message: Lexicon.Error.internetConnection, handler: nil)
        default:
            alert(message: Lexicon.Registration.Error.accountExists, handler: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton) {
        if viewModel!.allFieldsValid {
            register()
        }
    }
}
    
// MARK: - Navigation
extension BuyerRegisterViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case businessBrowse
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .businessBrowse:
            break
        }
    }
}
