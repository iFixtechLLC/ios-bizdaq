//
//  YourAdvertViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class YourAdvertViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: YourAdvertViewModel?
    
    private enum CellIdentifier: String {
        case advertToolbar = "AdvertToolbarCell"
        case gallery = "GalleryCell"
        case information = "InformationCell"
        case overview = "OverviewCell"
        case propertyTable = "PropertyTableCell"
        case description = "DescriptionCell"
        case map = "MapCell"
    }
    
    private enum Section: Int {
        case advertToolbar = 0
        case gallery
        case information
        case overview
        case propertyTable
        case description
        case map
    }
    
    private let numberOfSections = 1
    private let numberOfRows = 7
    
    // MARK: - Lifecycle
    func attach(to viewModel: YourAdvertViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        registerCells()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: CellIdentifier.advertToolbar.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.advertToolbar.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.gallery.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.gallery.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.information.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.information.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.overview.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.overview.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.propertyTable.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.propertyTable.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.description.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.description.rawValue)
        tableView.register(UINib(nibName: CellIdentifier.map.rawValue, bundle: Bundle.main),
                           forCellReuseIdentifier: CellIdentifier.map.rawValue)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View Data Source & Delegate
extension YourAdvertViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Section.advertToolbar.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.advertToolbar.rawValue,
                                                           for: indexPath) as? AdvertToolbarCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            cell.setEditButtonHandler { [weak self] in
                self?.navigate(to: .editAdvert, sender: self)
            }
            return cell
        case Section.gallery.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.gallery.rawValue,
                                                           for: indexPath) as? GalleryCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.information.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.information.rawValue,
                                                           for: indexPath) as? InformationCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.overview.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.overview.rawValue,
                                                           for: indexPath) as? OverviewCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.propertyTable.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.propertyTable.rawValue,
                                                           for: indexPath) as? PropertyTableCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        case Section.description.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.description.rawValue,
                                                           for: indexPath) as? DescriptionCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            cell.setHandler { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            return cell
        case Section.map.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.map.rawValue,
                                                           for: indexPath) as? MapCell else {
                return UITableViewCell()
            }
            if let business = viewModel?.business { cell.configure(with: business) }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Navigation
extension YourAdvertViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case engagements
        case editAdvert
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .engagements:
            break
        case .editAdvert:
            guard let destination = segue.destination as? UINavigationController else { return }
            guard let viewController = destination.viewControllers.first as? BuildAdvertStepOneViewController else { return }
            guard let business = viewModel?.business else { return }
            let params = AdvertParameters(from: business)
            viewController.attach(to: ViewModelFactory.BuildAdvert.makeBuildAdvertViewModel(advertParameters: params, isModal: true))
        }
    }
}
