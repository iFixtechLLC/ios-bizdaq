//
//  SplashViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 03/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController, Modelled, Binds {
    
    // MARK: - Properties
    private var viewModel: SplashViewModel?
    private let bag = DisposeBag()
    
    // MARK: - Lifecycle
    func attach(to viewModel: SplashViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        guard let `viewModel` = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        style()
    }
    
    // MARK: - Styling
    private func style() {
        setStatusBarStyle(.lightContent)
    }
    
    // MARK: - Binding
    func bind(to viewModel: SplashViewModel) {
        viewModel.delaySubject
            .subscribe(onNext: { [weak self] (seconds) in
                self?.triggerDelay(seconds)
            })
            .disposed(by: bag)
    }
    
    // MARK: - Private Methods
    private func triggerDelay(_ seconds: TimeInterval) {
        viewModel?.updateDynamicLexicon(completion: { [weak self] (success) in
            if success {
                self?.viewModel?.delay(for: seconds, completion: {
                    self?.navigateToWelcomeScreen()
                })
            } else {
                self?.showLexiconUpdateError()
            }
        })
    }
    
    private func navigateToWelcomeScreen() {
        let welcomeStoryboard = UIStoryboard(name: "Welcome", bundle: Bundle.main)
        if let navigationController = welcomeStoryboard.instantiateInitialViewController() as? UINavigationController {
            UIApplication.shared.keyWindow?.rootViewController = navigationController
        }
    }
    
    private func showLexiconUpdateError() {
        alert(message: Lexicon.Error.unableToUpdateLexicon, handler: nil)
    }
}

