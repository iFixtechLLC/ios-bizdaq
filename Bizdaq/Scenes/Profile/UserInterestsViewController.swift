//
//  CategoryListViewController.swift
//  Bizdaq
//
//  Created by Daniel James on 05/03/2018.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import UIKit

class UserInterestsViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    private var viewModel: UserInterestsViewModel?
    
    // MARK: - Lifecycle
    func attach(to viewModel: UserInterestsViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { preconditionFailure("viewModel not defined.") }
        setupTable()
    }
    
    var tempSector:Int?
    
    private func setupTable() {
        tableView.register(UINib(nibName: "InterestArea", bundle: Bundle.main), forCellReuseIdentifier: "interestAreaCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 72

        
    }
    @IBAction func saveBtn(_ sender: Any) {
        save()
    }
    
    // MARK: - Private Methods
    private func save() {
        viewModel?.save()
        guard let viewControllers = navigationController?.viewControllers else { return }
        let targetViewController = viewControllers[(viewControllers.count - 1) - 1]
        navigationController?.popToViewController(targetViewController, animated: true)
    }
}

// MARK: - Table View Delegate & Data Source
extension UserInterestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("COUNT"+String(viewModel!.interests.count))
        return viewModel!.interests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "interestAreaCell", for: indexPath) as? InterestArea {
            cell.regionTextView.text = viewModel!.interests[indexPath.row].businessRegionName
            cell.sectorTextView.text = viewModel!.interests[indexPath.row].businessSectorName
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(removeInterest), for: .touchUpInside)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setInterest(index: indexPath.row)
    }
    
    @objc func removeInterest(sender: UIButton!) {
        self.viewModel?.removeInterest(index: sender.tag)
        self.tableView.reloadData()
    }
    
}

// MARK: - Navigation
extension UserInterestsViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case interestCategorySelection
        case interestRegionSelection
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .interestCategorySelection:
            guard let destination = segue.destination as? CategoryListViewController else { return }
            let categoryViewModel = ViewModelFactory.Selection.makeCategoryListModel(selectionHandler: { [weak self] (sector) in
                self?.tempSector = sector.id ?? nil
                self?.performSegue(withIdentifier: DestinationIdentifier.interestRegionSelection.rawValue, sender: self)
            })
            categoryViewModel.simplePopBack = false
            destination.attach(to: categoryViewModel)
        case .interestRegionSelection:
            guard let destination = segue.destination as? RegionsListViewController else { return }
            destination.attach(to: ViewModelFactory.Selection.makeRegionOnlyListModel(selectionHandler: { [weak self] (location) in
                if(location.id != nil && self?.tempSector != nil){
                    do{
                        try self?.viewModel?.addInterest(interest: InterestTypes.init(sector_id: self?.tempSector, region_id: location.id))
                    } catch {
                        debugPrint(error)
                    }
                }else{
                    debugPrint("I HAVE NO ID?")
                }
                guard let viewControllers = self?.navigationController?.viewControllers else { return }
                let targetViewController = viewControllers[(viewControllers.count - 1) - 3]
                self?.navigationController?.popToViewController(targetViewController, animated: true)
                self?.tableView.reloadData()
            }))
        }
        
    }
}
