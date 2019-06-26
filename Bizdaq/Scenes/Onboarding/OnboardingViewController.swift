//
//  OnboardingViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 04/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIPageViewController, Modelled, Binds {
    
    // MARK: - Properties
    private var viewModel: OnboardingViewModel?
    private let bag = DisposeBag()
    
    private var pendingPageIndex: Int = 0
    private var pageController: UIPageControl!
    
    // MARK: - Lifecycle
    func attach(to viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        style()
    }
    
    override func viewDidLoad() {
        guard let `viewModel` = viewModel else { preconditionFailure("viewModel not defined.") }
        bind(to: viewModel)
        
        // UIPageViewController Delegation
        self.dataSource = self
        self.delegate = self
        
        // Set initial View Controller
        let vc = viewModel.firstViewController
        setViewControllers([vc!], direction: .reverse, animated: false, completion: nil)
        
        // Add page controller
        let screenFrame = UIScreen.main.bounds
        pageController = UIPageControl(frame: CGRect(x: 0, y: screenFrame.height - 100, width: screenFrame.width, height: 20))
        pageController.pageIndicatorTintColor = Theme.UIElements.pageIndicatorColor
        pageController.currentPageIndicatorTintColor = Theme.UIElements.selectedPageIndicatorColor
        setup(pageController, pageCount: viewModel.viewCount)
        view.addSubview(pageController)
        
        // Add Background
        let screenBounds = UIScreen.main.nativeBounds
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height))
        backgroundView.backgroundColor = UIColor.white
        view.insertSubview(backgroundView, at: 0)
    }
    
    // MARK: - Styling
    private func style() {
        setStatusBarStyle(.default)
    }
    
    // MARK: - Binding
    func bind(to viewModel: OnboardingViewModel) {
        viewModel.transitionToNextDriver
            .drive(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.transitionToNextViewController()
            })
            .disposed(by: bag)
        
        viewModel.skipOnboardingDriver
            .drive(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                self.skipOnboarding()
            })
            .disposed(by: bag)
    }
    
    // MARK: - Setup
    private func setup(_ pageControl: UIPageControl, pageCount: Int) {
        pageControl.numberOfPages = pageCount
        pageControl.currentPage = 0
    }
    
    // MARK: - Private Methods
    private func setCurrentPage(_ index: Int) {
        pageController.currentPage = index
    }
    
    private func transitionToNextViewController() {
        let currentPageIndex = pageController.currentPage
        if currentPageIndex + 1 == viewModel?.viewCount {
            navigate(to: .options, sender: self)
        } else {
            guard let currentViewController = viewControllers?.first as? OnboardingPageViewController else { return }
            guard let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) else { return }
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            pageController.currentPage = currentPageIndex + 1
        }
    }
    
    private func skipOnboarding() {
        navigate(to: .options, sender: self)
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewModel!.viewController(before: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewModel!.viewController(after: viewController)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let pendingViewController = pendingViewControllers.first else { return }
        pendingPageIndex = viewModel?.index(for: pendingViewController) ?? 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed { setCurrentPage(pendingPageIndex) }
    }
}

// MARK: - Navigation
extension OnboardingViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case options
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .options:
            guard let optionsViewController = segue.destination as? NavigationOptionsViewController else { break }
            optionsViewController.show(backButton: false, animated: false)
            show(navigationBar: true, animated: true)
        }
    }
}
