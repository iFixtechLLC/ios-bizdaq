//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

class MessageRequestOptionsPopup: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - Properties
    private var dismissHandler: (() -> Void)?
    private var viewingHandler: (() -> Void)?
    private var offerHandler: (() -> Void)?
    private var docHandler: (() -> Void)?

    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(
        dismissButtonHandler: @escaping () -> Void,
        viewingHandler: @escaping () -> Void,
        offerHandler: @escaping () -> Void,
        docHandler: @escaping () -> Void) {
        self.init()
        self.dismissHandler = dismissButtonHandler
        self.viewingHandler = viewingHandler
        self.offerHandler = offerHandler
        self.docHandler = docHandler

        
    }
    

    func setTitle(_ name: String) {
        titleLabel.text = name
    }

    
    @IBAction func didPressBackground(_ sender: UIButton) {
        dismissHandler?()
        Popup.shared.dismiss()
    }
    @IBAction func didPressRequestViewing(_ sender: Any) {
        Popup.shared.dismiss()
        debugPrint(" request view")
        viewingHandler!()
    }
    
    @IBAction func didPressRequestDoc(_ sender: Any) {
        Popup.shared.dismiss()
        debugPrint("reqs doc")
        docHandler!()
    }
    
    @IBAction func didPressMakeOffer(_ sender: Any) {
        Popup.shared.dismiss()
        debugPrint("offer request")
        offerHandler!()
    }
    
}


