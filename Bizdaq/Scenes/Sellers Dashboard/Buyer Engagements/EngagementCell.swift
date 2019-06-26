//
//  EngagementCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class EngagementCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var acceptDeclineButtonsContainer: UIView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var withdrawButtonContainer: UIView!
    @IBOutlet weak var withdrawButton: UIButton!
    
    // MARK: - Properties
    private var acceptButtonHandler: (() -> Void)?
    private var declineButtonHandler: (() -> Void)?
    private var withdrawButtonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        acceptButton.style(rounded: true)
        declineButton.style(rounded: true)
        backgroundCardView.style(borderWidth: 1.0, borderColor: Theme.BuyersEngagements.cellBorderColor, rounded: true)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        selectionStyle = .none
    }
    
    // MARK: - Public Methods
    enum State {
        case standard
        case accepted
    }
    func setState(_ state: State) {
        acceptDeclineButtonsContainer.isHidden = (state == .accepted)
        withdrawButtonContainer.isHidden = (state == .standard)
        backgroundCardView.backgroundColor = (state == .accepted)
            ? Theme.BuyersEngagements.cellBorderColor
            : UIColor.white
    }
    
    func configure(with engagement: BusinessEngagement) {
        setState(engagement.isFullDetailsAccessible ?? false ? .accepted : .standard)
        nameLabel.text = engagement.initialBusinessEngagementMessage?.senderData?.username
        descriptionLabel.text = engagement.initialBusinessEngagementMessage?.message?.content
        if let path = engagement.initialBusinessEngagementMessage?.senderData?.photo {
            ImageCache.setImage(for: profileImageView, pathToFile: path, temporaryImage: Theme.Icons.avatarPlaceholderIcon)
        }
    }
    
    func setAcceptButtonHandler(_ handler: @escaping () -> Void) {
        acceptButtonHandler = handler
    }
    
    func setDeclineButtonHandler(_ handler: @escaping () -> Void) {
        declineButtonHandler = handler
    }
    
    func setWithdrawButtonHandler(_ handler: @escaping () -> Void) {
        withdrawButtonHandler = handler
    }
    
    // MARK: - Actions
    @IBAction func didPressAcceptButton(_ sender: UIButton) {
        acceptButtonHandler?()
    }
    
    @IBAction func didPressDeclineButton(_ sender: UIButton) {
        declineButtonHandler?()
    }
    
    @IBAction func didPressWithdrawButton(_ sender: UIButton) {
        withdrawButtonHandler?()
    }
}

