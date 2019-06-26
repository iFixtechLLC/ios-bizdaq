//
//  Menu.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 21/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class Menu: NSObject {
    
    // MARK: - Properties
    static let shared = Menu()
    
    private var coveringWindow: UIWindow?
    private var isDisplayed = false
    private let screenFrame = UIScreen.main.bounds
    var menuView: MenuView?
    
    // MARK: - Singleton Lifecycle
    private override init() {
        super.init()
        self.setupCoveringWindow()
    }
    
    private func setupCoveringWindow() {
        coveringWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height))
        if let coveringWindow = coveringWindow {
            coveringWindow.windowLevel = UIWindowLevelStatusBar - 1
            coveringWindow.isHidden = true
        }
        if let view = Bundle.main.loadNibNamed("MenuView", owner: self, options: nil)?.first as? MenuView {
            view.frame = CGRect(x: 0, y: 0, width: screenFrame.width, height: screenFrame.height)
            menuView = view
            coveringWindow?.addSubview(menuView!)
        }
        coveringWindow?.isHidden = false
    }
    
    // MARK: - Public Methods
    func toggle(sender: UIWindow? = nil) {
        isDisplayed ? hide() : show(sender: sender)
        isDisplayed = !isDisplayed
    }
    // MARK: - Public Methods
    func reintialise(sender: UIWindow? = nil) {
        Menu.shared.toggle(sender: sender)
        Menu.shared.toggle(sender: sender)
    }
    
    // MARK: - Private Methods
    private func show(sender: UIWindow?) {
        menuView?.appWindow = sender
        menuView?.show()
        menuView?.isUserInteractionEnabled = true
        coveringWindow?.isUserInteractionEnabled = true
    }
    
    private func hide() {
        menuView?.hide()
        menuView?.isUserInteractionEnabled = false
        coveringWindow?.isUserInteractionEnabled = false
    }
}
