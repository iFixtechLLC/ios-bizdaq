//
//  BusinessSearchViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BusinessSearchViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var sectorTextField: ValidatedTextField!
    @IBOutlet weak var locationTextField: ValidatedTextField!
    @IBOutlet weak var browseButton: UIButton!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: BusinessSearchViewModel?

    // MARK: - Lifecycle
    func attach(to viewModel: BusinessSearchViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        setupTextFields()
        style()
        bind()
    }
    
    private func setupTextFields() {
        sectorTextField.setPlaceholder(Lexicon.BusinessFilter.sectorPlaceholder)
        sectorTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        sectorTextField.setRightImage(Theme.Icons.navigationRightArrowGreyIcon)
        locationTextField.setPlaceholder(Lexicon.BusinessFilter.locationPlaceholder)
        locationTextField.setValidationRegex(Constants.Validation.anyCharactersRegex)
        locationTextField.setRightImage(Theme.Icons.navigationRightArrowGreyIcon)
    }
    
    // MARK: - Styling
    private func style() {
        browseButton.style(rounded: true)
    }
    
    // MARK: - Binding
    func bind() {
        sectorTextField.clearedDriver
            .drive(onNext: { [weak self] (_) in
                self?.viewModel?.setSector(nil)
            })
            .disposed(by: bag)
        
        locationTextField.clearedDriver
            .drive(onNext: { [weak self] (_) in
                self?.viewModel?.setLocation(nil)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressDoneButton() {
        navigate(to: .businessBrowse, sender: self)
    }
}

// MARK: - Navigation
extension BusinessSearchViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case businessBrowse
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
            }))
        case .regionSelection:
            guard let destination = segue.destination as? RegionsListViewController else { return }
            destination.attach(to: ViewModelFactory.Selection.makeRegionListModel(selectionHandler: { [weak self] (location) in
                self?.locationTextField.setText(location.name ?? nil)
                guard let id = location.id else { return }
                self?.viewModel?.setLocation(id)
            }))
        case .businessBrowse:
            guard let destination = segue.destination as? BusinessBrowseTabViewController else { return }
            destination.filter = viewModel?.createFilter()
            break
        }
    }
}
