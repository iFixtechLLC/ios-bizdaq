//
//  NoAccessView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class NoAccessView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var messageButton: UIButton!
    
    // MARK: - Properties
    private var messageButtonHandler: (() -> Void)?
    static let viewHeight: CGFloat = 171.0
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        style()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        style()
    }
    
    convenience init(messageButtonHandler: @escaping () -> Void) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: NoAccessView.viewHeight))
        self.messageButtonHandler = messageButtonHandler
    }
    
    // MARK: - Styling
    private func style() {
        messageButton.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressMessageButton(_ sender: UIButton) {
        messageButtonHandler?()
    }
}
