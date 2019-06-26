//
//  SellerRegisterViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SellerRegisterViewController: RegisterViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: SellerRegisterViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: SellerRegisterViewModel) {
        super.attach(to: viewModel)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    private func register() {
        viewModel!.registerAccount(firstName: firstNameField.textField.text!,
                                   lastName: lastNameField.textField.text!,
                                   mobile: mobileField.textField.text!,
                                   email: emailField.textField.text!,
                                   password: passwordField.textField.text!) { [weak self] (success, error) in
            if success {
                self?.navigate(to: .buildAdvert, sender: self)
                //self?.presentSuccessPopup()
            } else {
                guard let error = error as? HTTPClient.HTTPClientError else { return }
                self?.handle(error: error)
            }
        }
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
    
    private func presentSuccessPopup() {
        let view = SellerRegisterSuccessPopup(
            advertButtonHandler: { [weak self] in
                self?.navigate(to: .buildAdvert, sender: self)
            },
            dashboardButtonHandler: { [weak self] in
                self?.navigate(to: .sellerDashboard, sender: self)
        })
        Popup.shared.setPopupView(view)
        Popup.shared.present()
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
extension SellerRegisterViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case buildAdvert
        case sellerDashboard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
            case .buildAdvert:
                guard let destination = segue.destination as? BuildAdvertStepOneViewController else { return }
                let adParams = AdvertParameters(from: (viewModel?.business)!)
                destination.attach(to: ViewModelFactory.BuildAdvert.makeBuildAdvertViewModel(advertParameters: adParams, isModal: true))
            case .sellerDashboard:
                guard let destination = segue.destination as? SellersDashboardViewController else {
                    debugPrint("ERROR")
                    return
                }
                guard let sellerPublicProfile = UserSession.shared.user?.publicUser.publicUserSellerProfile else { debugPrint("NO PROFILE"); return }
                destination.attach(to: ViewModelFactory.SellersDashboard.makeSellersDashboardViewModel(sellerPublicProfile: sellerPublicProfile))
        }
    }
}
