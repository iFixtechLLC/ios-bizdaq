//
//  Popup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit


final class Popup: NSObject {
    
    // MARK: - Properties
    static let shared = Popup()
    private var coveringWindow: UIWindow?
    private var isDisplayed = false
    private let screenFrame = UIScreen.main.bounds
    
    private var backgroundView: UIView?
    private var popupViewContainer: UIView?
    private weak var popupSubview: UIView?
    
    // MARK: - Singleton Lifecycle
    private override init() {
        super.init()
        coveringWindow = self.setupCoveringWindow()
        
        backgroundView = self.setupBackgroundView()
        coveringWindow!.addSubview(backgroundView!)
        
        popupViewContainer = self.setupPopupViewContainer()
        coveringWindow!.addSubview(popupViewContainer!)
    }
    
    private func setupCoveringWindow() -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height))
        window.windowLevel = UIWindowLevelStatusBar - 1
        window.isHidden = false
        return window
    }
    
    private func setupBackgroundView() -> UIView {
        let view = UIView(frame: screenFrame)
        view.alpha = 0.0
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.backgroundColor = .clear
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        
        return view
    }
    
    private func setupPopupViewContainer() -> UIView {
        let view = UIView(frame: screenFrame)
        view.alpha = 0.0
        
        return view
    }
    
    // MARK: - Public Methods
    func setPopupView(_ view: UIView) {
        popupSubview = view
        popupViewContainer?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        popupViewContainer?.addSubview(view)
        view.constrainEdges(to: popupViewContainer!)
    }
    
    func present() {
        if popupSubview != nil {
            UIView.animate(withDuration: TimeInterval(0.3)) {
                self.backgroundView?.alpha = 1.0
                self.popupViewContainer?.alpha = 1.0
            }
            coveringWindow?.isUserInteractionEnabled = true
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: TimeInterval(0.3), animations: {
            self.backgroundView?.alpha = 0.0
            self.popupViewContainer?.alpha = 0.0
        }) { [weak self] (_) in
            self?.popupSubview = nil
        }
        coveringWindow?.isUserInteractionEnabled = false
        coveringWindow?.endEditing(true)

    }
}
