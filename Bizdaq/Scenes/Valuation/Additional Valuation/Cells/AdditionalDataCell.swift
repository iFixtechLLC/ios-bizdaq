//
//  AdditionalDataCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class AdditionalDataCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: ValidatedTextField!
    
    // MARK: - Properties
    var key: String?
    
    // MARK: - Public Methods
    func configure(with key: String, title: String) {
        self.key = key
        titleLabel.text = title
        selectionStyle = .none
        valueTextField.setPlaceholder("Choose")
        valueTextField.applyCurrencyStyle()

    }
    
    
}

