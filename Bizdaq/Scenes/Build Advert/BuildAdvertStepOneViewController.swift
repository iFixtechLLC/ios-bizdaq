//
//  BuildAdvertStepOneViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import RxSwift
import RxCocoa

class BuildAdvertStepOneViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var businessTypeTextField: ValidatedTextField!
    @IBOutlet weak var propertyTypeSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var businessPostcodeTextField: ValidatedTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: BuildAdvertViewModel?
    
    var isNextButtonActive = false
    
    // MARK: - Lifecycle
    static func instance() -> UINavigationController? {
        guard let instance = UIStoryboard(name: "BuildAdvert", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    
    func attach(to viewModel: BuildAdvertViewModel)  {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        setupFields() // setup for edit before initialise
        bind(to: viewModel)
        style()
        setupNavigationBarButtons()
        self.hideKeyboardWhenTappedAround() //before Keyboardavoid
        KeyboardAvoiding.avoidingView = scrollView
        
    }
    
    private func setupFields() {
        businessTypeTextField.setPlaceholder(Lexicon.BuildAdvert.businessTypePlaceholder)
        businessTypeTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        businessTypeTextField.setRightImage(Theme.Icons.navigationRightArrowGreyIcon)
        propertyTypeSelectionBox.setPlaceholder(Lexicon.BuildAdvert.propertyTypePlaceholder)
        if let options = DynamicLexicon.PreDefinedChoices.Business.tenure?.values {
            propertyTypeSelectionBox.setOptions(options.sorted())
        }
        businessPostcodeTextField.setPlaceholder(Lexicon.BuildAdvert.postcodePlaceholder)
        businessPostcodeTextField.setValidationRegex(Constants.Validation.postcodeRegex)
        
        
        //if Edit advert
        guard let sectorId = viewModel?.advertParameters.businessSectorId else { return }
        businessTypeTextField.setText(DynamicLexicon.Business.sectors?[sectorId].name)
        guard let tenureKey = (viewModel?.advertParameters.tenure) else { return }
        propertyTypeSelectionBox.setText(tenureKey)
        guard let postcode = viewModel?.advertParameters.postcode else { return }
        businessPostcodeTextField.setText(postcode)
    }
    
    private func setupNavigationBarButtons() {
        guard viewModel != nil else { return }
        let menuButton = UIBarButtonItem(image: Theme.Icons.menuButtonIcon, style: .plain, target: self, action: #selector(didPressMenuButton))
            navigationItem.leftBarButtonItem = menuButton
            navigationItem.rightBarButtonItem = nil
    }
    
    // MARK: - Styling
    private func style() {
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
        nextButton.style(rounded: true)
    }
    
    // MARK: - Binding
    func bind(to viewModel: BuildAdvertViewModel) {
        viewModel.setBusinessSector(driver: businessTypeTextField.valueDriver)
        viewModel.setTenure(driver: propertyTypeSelectionBox.valueDriver)
        viewModel.setPostcode(driver: businessPostcodeTextField.valueDriver)
        
        Driver.combineLatest(businessTypeTextField.isValidatedDriver,
                             propertyTypeSelectionBox.isValidatedDriver,
                             businessPostcodeTextField.isValidatedDriver)
            .drive(onNext: { [weak self] (businessTypeValid, propertyTypeValid, postcodeValid) in
                guard let `self` = self else { return }
                self.isNextButtonActive = businessTypeValid && propertyTypeValid && postcodeValid
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
    
    @IBAction func didPressNextButton(_ sender: UIButton) {
        if isNextButtonActive { navigate(to: .advertStepTwo, sender: self) }
    }
    
    @objc func didPressMenuButton() {
        Menu.shared.toggle(sender: view.window)
    }
}

// MARK: - Navigation
extension BuildAdvertStepOneViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case advertStepTwo
        case categorySelection
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .categorySelection:
            guard let destination = segue.destination as? CategoryListViewController else { return }
            destination.attach(to: ViewModelFactory.Selection.makeCategoryListModel(selectionHandler: { [weak self] (sector) in
                self?.businessTypeTextField.setText(sector.name ?? nil)
            }))
        case .advertStepTwo:
            guard let viewModel = viewModel else { return }
            guard let destination = segue.destination as? BuildAdvertStepTwoViewController else { return }
            destination.attach(to: viewModel)
        }
    }
}
