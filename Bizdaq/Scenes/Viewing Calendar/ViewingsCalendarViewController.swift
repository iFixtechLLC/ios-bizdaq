//
//  ViewingsCalendarViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 24/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RxSwift
import RxCocoa

class ViewingsCalendarViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: ViewingsCalendarViewModel?
    
    private var viewings = [BusinessEngagementViewing]()
    
    // MARK: - Lifecycle
    func attach(to viewModel: ViewingsCalendarViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined") }
        registerCells()
        bind(to: viewModel)
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: CalendarCell.id, bundle: nil), forCellReuseIdentifier: CalendarCell.id)
        tableView.register(UINib(nibName: ViewingCell.id, bundle: nil), forCellReuseIdentifier: ViewingCell.id)
    }
    
    // MARK: - Binding
    func bind(to viewModel: ViewingsCalendarViewModel) {
        viewModel.viewings
            .drive(onNext: { [weak self] (viewings) in
                self?.viewings = viewings
                self?.countLabel.text = viewings.count == 1
                    ? "\(viewings.count) upcoming viewing"
                    : "\(viewings.count) upcoming viewings"
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Delegate & Data Source
extension ViewingsCalendarViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel!.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCell.id, for: indexPath) as! CalendarCell
            cell.setDates(driver: viewModel!.viewingDates)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewingCell.id, for: indexPath) as! ViewingCell
            cell.configure(with: viewings[indexPath.row - 1])
            return cell
        }
    }
}

