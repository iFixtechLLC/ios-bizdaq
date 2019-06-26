//
//  AccessCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 14/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class AccessCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var accessView: AccessView!
    
    // MARK: - Properties
    var delegate: AccessViewDelegate? {
        didSet {
            guard delegate != nil else { return }
            accessView.delegate = delegate
        }
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    func configure(with engagement: BusinessEngagement?) {
        if let engagement = engagement {
            accessView.accessState = AccessView.AccessState.accessStateForEngagement(engagement)
        } else {
            accessView.accessState = .noAccess
        }
    }
}
