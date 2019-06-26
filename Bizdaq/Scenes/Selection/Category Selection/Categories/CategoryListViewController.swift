//
//  CategoryListViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 29/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: CategoryListViewModel?

    // MARK: - Lifecycle
    func attach(to viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        setupTable()
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "categoryCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View Delegate & Data Source
extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            cell.titleLabel.text = viewModel!.categories[indexPath.row].name
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setCategory(index: indexPath.row)
        navigate(to: .selectSector, sender: self)
    }
}

// MARK: - Navigation
extension CategoryListViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case selectSector
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .selectSector:
            guard let destination = segue.destination as? SectorListViewController else { return }
            guard let category = viewModel?.selectedCategory else { return }
            guard let selectionHandler = viewModel?.selectionHandler else { return }
            let sectorViewModel = ViewModelFactory.Selection.makeSectorListModel(category: category, selectionHandler: selectionHandler)
            sectorViewModel.simplePopBack = viewModel?.simplePopBack
            destination.attach(to: sectorViewModel)
        }
    }
}
