//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class SimpleMessagePopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
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
        removeButton.style(rounded: true)
    }
    func setTitle(_ name: String) {
        titleLabel.text = name
    }
    // MARK: - Public Methods
    func setDescription(_ name: String) {
        descriptionLabel.text = name
    }
    
    // MARK: - Actions
    @IBAction func didPressButton(_ sender: UIButton) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
    
    @IBAction func didPressBackground(_ sender: UIButton) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
}


