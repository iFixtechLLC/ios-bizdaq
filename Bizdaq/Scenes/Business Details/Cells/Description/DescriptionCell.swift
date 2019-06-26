//
//  OverviewCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 17/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var readFullButton: UIButton!
    @IBOutlet var descriptionLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var showingFullDescription = false
    private var buttonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        readFullButton.style(rounded: true)
        readFullButton.isHidden = !(descriptionLabel.frame.height >= 100)
    }
    
    // MARK: - Private Methods
    private func showFullDescription(_ show: Bool) {
        descriptionLabelHeightConstraint.isActive = !show
    }
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        descriptionLabel.text = business.opportunity ?? Lexicon.BusinessDetail.noValue
    }
    
    func setHandler(_ handler: @escaping () -> Void) {
        buttonHandler = handler
    }
    
    // MARK: - Actions
    @IBAction func didPressReadFullButton() {
        showingFullDescription = !showingFullDescription
        showFullDescription(showingFullDescription)
        buttonHandler?()
    }
}

