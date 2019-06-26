//
//  CustomButtonMessageCell.swift
//  Bizdaq
//
//  Created by App Dev on 26/03/2019.
//  Copyright © 2019 Coherent Software. All rights reserved.
//

import Foundation
import MessageKit
// Customize this collection view cell with data passed in from message, which is of type .custom
open class CustomButtonMessageCell: MessageContentCell {
    open var buttonBarView = UIView()
    open var messageLabel = MessageLabel()
    /// The `MessageCellDelegate` for the cell.
    var approveHandler: ((_ message: Message) -> Void)?
    var denyHandler: ((_ message: Message) -> Void)?
    var withdrawHandler: ((_ message: Message) -> Void)?
    //actionState to decide if approvable done or withdraw needed
    var actionState = true
    var messageObj: Message?
    func setAcceptButtonHandler(_ handler: @escaping ( Message ) -> Void) {
        approveHandler = handler
    }
    func setRejectButtonHandler(_ handler: @escaping ( Message ) -> Void) {
        denyHandler = handler
    }
    func setWithdrawButtonHandler(_ handler: @escaping ( Message ) -> Void) {
        withdrawHandler = handler
    }
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            messageLabel.textInsets = attributes.messageLabelInsets
            messageLabel.font = attributes.messageLabelFont
            messageLabel.frame = messageContainerView.bounds
        }
    }
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        //self.messageContainerView.backgroundColor = UIColor.blue

        buttonBarView.contentMode = .scaleAspectFill
        let parentWidth = self.messageContainerView.frame.width
        let y = self.messageContainerView.frame.height - 4
        let textHeight:CGFloat = 15
        let typeLabel = UILabel(frame: CGRect(x: 10, y: y-textHeight, width: parentWidth-30, height: textHeight))

        switch message.kind {
        case .custom(let m):
            messageObj = m as? Message
            typeLabel.text = (messageObj?.type ?? String.empty) + " Request"
            typeLabel.font = UIFont (name: "HelveticaNeue", size: 15)
            typeLabel.textAlignment = NSTextAlignment.right
            typeLabel.textColor = .darkGray
            buttonBarView.addSubview(typeLabel)
            //debugPrint(messageObj?.content ?? "can't get message object")
        default:
            break;
        }
        if(messageObj?.isActioned != nil){
            if messageObj?.isActioned == false && messageObj?.actionRequired == UserSession.shared.user?.publicUser.id {
                typeLabel.frame = CGRect(x: 10, y: y-60, width: parentWidth-30, height: textHeight)
                
                let approveBtn = UIButton(frame: CGRect(x: 10, y: y-40, width: (parentWidth/2)-20, height: 35))
                approveBtn.backgroundColor = .green
                approveBtn.setTitle("Approve", for: [])
                approveBtn.roundCorners(corners: .allCorners, radius: 4)
                
                let denyBtn = UIButton(frame: CGRect(x: (parentWidth/2)+4, y: y-40, width: (parentWidth/2)-20, height: 35))
                denyBtn.backgroundColor = .red
                denyBtn.setTitle("Deny", for: [])
                denyBtn.roundCorners(corners: .allCorners, radius: 4)
                
                
                buttonBarView.addSubview(approveBtn)
                buttonBarView.addSubview(denyBtn)
                
                
            }
        }
        
        
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
        
        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
            switch message.kind {
            case .text(let text), .emoji(let text):
                let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                messageLabel.text = text
                messageLabel.textColor = textColor
                
            case .attributedText(let text):
                messageLabel.attributedText = text
            case .custom(let messageObj):
                let m = messageObj as! Message
                let text = m.content
                let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                messageLabel.text = String(describing: text!)
                messageLabel.textColor = textColor
            default:
                break
            }
        }
        buttonBarView.isUserInteractionEnabled = true
        messageLabel.isUserInteractionEnabled = true
        //messageContainerView.isUserInteractionEnabled = true
        messageContainerView.addSubview(messageLabel)
        messageContainerView.addSubview(buttonBarView)

    }
    
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }
    open func changeToWithdrawCell(){
        actionState = false
        for v in buttonBarView.subviews{
            //debugPrint(buttonBarView.subviews)
            if v is UIButton{
                v.removeFromSuperview()
            }
        }
        let parentWidth = self.messageContainerView.frame.width
        let y = self.messageContainerView.frame.height - 40
        let withdrawBtn = UIButton(frame: CGRect(x: 10, y: y, width: (parentWidth)-20, height: 35))
        withdrawBtn.backgroundColor = .blue
        withdrawBtn.setTitle("Withdraw", for: [])
        withdrawBtn.roundCorners(corners: .allCorners, radius: 4)
        buttonBarView.addSubview(withdrawBtn)
    }
    
    /// Handle tap gesture on contentView and its subviews.
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        //let message = messageContainerView.subviews[0]
        let buttonBar = messageContainerView.subviews[1]
        if(messageObj?.businessEngagementId == nil){
            debugPrint("NO ENGAGEMENT ID")
            return
        }
        if actionState == true {
            let approveBtn = buttonBar.subviews[0]
            let denyBtn = buttonBar.subviews[1]
            switch true {
            case messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
                delegate?.didTapMessage(in: self)
            //case message.frame.contains(touchLocation):
            //IGNORE message as it is all in the frame and won't get to the buttons.
            case approveBtn.frame.contains(touchLocation):
                approveHandler?(messageObj!)
            case denyBtn.frame.contains(touchLocation):
                denyHandler?(messageObj!)
            default:
                break
            }
        }else{
            let withdrawBtn = buttonBar.subviews[0]
            switch true {
            case messageContainerView.frame.contains(touchLocation) && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
                delegate?.didTapMessage(in: self)
                //case message.frame.contains(touchLocation):
            //IGNORE message as it is all in the frame and won't get to the buttons.
            case withdrawBtn.frame.contains(touchLocation):
                withdrawHandler?(messageObj!)
            default:
                break
            }
        }
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        print("cellContentView tapped")

        return true
    }
}
