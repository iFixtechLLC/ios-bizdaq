//
//  SectorCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 29/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    // MARK: - Properties
    var isSelectedSector = false
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    func setSelectedState(_ selected: Bool) {
        selectedImageView.image = selected ? Theme.Icons.selectedIcon : Theme.Icons.unselectedIcon
    }
}
