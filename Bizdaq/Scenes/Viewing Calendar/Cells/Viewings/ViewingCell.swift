//
//  ViewingCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 25/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class ViewingCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var advertImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // MARK: - Properties
    static let id = "ViewingCell"
    
    private var cancelButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        style()
    }
    
    private func style() {
        cellBackgroundView.style(rounded: true)
        advertImageView.style(rounded: true)
        cancelButton.style(rounded: true)
    }
    
    // MARK: - Public Methods
    func setCancelButtonHandler(_ handler: @escaping () -> Void) {
        cancelButtonHandler = handler
    }
    
    func configure(with viewing: BusinessEngagementViewing) {
        headlineLabel.text = viewing.business?.advertHeadline
        locationLabel.text = viewing.business?.businessLocation?.name
        if let businessPhotos = viewing.business?.businessPhotos {
            if let photoPath = businessPhotos.filter({ $0.isPrimary ?? false }).first?.pathToFile {
                ImageCache.setImage(for: advertImageView, pathToFile: photoPath, temporaryImage: Theme.Icons.imagePlaceholderIcon)
            }
        }
    }
    
    // MARK: - Actions
    func didPressCancelButton(_ sender: UIButton) {
        cancelButtonHandler?()
    }
}
