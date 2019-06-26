//
//  WelcomeViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        setStatusBarStyle(.lightContent)
        topButton.style(rounded: true)
        bottomButton.style(borderWidth: 2.0, borderColor: UIColor.white, rounded: true)
        navigationController?.navigationBar.style()
    }
    
    // MARK: - Actions
    @IBAction func didPressTopButton() {
        navigate(to: .onboarding, sender: self)
    }
    
    @IBAction func didPressBottomButton() {
        navigate(to: .login, sender: self)
    }
}

// MARK: - Navigation
extension WelcomeViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case onboarding
        case login
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .onboarding:
            guard let onboardingViewController = segue.destination as? OnboardingViewController else { break }
            onboardingViewController.attach(to: ViewModelFactory.Onboarding.makeOnboardingModel())
        case .login:
            guard let loginViewController = segue.destination as? LoginViewController else { break }
            loginViewController.attach(to: ViewModelFactory.Login.makeLoginModel(modallyPresented: false))
            loginViewController.show(backButton: false, animated: false)
            show(navigationBar: true, animated: false)
        }
    }
}
