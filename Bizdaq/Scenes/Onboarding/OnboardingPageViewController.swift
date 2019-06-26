//
//  OnboardingViewController.swift
//  Go Local
//
//  Created by Joseph Lunn on 19/06/2018.
//  Copyright © 2018 Go Local. All rights reserved.
//

import UIKit

protocol OnboardingPageViewControllerDelegate {
    func transitionToNextViewController()
    func skipOnboarding()
}

final class OnboardingPageViewController: UIViewController, Modelled {
    
    // MARK: - Outlets
    @IBOutlet weak var bottomButton: UIButton!
    
    var delegate: OnboardingPageViewControllerDelegate?
    
    // MARK: - Properties
    var viewModel: OnboardingPageViewModel?
    var pageIndex: Int { return viewModel?.pageIndex ?? 0 }
    
    // MARK: - Lifecycle
    func attach(to viewModel: OnboardingPageViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard viewModel != nil else { fatalError("viewModel not set.") }
        style()
    }
    
    // MARK: - Styling
    private func style() {
        bottomButton.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressSkipButton(_ sender: UIButton) {
        delegate?.skipOnboarding()
    }
    
    @IBAction func didPressBottomButton(_ sender: UIButton) {
        delegate?.transitionToNextViewController()
    }
}
