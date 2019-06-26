//
//  RejectedOffersViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RejectedOffersViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK - Properties
    private let bag = DisposeBag()
    private var viewModel: RejectedOffersViewModel?
    
    private var engagementBids = [BusinessEngagementBid]()
    
    // MARK: - Lifecycle
    func attach(to viewModel: RejectedOffersViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        registerCells()
        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "RejectedOfferCell", bundle: Bundle.main), forCellReuseIdentifier: "rejectedOfferCell")
    }
    
    // MARK: - Binding
    func bind(to viewModel: RejectedOffersViewModel) {
        viewModel.engagementBidsDriver
            .drive(onNext: { [weak self] (engagementBids) in
                self?.engagementBids = engagementBids
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }
}

extension RejectedOffersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return engagementBids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rejectedOfferCell", for: indexPath) as? RejectedOfferCell else { return UITableViewCell() }
        cell.configure(with: engagementBids[indexPath.row])
        return cell
    }
}
