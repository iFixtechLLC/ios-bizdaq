//
//  DashboardCollectionEmptyCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 10/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class DashboardCollectionEmptyCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Properties
    static let cellWidth: CGFloat = 242
    static let cellHeight: CGFloat = 241
    
    var emptyMessage: String? {
        didSet { messageLabel.text = emptyMessage ?? String.empty }
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        backgroundCardView?.style(rounded: true)
    }
}
