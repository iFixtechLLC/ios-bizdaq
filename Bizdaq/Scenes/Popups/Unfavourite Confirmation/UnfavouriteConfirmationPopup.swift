//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class UnfavouriteConfirmationPopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    // MARK: - Properties
    private var removeButtonHandler: (() -> Void)?
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
    
    convenience init(removeButtonHandler: @escaping () -> Void, dismissButtonHandler: @escaping () -> Void) {
        self.init()
        self.removeButtonHandler = removeButtonHandler
        self.dismissHandler = dismissButtonHandler
    }
    
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        removeButton.style(rounded: true)
    }
    
    // MARK: - Public Methods
    func setName(_ name: String) {
        descriptionLabel.text = Lexicon.Favourites.removeConfirmationString(businessName: name)
    }
    
    // MARK: - Actions
    @IBAction func didPressRemoveButton(_ sender: UIButton) {
        removeButtonHandler?()
    }
    
    @IBAction func didPressBackground(_ sender: UIButton) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
}


