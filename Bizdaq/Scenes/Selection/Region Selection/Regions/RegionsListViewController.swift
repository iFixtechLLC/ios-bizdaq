//
//  RegionsListViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class RegionsListViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: RegionsListViewModel?
    private var regionSelector: Bool?//or location select as default
    // MARK: - Lifecycle
    func attach(to viewModel: RegionsListViewModel) {
        self.viewModel = viewModel
    }
    func returnRegionOnly(_ regionOnly:Bool = false){
        self.regionSelector = regionOnly
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        setupTable()
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "regionCell")
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
extension RegionsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.regions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "regionCell", for: indexPath) as? CategoryCell {
            cell.titleLabel.text = viewModel!.regions[indexPath.row].name
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setRegion(index: indexPath.row)
        if(viewModel?.regionSelectionHandler != nil){
            guard let selectedRegion = viewModel?.selectedRegion else { return }
            guard (viewModel?.regionSelectionHandler!(selectedRegion)) != nil else { return }
            //IF Simple pop back. Just go back 2 scenes. Otherewise you should handle in the selection handler
            if((viewModel?.simplePopBack)!){
                guard let viewControllers = navigationController?.viewControllers else { return }
                let targetViewController = viewControllers[(viewControllers.count - 1) - 1]
                navigationController?.popToViewController(targetViewController, animated: true)
            }
        }else{
            navigate(to: .selectLocation, sender: self)
        }
    }
}

// MARK: - Navigation
extension RegionsListViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case selectLocation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .selectLocation:
            guard let destination = segue.destination as? LocationListViewController else { return }
            guard let region = viewModel?.selectedRegion else { return }
            
            guard let selectionHandler = viewModel?.selectionHandler else { return }
            destination.attach(to: ViewModelFactory.Selection.makeLocationListModel(region: region, selectionHandler: selectionHandler))
        }
    }
}
