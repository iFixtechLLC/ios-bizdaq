//
//  SellerRegisterSuccessPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 15/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class SellerRegisterSuccessPopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var advertButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    
    // MARK: - Properties
    private var advertButtonHandler: (() -> Void)?
    private var dashboardButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(advertButtonHandler: @escaping () -> Void, dashboardButtonHandler: @escaping () -> Void) {
        self.init()
        self.advertButtonHandler = advertButtonHandler
        self.dashboardButtonHandler = dashboardButtonHandler
    }
    
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        advertButton.style(rounded: true)
        dashboardButton.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressAdvertButton(_ sender: UIButton) {
        advertButtonHandler?()
        Popup.shared.dismiss()

    }
    
    @IBAction func didPressDashboardButton(_ sender: UIButton)  {
        dashboardButtonHandler?()
        Popup.shared.dismiss()

    }
}


