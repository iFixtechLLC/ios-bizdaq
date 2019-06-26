//
//  OffersListViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import Segmentio

class OffersListTabViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentioBar: Segmentio!
    @IBOutlet weak var containerView: OffersListNavigationController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        style()
        segmentioBar.valueDidChange = { [weak self] segmentio, segmentIndex in
            self?.containerView.setIndex(segmentIndex)
        }
    }
    
    // MARK: - Styling
    private func style() {
        segmentioBar.setupWithTitles([Lexicon.Offers.firstTabTitle, Lexicon.Offers.secondTableTitle])
        segmentioBar.selectedSegmentioIndex = 0
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton(_ sender: UIMenuItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Navigation
extension OffersListTabViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case navigator
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .navigator:
            guard let destination = segue.destination as? OffersListNavigationController else { break }
            destination.tabViewController = self
            containerView = destination
        }
    }
}
