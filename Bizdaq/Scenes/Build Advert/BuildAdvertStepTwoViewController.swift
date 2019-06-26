//
//  BuildAdvertStepTwoViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import RxSwift
import RxCocoa

class BuildAdvertStepTwoViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var annualTurnoverField: ValidatedTextField!
    @IBOutlet weak var netProfitField: ValidatedTextField!
    @IBOutlet weak var hasStaffSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var hasAccomodationSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var yearEstablishedField: ValidatedTextField!
    @IBOutlet weak var askingPriceField: ValidatedTextField!
    @IBOutlet weak var openToOffersYesButton: UIButton!
    @IBOutlet weak var openToOffersNoButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    
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
        annualTurnoverField.setPlaceholder(Lexicon.BuildAdvert.annualTurnoverPlaceholder)
        annualTurnoverField.setImage(Theme.Icons.currencyIcon)
        annualTurnoverField.setKeyboardType(.numberPad)
        annualTurnoverField.setValidationRegex(Constants.Validation.integerRegex)
        
        netProfitField.setPlaceholder(Lexicon.BuildAdvert.netProfitPlaceholder)
        netProfitField.setImage(Theme.Icons.currencyIcon)
        netProfitField.setKeyboardType(.numberPad)
        netProfitField.setValidationRegex(Constants.Validation.integerRegex)
        
        hasStaffSelectionBox.setPlaceholder(Lexicon.BuildAdvert.hasStaffPlaceholder)
        if let options = DynamicLexicon.PreDefinedChoices.Business.hasStaff?.values {
            hasStaffSelectionBox.setOptions(options.sorted().reversed())
        }
        hasAccomodationSelectionBox.setPlaceholder(Lexicon.BuildAdvert.hasStaffPlaceholder)
        if let options = DynamicLexicon.PreDefinedChoices.Business.propertyHasAccomodation?.values {
            hasAccomodationSelectionBox.setOptions(options.sorted().reversed())
        }
        
        
        yearEstablishedField.setPlaceholder(Lexicon.BuildAdvert.yearEstablishedPlaceholder)
        yearEstablishedField.setKeyboardType(.numberPad)
        yearEstablishedField.setValidationRegex(Constants.Validation.yearRegex)
        
        askingPriceField.setPlaceholder(Lexicon.BuildAdvert.askingPricePlaceholder)
        askingPriceField.setImage(Theme.Icons.currencyIcon)
        askingPriceField.setKeyboardType(.numberPad)
        askingPriceField.setValidationRegex(Constants.Validation.integerRegex)
        
        
        //if Edit advert
        guard let annualTurnover = viewModel?.advertParameters.annualTurnover else { return }
        annualTurnoverField.setText(String(annualTurnover))
        guard let netProfit = viewModel?.advertParameters.netProfit else { return }
        netProfitField.setText(String(netProfit))
        guard let yearBusinessEstablished = viewModel?.advertParameters.yearBusinessEstablished else { return }
        yearEstablishedField.setText(String(yearBusinessEstablished))
        guard let askingPrice = viewModel?.advertParameters.askingPrice else { return }
        askingPriceField.setText(String(askingPrice))
        guard let hasStaff = viewModel?.advertParameters.hasStaff else { return }
        hasStaffSelectionBox.setText(DynamicLexicon.PreDefinedChoices.Business.hasStaff?[hasStaff] ?? "")
        guard let propertyHasAccommodaton = viewModel?.advertParameters.propertyHasAccommodaton else { return }
        hasAccomodationSelectionBox.setText(DynamicLexicon.PreDefinedChoices.Business.propertyHasAccomodation?[propertyHasAccommodaton] ?? "")
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
        nextButton.style(rounded: true)
    }
    
    // MARK: - Binding
    func bind(to viewModel: BuildAdvertViewModel) {
        viewModel.setAnnualTurnover(driver: annualTurnoverField.valueDriver)
        viewModel.setNetProfit(driver: netProfitField.valueDriver)
        viewModel.setHasStaff(driver: hasStaffSelectionBox.valueDriver)
        viewModel.setHasAccommodation(driver: hasAccomodationSelectionBox.valueDriver)
        viewModel.setYearEstablished(driver: yearEstablishedField.valueDriver)
        viewModel.setAskingPrice(driver: askingPriceField.valueDriver)
        
        Driver.combineLatest(annualTurnoverField.isValidatedDriver,
                             netProfitField.isValidatedDriver,
                             hasStaffSelectionBox.isValidatedDriver,
                             hasAccomodationSelectionBox.isValidatedDriver,
                             yearEstablishedField.isValidatedDriver,
                             askingPriceField.isValidatedDriver)
            .drive(onNext: { [weak self] (annualTurnoverValid, netProfitValid, hasStaffValid, hasAccomodationValid, yearEstablishedValid, askingPriceValid) in
                guard let `self` = self else { return }
                self.isNextButtonActive = annualTurnoverValid && netProfitValid && hasStaffValid && hasAccomodationValid && yearEstablishedValid && askingPriceValid
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
        if isNextButtonActive { navigate(to: .advertStepThree, sender: self) }
    }
    
    @IBAction func didPressYesButton(_ sender: UIButton) {
        openToOffersYesButton.setImage(Theme.UIElements.selectedButtonImage, for: .normal)
        openToOffersNoButton.setImage(Theme.UIElements.unselectedButtonImage, for: .normal)
        viewModel?.setOpenToOffers(true)
    }
    
    @IBAction func didPressNoButton(_ sender: UIButton) {
        openToOffersYesButton.setImage(Theme.UIElements.unselectedButtonImage, for: .normal)
        openToOffersNoButton.setImage(Theme.UIElements.selectedButtonImage, for: .normal)
        viewModel?.setOpenToOffers(false)
    }
}

// MARK: - Navigation
extension BuildAdvertStepTwoViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case advertStepThree
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .advertStepThree:
            guard let viewModel = viewModel else { return }
            guard let destination = segue.destination as? BuildAdvertStepThreeViewController else { return }
            destination.attach(to: viewModel)
        }
    }
}
