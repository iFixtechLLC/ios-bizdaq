//
//  ViewingRequestSentPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 01/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class ViewingRequestSentPopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Properties
    private var dismissHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(dismissButtonHandler: @escaping () -> Void) {
        self.init()
        self.dismissHandler = dismissButtonHandler
    }
    
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        confirmButton.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressDismiss(_ sender: UIButton) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
}


