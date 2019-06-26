//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class ConfirmMessagePopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - Properties
    private var dismissHandler: (() -> Void)?
    private var goHandler: (() -> Void)?

    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(dismissButtonHandler: @escaping () -> Void, goHandler: @escaping ()-> Void) {
        self.init()
        self.dismissHandler = dismissButtonHandler
        self.goHandler = goHandler
    }
    
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        YesButton.style(rounded: true)
        NoButton.style(rounded: true)

    }
    func setTitle(_ name: String) {
        titleLabel.text = name
    }
    // MARK: - Public Methods
    func setDescription(_ name: String) {
        descriptionLabel.text = name
    }
    
    // MARK: - Actions
    @IBAction func didPressYesButton(_ sender: UIButton) {
        goHandler?()
        Popup.shared.dismiss()
    }
    @IBAction func didPressNoButton(_ sender: Any) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
    
    @IBAction func didPressBackground(_ sender: UIButton) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
}


