//
//  MultipleSelectionCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 18/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class MultipleSelectionCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pressedImage: UIImageView!
    
    // MARK: - Properties
    private var isPressed = false {
        didSet {
            pressedImage.image = isPressed ? UIImage(named: "selected") : UIImage(named: "unselected")
        }
    }
    private var handler: ((_ pressed: Bool, _ sender: UITableViewCell) -> Void)?
    
    // MARK: - Public Methods
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func interactionHandler(_ handler: @escaping (_ pressed: Bool, _ sender: UITableViewCell) -> Void) {
        self.handler = handler
    }
    
    // MARK: - Actions
    @IBAction func didPressSelectionButton(_ sender: UIButton) {
        isPressed = !isPressed
        handler?(isPressed, self)
    }
}
