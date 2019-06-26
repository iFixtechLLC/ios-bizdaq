//
//  RegisterPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class RegisterPopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Properties
    private var loginButtonHandler: (() -> Void)?
    private var registerButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(loginButtonHandler: @escaping () -> Void, registerButtonHandler: @escaping () -> Void) {
        self.init()
        self.loginButtonHandler = loginButtonHandler
        self.registerButtonHandler = registerButtonHandler
    }
    
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        loginButton.style(rounded: true)
        registerButton.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        if loginButtonHandler != nil { loginButtonHandler!() }
    }
    
    @IBAction func didPressRegisterButton(_ sender: UIButton)  {
        if registerButtonHandler != nil { registerButtonHandler!() }
    }
    
    @IBAction func didPressBackground(_ sender: UIButton) {
        Popup.shared.dismiss()
    }
}
