//
//  BusinessBrowseFilterViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 31/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import TTRangeSlider
import RxSwift
import RxCocoa

protocol BusinessBrowseFilterDelegate: class {
    func didUpdateFilter(_ filter: BusinessSearchFilter)
}

final class BusinessBrowseFilterViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var slider: TTRangeSlider!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var sectorTextField: ValidatedTextField!
    @IBOutlet weak var tenureSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var locationTextField: ValidatedTextField!

    
    //CONSTRAINTS
    @IBOutlet weak var selectSectorCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectSectorWidth: NSLayoutConstraint!

    @IBOutlet weak var selectLocationCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectLocationWidth: NSLayoutConstraint!
    

    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: BusinessBrowseFilterViewModel?
    weak var delegate: BusinessBrowseFilterDelegate?
    
    // MARK: - Lifecycle
    func attach(to viewModel: BusinessBrowseFilterViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        slider.delegate = self
        setupPlaceholders()
        style()
        bind(to: viewModel)
    }

    
    private func setupPlaceholders() {
        sectorTextField.setPlaceholder(Lexicon.BusinessFilter.sectorPlaceholder)
        sectorTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        sectorTextField.setRightImage(Theme.Icons.navigationRightArrowGreyIcon)
        sectorTextField.clearButton.addTarget(self, action: #selector(clearSector), for: .touchUpInside)
        
        tenureSelectionBox.setPlaceholder(Lexicon.BusinessFilter.tenurePlaceholder)
        locationTextField.setPlaceholder(Lexicon.BusinessFilter.locationPlaceholder)
        locationTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        locationTextField.setRightImage(Theme.Icons.navigationRightArrowGreyIcon)
        locationTextField.clearButton.addTarget(self, action: #selector(clearLocation), for: .touchUpInside)
        
    }
    @objc func clearLocation(sender: UIButton!) {
        locationTextField.clearedDriver
                    .drive(onNext: { [weak self] (_) in
                        self?.viewModel?.setLocation(nil)
                        
                        self?.selectLocationCenterXConstraint.constant = 0
                        self?.selectLocationWidth.constant = 0
                    })
                    .disposed(by: bag)
        
    }
    @objc func clearSector(sender: UIButton!) {
        sectorTextField.clearedDriver
            .drive(onNext: { [weak self] (_) in
                self?.viewModel?.setSector(nil)
                self?.selectSectorCenterXConstraint.constant = 0
                self?.selectSectorWidth.constant = 0
            })
            .disposed(by: bag)
        
    }
    // MARK: - Styling
    private func style() {
        slider.handleImage = UIImage(named: "slider_thumb")
        navigationController?.navigationBar.barTintColor = UIColor(named: "bizdaq-dark-blue")
    }
    
    // MARK: - Binding
    internal func bind(to viewModel: BusinessBrowseFilterViewModel) {
        if let sector = viewModel.selectedSectorName {
            sectorTextField.setText(sector)
        }
        if let tenurePickerIndex = viewModel.pickerIndexForTenure() {
            tenureSelectionBox.pickerView.selectRow(tenurePickerIndex, inComponent: 0, animated: false)
            tenureSelectionBox.setText(viewModel.tenureStrings[tenurePickerIndex])
        }
        tenureSelectionBox.setOptions(viewModel.tenureStrings)
        viewModel.setTenure(driver: tenureSelectionBox.valueDriver)
        if let location = viewModel.selectedLocationName {
            locationTextField.setText(location)
        }
        if let price = viewModel.price {
            slider.selectedMinimum = Float(price.min)
            minValueLabel.text = price.min.toCurrency()
            slider.selectedMaximum = Float(price.max)
            maxValueLabel.text = price.max.toCurrency()
        }
        if(viewModel.sectorId != nil){
            selectSectorCenterXConstraint.constant = -25
            selectSectorWidth.constant = -50
        }else{
            selectSectorCenterXConstraint.constant = 0
            selectSectorWidth.constant = 0
        }
        
        if(viewModel.locationId != nil){
            selectLocationCenterXConstraint.constant = -25
            selectLocationWidth.constant = -50
        }else{
            selectLocationCenterXConstraint.constant = 0
            selectLocationWidth.constant = 0
        }
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        if let navigationController = navigationController {
            navigationController.navigationBar.style()
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func didPressApplyFilterButton(_ sender: UIBarButtonItem) {
        if let navigationController = navigationController {
            guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
            delegate?.didUpdateFilter(viewModel.createFilter())
            navigationController.navigationBar.style()
            navigationController.popViewController(animated: true)
        }
    }
}

// MARK: - TTRangeSlider Delegate
extension BusinessBrowseFilterViewController: TTRangeSliderDelegate {
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        minValueLabel.text = Int(selectedMinimum).toCurrency()
        maxValueLabel.text = Int(selectedMaximum).toCurrency()
        viewModel?.setPrice(minPrice: Int(selectedMinimum), maxPrice: Int(selectedMaximum))
    }
}

// MARK: - Navigation
extension BusinessBrowseFilterViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case categorySelection
        case regionSelection
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .categorySelection:
            guard let destination = segue.destination as? CategoryListViewController else { return }
            destination.attach(to: ViewModelFactory.Selection.makeCategoryListModel(selectionHandler: { [weak self] (sector) in
                self?.sectorTextField.setText(sector.name ?? nil)
                guard let id = sector.id else { return }
                self?.viewModel?.setSector(id)
                self?.selectSectorCenterXConstraint.constant = -25
                self?.selectSectorWidth.constant = -50
            }))
        case .regionSelection:
            guard let destination = segue.destination as? RegionsListViewController else { return }
            destination.attach(to: ViewModelFactory.Selection.makeRegionListModel(selectionHandler: { [weak self] (location) in
                self?.locationTextField.setText(location.name ?? nil)
                guard let id = location.id else { return }
                self?.viewModel?.setLocation(id)
                self?.selectLocationCenterXConstraint.constant = -25
                self?.selectLocationWidth.constant = -50
            }))
        }
    }
}
