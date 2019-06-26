//
//  SectorListViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 29/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class SectorListViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: SectorListViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: SectorListViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        setupTable()
        style()
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: "ItemCell", bundle: Bundle.main), forCellReuseIdentifier: "sectorCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    // MARK: - Styling
    private func style() {
        selectButton.style(rounded: true)
    }
    
    // MARK: - Private Methods
    private func popBack() {
        guard let selectedIndex = viewModel?.selectedIndex else { return }
        guard let selectedSector = viewModel?.sectors[selectedIndex] else { return }
        viewModel?.selectionHandler(selectedSector)
        
        //IF Simple pop back. Just go back 2 scenes. Otherewise you should handle in the selection handler
        if((viewModel?.simplePopBack)!){
            guard let viewControllers = navigationController?.viewControllers else { return }
            let targetViewController = viewControllers[(viewControllers.count - 1) - 2]
            navigationController?.popToViewController(targetViewController, animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressSelectButton(_ sender: UIButton) {
        popBack()
    }
}

// MARK: - Table View Delegate & Data Source
extension SectorListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.sectors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "sectorCell", for: indexPath) as? ItemCell {
            cell.titleLabel.text = viewModel!.sectors[indexPath.row].name
            if let selectedIndex = viewModel?.selectedIndex {
                cell.setSelectedState(selectedIndex == indexPath.row)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setSelected(index: indexPath.row)
        tableView.reloadData()
    }
}

