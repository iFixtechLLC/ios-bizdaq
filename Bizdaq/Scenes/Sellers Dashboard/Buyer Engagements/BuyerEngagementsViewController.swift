//
//  BuyerEngagementsViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 20/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyerEngagementsViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: ValidatedTextField!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: BuyerEngagementsViewModel?
    
    private var engagements = [BusinessEngagement]()
    private var isInteractable = true
    
    // MARK: - Lifecycle
    func attach(to viewModel: BuyerEngagementsViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        style()
        searchTextField.setPlaceholder("Search your buyers...")
        setupTableView()
        registerCells()
        bind(to: viewModel)
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 188
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "EngagementCell", bundle: Bundle.main), forCellReuseIdentifier: "engagementCell")
    }
    
    // MARK: - Styling
    private func style() {
    }
    
    // MARK: - Binding
    func bind(to viewModel: BuyerEngagementsViewModel) {
        viewModel.engagements
            .drive(onNext: { [weak self] (engagements) in
                self?.engagements = engagements
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
        
        searchTextField.valueDriver
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (value) in
                if value?.count ?? 0 > 0 {
                    self?.viewModel?.search(value: value)
                } else {
                    self?.viewModel?.search(value: nil)
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View Data Source & Delegate
extension BuyerEngagementsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engagements.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "engagementCell", for: indexPath) as? EngagementCell else { return UITableViewCell() }
        cell.configure(with: engagements[indexPath.row])
        
        cell.setAcceptButtonHandler { [weak self] in
            guard self?.isInteractable == true else { return }
            guard let engagement = self?.engagements[indexPath.row] else { return }
            self?.isInteractable = false
            self?.viewModel?.accept(engagement: engagement, completion: { (success) in
                self?.isInteractable = true
            })
        }
        cell.setDeclineButtonHandler { [weak self] in
            guard self?.isInteractable == true else { return }
            guard let engagement = self?.engagements[indexPath.row] else { return }
            self?.isInteractable = false
            self?.viewModel?.decline(engagement: engagement, completion: { (success) in
                self?.isInteractable = true
            })
        }
        cell.setWithdrawButtonHandler { [weak self] in
            guard self?.isInteractable == true else { return }
            guard let engagement = self?.engagements[indexPath.row] else { return }
            self?.isInteractable = false
            self?.viewModel?.withdraw(engagement: engagement, completion: { [weak self] (_) in
                self?.isInteractable = true
            })
        }
        
        return cell
    }
}
