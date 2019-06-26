//
//  InterestArea.swift
//  Bizdaq
//
//  Created by App Dev on 05/03/2019.
//  Copyright © 2019 Dreamr. All rights reserved.
//

import Foundation

import UIKit

class InterestArea: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var sectorTextView: UITextField!
    @IBOutlet weak var regionTextView: UITextField!

    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        //cellView.style(borderWidth: 1.0, borderColor: Theme.UIElements.defaultBorderColor, rounded: true)
        selectionStyle = .none
    }
    
}
