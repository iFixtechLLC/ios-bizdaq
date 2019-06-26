//
//  AdvertToolbarCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class AdvertToolbarCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var engagementCountLabel: UILabel!
    @IBOutlet weak var engagementCountBackground: UIView!
    @IBOutlet weak var engagementButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Properties
    private var engagementsButtonHandler: (() -> Void)?
    private var editButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        engagementButton.style(rounded: true)
        editButton.style(rounded: true)
        engagementCountBackground.layer.cornerRadius = engagementCountBackground.frame.width/2
    }
    
    // MARK: - Public Methods
    func configure(with business: Business) {
        let count = business.enquiryCount ?? 0
        engagementCountLabel.text = "\(count)"
        engagementCountLabel.isHidden = count <= 0
        engagementCountBackground.isHidden = count <= 0
    }
    
    func setEngagementsButtonHandler(_ handler: @escaping () -> Void) {
        engagementsButtonHandler = handler
    }
    
    func setEditButtonHandler(_ handler: @escaping () -> Void) {
        editButtonHandler = handler
    }
    
    // MARK: - Actions
    @IBAction func didPressEngagementsButton(_ sender: UIButton) {
        engagementsButtonHandler?()
    }
    
    @IBAction func didPressEditButton(_ sender: UIButton) {
        editButtonHandler?()
    }
}
