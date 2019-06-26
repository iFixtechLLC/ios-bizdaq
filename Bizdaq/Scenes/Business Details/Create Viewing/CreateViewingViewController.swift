//
//  CreateViewingViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class CreateViewingViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var optionOneDateSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var optionOneTimeSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var optionTwoDateSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var optionTwoTimeSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var optionThreeDateSelectionBox: ValidatedSelectionBox!
    @IBOutlet weak var optionThreeTimeSelectionBox: ValidatedSelectionBox!
    
    // MARK: - Properties
    private var viewModel: CreateViewingViewModel?
    
    enum PickerViewTag: Int {
        case optionOneDateSelectionBox = 0
        case optionTwoDateSelectionBox
        case optionThreeDateSelectionBox
        case optionOneTimeSelectionBox
        case optionTwoTimeSelectionBox
        case optionThreeTimeSelectionBox
    }
    
    // MARK: - Lifecycle
    func attach(to viewModel: CreateViewingViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        setupPlaceholders()
        setupDatePicker()
        setupTimePicker()
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
    }
    
    private func setupPlaceholders() {
        optionOneDateSelectionBox.setPlaceholder(Lexicon.BusinessDetail.chooseDatePlaceholder)
        optionOneTimeSelectionBox.setPlaceholder(Lexicon.BusinessDetail.chooseTimePlaceholder)
        optionTwoDateSelectionBox.setPlaceholder(Lexicon.BusinessDetail.chooseDatePlaceholder)
        optionTwoTimeSelectionBox.setPlaceholder(Lexicon.BusinessDetail.chooseTimePlaceholder)
        optionThreeDateSelectionBox.setPlaceholder(Lexicon.BusinessDetail.chooseDatePlaceholder)
        optionThreeTimeSelectionBox.setPlaceholder(Lexicon.BusinessDetail.chooseTimePlaceholder)
    }
    
    private func setupDatePicker() {
        let textFields = [optionOneDateSelectionBox.textField,
                         optionTwoDateSelectionBox.textField,
                         optionThreeDateSelectionBox.textField]
        textFields.enumerated().forEach { (offset, textField) in
            let datePicker = UIDatePicker()
            datePicker.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "en_GB")
            datePicker.tag = offset
            textField?.inputView = datePicker
        }
    }
    
    private func setupTimePicker() {
        let textFields = [optionOneTimeSelectionBox.textField,
                          optionTwoTimeSelectionBox.textField,
                          optionThreeTimeSelectionBox.textField]
        textFields.enumerated().forEach { (offset, textField) in
            let datePicker = UIDatePicker()
            datePicker.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
            datePicker.datePickerMode = .time
            datePicker.locale = Locale(identifier: "en_GB")
            datePicker.tag = 3 + offset
            textField?.inputView = datePicker
        }
    }
    
    // MARK: - Binding
    func bind(to viewModel: CreateViewingViewModel) {
        nameLabel.text = viewModel.name
        locationLabel.text = viewModel.location
        
        viewModel.setOptionOneDate(driver: optionOneDateSelectionBox.valueDriver)
        viewModel.setOptionTwoDate(driver: optionTwoDateSelectionBox.valueDriver)
        viewModel.setOptionThreeDate(driver: optionThreeDateSelectionBox.valueDriver)
        viewModel.setOptionOneTime(driver: optionOneTimeSelectionBox.valueDriver)
        viewModel.setOptionTwoTime(driver: optionTwoTimeSelectionBox.valueDriver)
        viewModel.setOptionThreeTime(driver: optionThreeTimeSelectionBox.valueDriver)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        viewModel?.createViewing(completion: { [weak self] (success) in
            if success {
                self?.viewModel?.popupManager.presentViewingCreatedPopup {
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                self?.alert(title: Lexicon.universalError, message: Lexicon.BusinessDetail.Error.failedToCreateViewing, handler: nil)
            }
        })
    }
    
    @objc func didChangeValue(_ sender: UIDatePicker) {
        switch sender.tag {
        case PickerViewTag.optionOneDateSelectionBox.rawValue:
            optionOneDateSelectionBox.setText(sender.date.toDateStringRepresentation())
        case PickerViewTag.optionTwoDateSelectionBox.rawValue:
            optionTwoDateSelectionBox.setText(sender.date.toDateStringRepresentation())
        case PickerViewTag.optionThreeDateSelectionBox.rawValue:
            optionThreeDateSelectionBox.setText(sender.date.toDateStringRepresentation())
        case PickerViewTag.optionOneTimeSelectionBox.rawValue:
            optionOneTimeSelectionBox.setText(sender.date.toTimeStringRepresentation())
        case PickerViewTag.optionTwoTimeSelectionBox.rawValue:
            optionTwoTimeSelectionBox.setText(sender.date.toTimeStringRepresentation())
        case PickerViewTag.optionThreeTimeSelectionBox.rawValue:
            optionThreeTimeSelectionBox.setText(sender.date.toTimeStringRepresentation())
        default:
            break
        }
    }
}
