//
//  AdditionalValuationViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import IHKeyboardAvoiding

class AdditionalValuationViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: AdditionalValuationViewModel?
    
    private var completeValuation: CreateBusinessValuationResponse?
    
    // MARK: - Lifecycle
    func attach(to viewModel: AdditionalValuationViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { return }
        registerCells()
        bind(to: viewModel)
        self.hideKeyboardWhenTappedAround() //before Keyboardavoid
        KeyboardAvoiding.avoidingView = tableView
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "AdditionalDataCell", bundle: Bundle.main), forCellReuseIdentifier: "additionalDataCell")
    }
    
    // MARK: - Styling
    private func style() {
        submitButton.style(rounded: true)
    }
    
    // MARK: - Binding
    func bind(to viewModel: AdditionalValuationViewModel) {
        
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        viewModel?.completeValuation(completion: { [weak self] (valuation) in
            self?.completeValuation = valuation
            self?.navigate(to: .completeValuation, sender: self)
        })
    }
}

// MARK: - Table View Data Source
extension AdditionalValuationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.amountOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "additionalDataCell", for: indexPath) as? AdditionalDataCell else { return UITableViewCell() }
        if let key = viewModel?.keys[indexPath.row] {
            let title = viewModel?.title(for: key) ?? String()
            cell.configure(with: key, title: title)
            cell.valueTextField.valueDriver
                .drive(onNext: { [weak self] (value) in
                    guard let value = value else { return }
                    self?.viewModel?.setValue(value, for: key)
                })
                .disposed(by: bag)
        }
        return cell
    }
}

// MARK: - Navigation
extension AdditionalValuationViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case completeValuation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .completeValuation:
            guard let completeValuation = completeValuation else { preconditionFailure() }
            guard let destination = segue.destination as? CompleteValuationViewController else { preconditionFailure() }
            destination.attach(to: completeValuation)
        }
    }
}
