//
//  ConversationCell.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 28/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import MessageKit

class ConversationCell: UITableViewCell, Modelled, Binds {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var unreadView: UIView!
    
    // MARK: - Properties
    private var viewModel: Message?
    
    // MARK: - Lifecycle
    func attach(to viewModel: Message) {
        self.viewModel = viewModel
        bind(to: viewModel)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }
    
    // MARK: - Styling
    private func style() {
        profileImageView.layer.cornerRadius = unreadView.frame.size.width / 2
        unreadView.layer.cornerRadius = unreadView.frame.size.width / 2
        selectionStyle = .none
    }
    
    // MARK: - Binding
    func bind(to viewModel: Message) {
        var sender = viewModel.fromPublicUser
        if(viewModel.fromPublicUser?.id == UserSession.shared.user?.publicUser.id){
            sender = viewModel.toPublicUser
        }
        
        
        if let imagePath = sender?.publicUserProfile?.photoPathToFile {
            ImageCache.setImage(for: profileImageView, pathToFile: imagePath, temporaryImage: Theme.Icons.avatarPlaceholderIcon)
        } else {
            profileImageView.image = Theme.Icons.avatarPlaceholderIcon
        }
        let firstname = sender?.firstName ?? String.empty
        let lastname = sender?.lastName ?? String.empty
        nameLabel.text = "\(firstname) \(lastname)"
        messageLabel.text = viewModel.content
        if let timestampString = viewModel.timestamp {
            timestampLabel.text = textForTimestamp(timestampString)
        }
    }
    
    // MARK: - Public Methods
    func setAsRead(_ read: Bool) {
        unreadView.isHidden = !read
    }
    
    func textForTimestamp(_ timestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: timestamp) {
            return MessageKitDateFormatter.shared.string(from: date)
        }
        return timestamp
    }
}
