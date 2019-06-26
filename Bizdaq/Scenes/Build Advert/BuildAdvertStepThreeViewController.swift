//
//  BuildAdvertStepThreeViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import RxSwift
import RxCocoa

class BuildAdvertStepThreeViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var headlineTextField: ValidatedTextField!
    @IBOutlet weak var businessDescriptionView: ValidatedTextView!
    @IBOutlet weak var extendedDescriptionView: ValidatedTextView!
    @IBOutlet weak var extendedDescriptionYesButton: UIButton!
    @IBOutlet weak var extendedDescriptionNoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var extendedDescView: UIView!
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: BuildAdvertViewModel?
    
    var isNextButtonActive = false
    
    // MARK: - Lifecycle
    func attach(to viewModel: BuildAdvertViewModel)  {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        setupFields()
        bind(to: viewModel)
        
        style()
        setupNavigationBarButtons()
        self.hideKeyboardWhenTappedAround() //before Keyboardavoid
        KeyboardAvoiding.avoidingView = scrollView
    }
    
    private func setupFields() {
        headlineTextField.setPlaceholder(Lexicon.BuildAdvert.headlinePlaceholder)
        headlineTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        businessDescriptionView.setPlaceholder(Lexicon.BuildAdvert.businessDescriptionPlaceholder)
        extendedDescriptionView.setPlaceholder(Lexicon.BuildAdvert.extendedDescriptionPlaceholder)
        
        
        if let headline = viewModel?.advertParameters.advertHeadline {
            headlineTextField.setText(headline)
        }else { return }
        if let opportunity = viewModel?.advertParameters.opportunity {
            businessDescriptionView.setText(opportunity)
        }
        if let property = viewModel?.advertParameters.property {
            extendedDescriptionView.setText(property)
        }
        didPressNoButton("ANY?")
    }
    
    private func setupNavigationBarButtons() {
        guard let viewModel = viewModel else { return }
        if !viewModel.isModal {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - Styling
    private func style() {
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
    }
    
    // MARK: - Binding
    func bind(to viewModel: BuildAdvertViewModel) {
        viewModel.setHeadline(driver: headlineTextField.valueDriver)
        viewModel.setBusinessBriefDescription(driver: businessDescriptionView.valueDriver)
        viewModel.setBusinessDescription(driver: extendedDescriptionView.valueDriver)
        
        Driver.combineLatest(headlineTextField.isValidatedDriver,
                             businessDescriptionView.isValidated)
            .drive(onNext: { [weak self] (headlineValid, descriptionValid) in
                guard let `self` = self else { return }
                self.isNextButtonActive = headlineValid && descriptionValid
                self.nextButton.backgroundColor = self.isNextButtonActive
                    ? Theme.UIElements.activeButtonColor
                    : Theme.UIElements.inactiveButtonColor
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressYesButton(_ sender: UIButton) {
        extendedDescriptionYesButton.setImage(Theme.UIElements.selectedButtonImage, for: .normal)
        extendedDescriptionNoButton.setImage(Theme.UIElements.unselectedButtonImage, for: .normal)
        extendedDescView.isHidden = false
        extendedDescriptionView.setText(viewModel?.advertParameters.property ?? " ")

    }
    
    @IBAction func didPressNoButton(_ sender: Any) {
        extendedDescriptionYesButton.setImage(Theme.UIElements.unselectedButtonImage, for: .normal)
        extendedDescriptionNoButton.setImage(Theme.UIElements.selectedButtonImage, for: .normal)
        
        extendedDescView.isHidden = true
        extendedDescriptionView.setText(viewModel?.advertParameters.property ?? " ")
    }
    
    @IBAction func didPressNextButton(_ sender: UIButton) {
        if isNextButtonActive {
            viewModel?.createAdvert(completion: { [weak self] (success) in
                if success {
                    self?.navigate(to: .addPhotos, sender: self)
                } else {
                    self?.alert(title: Lexicon.universalError, message: Lexicon.universalError, handler: nil)
                }
            })
        }
    }
}

// MARK: - Navigation
extension BuildAdvertStepThreeViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case addPhotos
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .addPhotos:
            guard let destination = segue.destination as? AddPhotosViewController else { return }
            guard let businessId = viewModel?.businessId else { return }
            destination.attach(to: ViewModelFactory.BuildAdvert.makeAddBusinessPhotosModel(businessId: businessId))
        }
    }
}
