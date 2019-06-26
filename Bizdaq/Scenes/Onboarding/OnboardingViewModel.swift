//
//  OnboardingViewModel.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 04/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct OnboardingViewModel {
    
    // MARK: - Properties
    private let storyboard: UIStoryboard
    private var views = [OnboardingPageViewController]()
    
    var viewCount: Int { return views.count }
    var firstViewController: OnboardingPageViewController? {
        return views.first
    }
    
    // Streams
    private let transitionToNextSubject = PublishSubject<Void>()
    private let skipOnboardingSubject = PublishSubject<Void>()
    var transitionToNextDriver: Driver<Void> { return transitionToNextSubject.asDriver(onErrorJustReturn: ()) }
    var skipOnboardingDriver: Driver<Void> { return skipOnboardingSubject.asDriver(onErrorJustReturn: ()) }
    
    // MARK: - Lifecycle
    typealias ViewControllerIdentifiers = [String]
    init(storyboard: UIStoryboard, viewIds: ViewControllerIdentifiers) {
        self.storyboard = storyboard
        self.views = self.viewControllers(for: viewIds)
    }
    
    // MARK: - Public Methods
    func viewController(after viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageViewController else { return nil }
        let newIndex = vc.pageIndex + 1
        guard indexInBounds(newIndex, in: views) else { return nil }
        return views[newIndex]
    }
    
    func viewController(before viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingPageViewController else { return nil }
        let newIndex = vc.pageIndex - 1
        guard indexInBounds(newIndex, in: views) else { return nil }
        return views[newIndex]
    }
    
    func index(for viewController: UIViewController) -> Int? {
        guard let vc = viewController as? OnboardingPageViewController else { return nil }
        return vc.pageIndex
    }
    
    // MARK: - Private Methods
    private func viewControllers(for storyboardIds: ViewControllerIdentifiers) -> [OnboardingPageViewController] {
        var views = [OnboardingPageViewController]()
        for (index, id) in storyboardIds.enumerated() {
            guard let vc = storyboard.instantiateViewController(withIdentifier: id) as? OnboardingPageViewController else {
                fatalError("ID '\(id)' doesn't exist within this storyboard.")
            }
            vc.delegate = self
            vc.attach(to: ViewModelFactory.Onboarding.makeOnboardingPageModel(index: index))
            views.append(vc)
        }
        return views
    }
    
    private func indexInBounds(_ index: Int, in array: [OnboardingPageViewController]) -> Bool {
        if index <= array.count - 1 && index >= 0 { return true } else { return false }
    }
}

// MARK: - OnboardingPageViewControllerDelegate
extension OnboardingViewModel: OnboardingPageViewControllerDelegate {
    func transitionToNextViewController() {
        transitionToNextSubject.onNext(())
    }
    
    func skipOnboarding() {
        skipOnboardingSubject.onNext(())
    }
}
