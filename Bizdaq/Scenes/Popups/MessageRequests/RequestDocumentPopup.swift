//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

class RequestDocumentPopup: UIView {
    
    private var apiClient:APIClient?
    private var authToken:AuthToken?
    private var engagementId:Int?
    private var dismissHandler: (() -> Void)?

    // MARK: - Outlets

    @IBOutlet weak var docTypeField: ValidatedSelectionBox!
    let docOptions = DynamicLexicon.PreDefinedChoices.BusinessDocument.type

    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    convenience init(dismissButtonHandler: @escaping () -> Void, apiClient: APIClient?, authToken: AuthToken?, businessEngagementId: Int?) {
        self.init()
        self.apiClient = apiClient
        self.authToken = authToken
        self.engagementId = businessEngagementId
        self.dismissHandler = dismissButtonHandler

        if let options = docOptions?.values {
            docTypeField.setOptions(options.sorted())
        }
        
    }
    


    
    @IBAction func didPressBackground(_ sender: UIButton) {
        Popup.shared.dismiss()
        dismissHandler?()

    }

    
    @IBAction func didPressRequestDoc(_ sender: Any) {
        Popup.shared.dismiss()
        debugPrint("reqs doc")
        let msg = { (title:String, desc:String) in
            let pum = PopupManager()
            pum.presentSimplePopup(then: {}, title: title, description: desc)
        }
        let type = DynamicLexicon.getKeyByValue(array: docOptions, value: docTypeField.textField.text)
        let disposeBag = DisposeBag()

        apiClient?.createBusinessEngagementDocumentRequest(
            authToken: authToken!,
            businessEngagementId: engagementId!,
            type: type,
            year: nil)
            .subscribe(onSuccess: { (response) in
                guard response.success != nil else {
                    msg("Error", "Something went wrong")
                    return
                }
                if response.success! {
                    msg("Success", "You successfully requested a document")
                }else{
                    msg("Error", "Something went wrong")
                }
            }, onError: { (error) in
                msg("Error", "Something went wrong:"+error.localizedDescription)
                debugPrint(error)
            }).disposed(by: disposeBag)

        
    }

    
}


