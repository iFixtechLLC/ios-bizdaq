//
//  RequestAccessView.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 07/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class RequestAccessView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var messageSellerButton: UIButton!

    // MARK: - Properties
    private var messageButtonHandler: (() -> Void)?
    private var cancelButtonHandler: (() -> Void)?
    static let viewHeight: CGFloat = 180.0
    
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
    
    convenience init(messageButtonHandler: @escaping () -> Void, cancelButtonHandler: @escaping () -> Void) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: RequestAccessView.viewHeight))
        self.messageButtonHandler = messageButtonHandler
        self.cancelButtonHandler = cancelButtonHandler
    }
    
    // MARK: - Styling
    private func style() {
        messageSellerButton.style(rounded: true)

    }
    
    // MARK: - Actions
    @IBAction func didPressMessageButton(_ sender: UIButton) {
        messageButtonHandler?()
    }
    
    @IBAction func didPressCancelButton(_ sender: Any) {
        cancelButtonHandler?()
    }
}
