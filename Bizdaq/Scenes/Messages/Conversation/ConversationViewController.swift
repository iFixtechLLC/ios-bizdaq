//
//  ConversationViewController.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 09/10/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import MessageKit
import RxSwift
import RxCocoa
import JGProgressHUD
import IHKeyboardAvoiding

class ConversationViewController: MessagesViewController, Modelled, Binds {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    private var viewModel: ConversationViewModel?
    private let progressHUD = JGProgressHUD(style: .dark)
    private var messageInputBarView:MessageInputBar = MessageInputBar()
    
    // MARK: - Lifecycle
    func attach(to viewModel: ConversationViewModel) {
        messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: MyCustomMessagesFlowLayout())
        messagesCollectionView.register(CustomButtonMessageCell.self)
        self.viewModel = viewModel
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = viewModel else { preconditionFailure("viewModel not defined.") }
        messagesCollectionView.messagesDataSource = viewModel
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        bind(to: viewModel)
        
        messageInputBar = setupInputBar()
        messageInputBarView = setupInputBar()
        view.addSubview(messageInputBarView)

        setupConstraints()


        debugPrint("didLoad")
        DispatchQueue.main.async {
            self.progressHUD.parallaxMode = .alwaysOff
            self.progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
            self.progressHUD.show(in: self.view, animated: true)
            self.progressHUD.dismiss(afterDelay: 0.5, animated: true)
        }
    }

    
   override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("didAppear")
        self.becomeFirstResponder()
        messagesCollectionView.contentInset.bottom = 88
        messagesCollectionView.scrollIndicatorInsets.bottom = 88
        self.messagesCollectionView.scrollToBottom(animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardChange(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        //messagesCollectionView.scrollToBottom()
    }
    
    override var disablesAutomaticKeyboardDismissal: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("View disappear")
        viewModel?.stopPolling()
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillChangeFrame, object: nil)
        
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
//    override var inputAccessoryView: UIView? {
//        return messageInputBar
//    }
    
    override var hidesBottomBarWhenPushed: Bool {
        get { return true }
        set {}
    }
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    
    
    func setupConstraints() {
        messageInputBarView.translatesAutoresizingMaskIntoConstraints = false

        for constraint in view.constraints {
            if constraint.secondAttribute == .bottom && constraint.firstAttribute == .bottom {
                
                if ( constraint.firstItem as? UIView == view ) &&
                    ( constraint.secondItem as? UIView == messagesCollectionView ){
                    view.removeConstraint(constraint)

                }
                if ( constraint.secondItem as? UIView == view ) &&
                    ( constraint.firstItem as? UIView == messagesCollectionView ) {
                    view.removeConstraint(constraint)
                }
                
            }
        }
        
        
        
        let messagesBottom = messagesCollectionView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor)

        print(messagesCollectionView.contentOffset)
        print(messagesCollectionView.adjustedContentInset)
        let mesaageInputBarBottom = messageInputBarView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor)
        let messageInputBarLeading = messageInputBarView.safeLeftAnchor.constraint(equalTo: view.safeLeftAnchor)
        let messageInputBarTrailing = messageInputBarView.safeRightAnchor.constraint(equalTo: view.safeRightAnchor)
        let messageInputBarTrailing2 = messageInputBarView.safeRightAnchor.constraint(equalTo: messagesCollectionView.safeRightAnchor)
        NSLayoutConstraint.activate([messagesBottom, mesaageInputBarBottom, messageInputBarLeading, messageInputBarTrailing, messageInputBarTrailing2])
        view.bringSubview(toFront: messageInputBarView)
        view.updateConstraints()

        
        messagesCollectionView.updateConstraints()
        messagesCollectionView.layoutIfNeeded()
        //messagesCollectionView.reloadDataAndKeepOffset()
        print(messagesCollectionView.adjustedContentInset)

        view.layoutIfNeeded()
    }
    
    @objc func handleKeyboardChange(_ notification:Notification){
        print("keyboard active")
        
        guard let keyboardEndFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        print("keyboardEndFrame")
        print(keyboardEndFrame)
        let newBottomInset = keyboardEndFrame.height
        
        let differenceOfBottomInset = newBottomInset - messagesCollectionView.contentInset.bottom
        
        if maintainPositionOnKeyboardFrameChanged && differenceOfBottomInset != 0 {
            let contentOffset = CGPoint(x: messagesCollectionView.contentOffset.x, y: messagesCollectionView.contentOffset.y + differenceOfBottomInset)
            messagesCollectionView.setContentOffset(contentOffset, animated: false)
        }
        
        messagesCollectionView.contentInset.bottom = newBottomInset
        messagesCollectionView.scrollIndicatorInsets.bottom = newBottomInset
        print(messageInputBar.safeAreaInsets)
        
    }
    func setupInputBar() -> MessageInputBar {
       
        let messageInputBar = MessageInputBar()
        
        messageInputBar.delegate = self
        messageInputBar.isTranslucent = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.backgroundView.addShadow(radius: 6.0, offset: CGSize(width: 0, height: -2.0))
        messageInputBar.separatorLine.backgroundColor = .white
        messageInputBar.inputTextView.delegate = self
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 22, left: 22, bottom: 8, right: 42)
        messageInputBar.inputTextView.placeholderLabel.text = "Type your message..."
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 22, left: 16, bottom: 8, right: 42)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.font = UIFont(name: "Helvetica", size: 16.0)
        messageInputBar.inputTextView.style(rounded: true)
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.setRightStackViewWidthConstant(to: 60, animated: false)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 60, height: 60), animated: false)
        messageInputBar.sendButton.title = "SEND"
        messageInputBar.sendButton.style(rounded: true)
        messageInputBar.sendButton.backgroundColor = UIColor(hex: "37424F")
        messageInputBar.sendButton.setTitleColor(UIColor.white, for: .normal)
        messageInputBar.sendButton.setTitleColor(UIColor.white, for: .disabled)
        messageInputBar.sendButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12.0)
        messageInputBar.textViewPadding.right = -38
        //messageInputBar.updateConstraints()
        if viewModel?.amIBuyer() == true {
            messageInputBar.setLeftStackViewWidthConstant(to: 58, animated: false)
            var leftButton = InputBarButtonItem()
            
            leftButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            
            leftButton.onTouchUpInside({ (button) in
                //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
                self.resignFirstResponder()
                self.navigate(to: .requestOptions, sender: leftButton)
                
            })
            leftButton.setSize(CGSize(width: 60, height: 60), animated: false)
            leftButton.title = "Request"
            leftButton.style(rounded: true)
            leftButton.backgroundColor = UIColor(hex: "37424F")
            leftButton.setTitleColor(UIColor.white, for: .normal)
            leftButton.setTitleColor(UIColor.white, for: .disabled)
            leftButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12.0)
            messageInputBar.setStackViewItems([leftButton], forStack: .left, animated: true)
            messageInputBar.isHidden = false
            messageInputBar.isUserInteractionEnabled = true
            //messageInputBar.autoresizingMask = .flexibleHeight
            scrollsToBottomOnKeybordBeginsEditing = true // default false
            maintainPositionOnKeyboardFrameChanged = true // default false
        }
        

        
        return messageInputBar
    }
    
    // MARK: - Binding
    func bind(to viewModel: ConversationViewModel) {
        viewModel.newMessages
            .drive(onNext: { [weak self] (models) in
                if !models.isEmpty {
                    self?.messagesCollectionView.reloadData()
                    self?.messagesCollectionView.scrollToBottom(animated: true)
                }
            })
            .disposed(by: bag)
    }
    
    // MARK: - Actions
    @IBAction func didPressBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func refreshSelector(_ sender: Any) {
        print(self.messagesCollectionView.adjustedContentInset)
        print(self.messageInputBar.intrinsicContentSize)
        print(self.messagesCollectionView.intrinsicContentSize)
        if #available(iOS 12.0, *) {
            print(self.messagesCollectionView.visibleSize)
        }
        print(self.messagesCollectionView.contentSize)

        print(self.messagesCollectionView.adjustedContentInset)

        print(messageInputBar.safeAreaInsets)

        
        
        //self.messageInputBar.inputTextView.becomeFirstResponder()
        //self.reloadInputViews()
    }
    
    
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError("Ouch. nil data source for messages")
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.kind {
        case .custom(let messageAnyObj):
            let messageObj = messageAnyObj as! Message
            
            let cell = messagesCollectionView.dequeueReusableCell(CustomButtonMessageCell.self, for: indexPath)
            
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            cell.setAcceptButtonHandler {_ in
                self.viewModel?.accept(message: messageObj, completion: { (complete) in
                    cell.changeToWithdrawCell()
                })
            }
            cell.setRejectButtonHandler {_ in
                debugPrint("GOT DENY FROM HADNLER!")
            }
            return cell
        default:
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
}

// MARK: - Message InputBar Delegate
extension ConversationViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                viewModel?.postMessage(text: text)
            }
        }
        
        inputBar.inputTextView.text = String()

    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
        messageInputBar.sendButton.setSize(CGSize(width: 58, height: size.height), animated: false)
    }
}

// MARK: - Layout Delegate
extension ConversationViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

// MARK: - MessagesDisplayDelegate
extension ConversationViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return viewModel!.isFromCurrentSender(message: message)
            ? Theme.UIElements.sentMessageTextColor
            : Theme.UIElements.receivedMessageTextColor
    }
    
    // MARK: - All Messages
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return viewModel!.isFromCurrentSender(message: message)
            ? Theme.UIElements.sentMessageBubbleBackground
            : Theme.UIElements.receivedMessageBubbleBackground
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = viewModel!.isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = viewModel!.isFromCurrentSender(message: message) ? Avatar(image: viewModel!.userImage) : Avatar(image: viewModel!.contactImage)
        avatarView.set(avatar: avatar)
    }
}
extension ConversationViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.messageInputBarView.inputTextView {
            self.becomeFirstResponder()
            self.messageInputBar.inputTextView.text = ""
            self.messageInputBar.updateFocusIfNeeded()
            

        }
    }
    
}
// MARK: - Navigation
extension ConversationViewController: Navigator {
    
    enum DestinationIdentifier: String {
        case requestOptions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("🚕 NAVIGATE: \(self.classForCoder) -> \(segue.destination.classForCoder)")
        switch destinationIdentifier(for: segue) {
        case .requestOptions:
            guard let destination = segue.destination as? RequestOptionsViewController else { preconditionFailure() }
            
            print("NEW ONE")
            destination.setViewModel(vm: viewModel!)
            print("NEW ONE")
        }
    }
}
