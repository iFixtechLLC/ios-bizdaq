//
//  ValuationViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

import RxSwift
import RxCocoa
class ValuationViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var typeTextField: ValidatedTextField!
    @IBOutlet weak var tenureSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var annualTurnoverTextField: ValidatedTextField!
    @IBOutlet weak var postcodeTextField: ValidatedTextField!
    @IBOutlet weak var emailAddressTextField: ValidatedTextField!
    @IBOutlet weak var phoneTextField: ValidatedTextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    private var viewModel: ValuationViewModel?
    private var completeValuation: CreateBusinessValuationResponse?
    private let bag = DisposeBag()

    private var widgets: Widgets?
    var isNextButtonActive = false;
    // MARK: - Lifecycle
    func attach(to viewModel: ValuationViewModel) {
        self.viewModel = viewModel
    }
    
    
    static func instance() -> UINavigationController? {
        guard let instance =  UIStoryboard(name: "Valuation", bundle: Bundle.main).instantiateInitialViewController() as? UINavigationController else { return nil }
        return instance
    }
    
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { return }
        bind(to: viewModel)
        style()
        setupTextFields()
        self.hideKeyboardWhenTappedAround() //before Keyboardavoid

        KeyboardAvoiding.avoidingView = scrollView
    }
    
    private func setupTextFields() {
        typeTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        typeTextField.setPlaceholder(Lexicon.Valuation.businessTypePlaceholder)
        tenureSelectionBox.setPlaceholder(Lexicon.Valuation.tenurePlaceholder)
        if let options = DynamicLexicon.PreDefinedChoices.BasicBusinessValuation.tenure {
            tenureSelectionBox.setOptions(Array(options.values))
        }
        annualTurnoverTextField.applyCurrencyStyle()
        postcodeTextField.setValidationRegex(Constants.Validation.postcodeRegex)
        emailAddressTextField.setValidationRegex(Constants.Validation.emailRegex)
        phoneTextField.setValidationRegex(Constants.Validation.mobileRegex)
        phoneTextField.setKeyboardType(.phonePad)
        
    }
    
    // MARK: - Binding
    func bind(to viewModel: ValuationViewModel) {
        viewModel.setTenure(driver: tenureSelectionBox.valueDriver)
        viewModel.setAnnualTurnover(driver: annualTurnoverTextField.valueDriver)
        viewModel.setPostcode(driver: postcodeTextField.valueDriver)
        viewModel.setEmailAddress(driver: emailAddressTextField.valueDriver)
        viewModel.setPhoneNumber(driver: phoneTextField.valueDriver)
        
        
        
        Driver.combineLatest(typeTextField.isValidatedDriver,
                             tenureSelectionBox.isValidatedDriver,
                             annualTurnoverTextField.isValidatedDriver,
                             postcodeTextField.isValidatedDriver,
                             emailAddressTextField.isValidatedDriver,
                             phoneTextField.isValidatedDriver
                             )
            .drive(onNext: { [weak self] (typeValid, tenureValid, turnoverValid, postcodeValid, emailValid, phoneValid) in
                guard let `self` = self else { return }
                self.isNextButtonActive = typeValid && tenureValid && turnoverValid && postcodeValid && emailValid && phoneValid
                self.submitButton.backgroundColor = self.isNextButtonActive
                    ? Theme.UIElements.activeButtonColor
                    : Theme.UIElements.inactiveButtonColor
            })
            .disposed(by: bag)
    }
    
    // MARK: - Styling
    private func style() {
        navigationController?.navigationBar.style()
        setStatusBarStyle(.lightContent)
        submitButton.style(rounded: true)
        typeTextField.setRightImage(Theme.Icons.navigationRightArrowGreyIcon)
    }
    
    // MARK: - Private Methods
    private func startValuation() {
      
        
        viewModel?.requestValuation(completion: { [weak self] (response) in
            if(response == nil){
                print("BAD FORM")
            }else{
                if((response?.data?.widgets) != nil){
                    self?.widgets = response?.data?.widgets
                    self?.navigate(to: .additionalValuation, sender: self)
                }else{
                    self?.completeValuation = response
                    self?.navigate(to: .completeValuation, sender: self)
                }
            }
        })
    }
    
    @IBAction func didPressMenuButton(_ sender: Any) {
        Menu.shared.toggle(sender: view.window)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        debugPrint("BACK")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressSectorIdButton(_ sender: UIButton) {
        navigate(to: .categorySelection, sender: self)
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        if isNextButtonActive {
            startValuation()
        }else{
            //VALIDATE show in red
            typeTextField.showError(revalidate: true)
            tenureSelectionBox.showError(revalidate: true)
            annualTurnoverTextField.showError(revalidate: true)
            postcodeTextField.showError(revalidate: true)
            emailAddressTextField.showError(revalidate: true)
            phoneTextField.showError(revalidate: true)
        }
    }
}

// MARK: - Navigation
extension ValuationViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case categorySelection
        case additionalValuation
        case completeValuation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .categorySelection:
            guard let destination = segue.destination as? CategoryListViewController else { return }
            destination.attach(to: ViewModelFactory.Selection.makeCategoryListModel(selectionHandler: { [weak self] (sector) in
                self?.typeTextField.setText(sector.name ?? nil)
                guard let id = sector.id else { return }
                self?.viewModel?.setSectorId(id)
            }))
        case .additionalValuation:
            guard let valuationProperties = viewModel?.valuationProperties else { return }
            guard let widgets = widgets else { return }
            guard let isFreehold = viewModel?.isFreehold else { return }
            guard let destination = segue.destination as? AdditionalValuationViewController else { return }
            destination.attach(to: ViewModelFactory.Valuation.makeAdditionalValuationModel(authToken: UserSession.shared.authToken, valuationProperties: valuationProperties, widgets: widgets, isFreehold: isFreehold))
        case .completeValuation:
            guard let completeValuation = completeValuation else { preconditionFailure() }
            guard let destination = segue.destination as? CompleteValuationViewController else { preconditionFailure() }
            destination.attach(to: completeValuation)
        }
    }
}

// MARK: - Scroll View Delegate
extension ValuationViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        typeTextField.endEditing(true)
        tenureSelectionBox.endEditing(true)
        annualTurnoverTextField.endEditing(true)
        postcodeTextField.endEditing(true)
        emailAddressTextField.endEditing(true)
        phoneTextField.endEditing(true)
    }
}
