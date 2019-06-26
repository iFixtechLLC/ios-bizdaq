//
//  DocumentCell.swift
//  Bizdaq
//
//  Created by App Dev on 02/04/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import UIKit

class DocumentCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var imageType: UIImageView!
    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        selectionStyle = .none
    }
}
