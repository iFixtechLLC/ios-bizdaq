//
//  MessagePopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 13/08/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class MessagePopup: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var validatedTextView: ValidatedTextView!
    @IBOutlet weak var ndaAcceptedImageView: UIImageView!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var modalView: UIView!
    // MARK: - Properties
    private var sendMessageButtonHandler: ((_ message: String) -> Void)?
    private var ndaAccepted = false
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(sendMessageButtonHandler: @escaping (_ message: String) -> Void) {
        self.init()
        self.sendMessageButtonHandler = sendMessageButtonHandler
        self.validatedTextView.setPlaceholder(Lexicon.BusinessDetail.messagePlaceholder)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    override func layoutSubviews() {
        style()
    }
    
    // MARK: - Styling
    private func style() {
        sendMessageButton.style(rounded: true)
    }
    
    // MARK: - Actions
    @IBAction func didPressSendMessageButton(_ sender: UIButton)  {
        guard ndaAccepted else { return }
        if sendMessageButtonHandler != nil { sendMessageButtonHandler!(validatedTextView.textView.text) }
    }
    
    @IBAction func didPressBackground(_ sender: UIButton) {
        Popup.shared.dismiss()
    }
    
    @IBAction func didPressNDAButton(_ sender: UIButton) {
        ndaAccepted = !ndaAccepted
        ndaAcceptedImageView.image = ndaAccepted ? UIImage(named: "selected") : UIImage(named: "unselected")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            modalView.frame.origin.y -= keyboardSize.height / 2
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            modalView.frame.origin.y += keyboardSize.height / 2
        }
    }
    
    
    
    
}
