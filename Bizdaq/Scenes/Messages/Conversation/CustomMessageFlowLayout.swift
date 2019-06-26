
//  CustomMessageFlowLayout.swift
//  Bizdaq
//
//  Created by App Dev on 26/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import MessageKit

open class MyCustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {
    lazy open var customMessageSizeCalculator = CustomMessageSizeCalculator(layout: self)
    
    override open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        if case .custom = message.kind {
            return customMessageSizeCalculator
        }
        return super.cellSizeCalculatorForItem(at: indexPath);
    }
}

open class CustomMessageSizeCalculator: TextMessageSizeCalculator {
    internal func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }
    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
        
        return rect.size
    }
    open override func messageContainerSize(for message: MessageType) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message)
        var messageContainerSize: CGSize
        let attributedText: NSAttributedString
        var additionalHeight:CGFloat = 15
        switch message.kind {
        case .custom(let messageObj):
            let m = messageObj as! Message
            let text = m.content
            attributedText = NSAttributedString(string: String(describing: text!), attributes: [.font: messageLabelFont])
            if(m.isActioned != nil){
                if m.isActioned == false && m.actionRequired == UserSession.shared.user?.publicUser.id {
                    additionalHeight += 45
                }
            }
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
        
        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)
        
        let messageInsets = messageLabelInsets(for: message)
        messageContainerSize.width += (messageInsets.left + messageInsets.right)
        if messageContainerSize.width < 300{
            messageContainerSize.width = 300
        }
        messageContainerSize.height += (messageInsets.top + messageInsets.bottom + additionalHeight)
        
        return messageContainerSize
    }
}
