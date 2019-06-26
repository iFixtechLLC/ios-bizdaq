//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

class MakeOfferRequestPopup: UIView {

    //OUTLETS
    private var apiClient:APIClient?
    private var authToken:AuthToken?
    private var engagementId:Int?
    @IBOutlet weak var bidAmountField: ValidatedTextField!
    @IBOutlet weak var termsField: ValidatedTextView!
    @IBOutlet weak var timescaleField: ValidatedSelectionBox!
    @IBOutlet weak var isFundedField: ValidatedSelectionBox!
    var originFrame:CGRect?
    @IBOutlet weak var modalView: UIView!
    private var dismissHandler: (() -> Void)?

    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        xibSetup()
    }
    let timescaleOptions = DynamicLexicon.PreDefinedChoices.BusinessEngagementBid.timescale
    
    convenience init(dismissButtonHandler: @escaping () -> Void, apiClient: APIClient?, authToken: AuthToken?, businessEngagementId: Int?) {
        self.init()
        self.apiClient = apiClient
        self.authToken = authToken
        self.engagementId = businessEngagementId
        self.dismissHandler = dismissButtonHandler

        bidAmountField.setImage(Theme.Icons.currencyIcon)
        bidAmountField.setKeyboardType(.numberPad)
        bidAmountField.setValidationRegex(Constants.Validation.integerRegex)
        termsField.setPlaceholder(Lexicon.BuildAdvert.businessDescriptionPlaceholder)
        if let options = timescaleOptions?.values {
            let sorted = options.sorted(by: { (string1, string2) -> Bool in
                let no1 = Int.parse(from: string1)
                let no2 = Int.parse(from: string2)
                return (no1! < no2!)
            })
            timescaleField.setOptions(sorted)
        }
        let fundOptions = ["yes", "no"]
        isFundedField.setOptions(fundOptions)
        originFrame = modalView.frame

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    @IBAction func didPressBackground(_ sender: UIButton) {
        Popup.shared.dismiss()
        self.resignFirstResponder()
        dismissHandler?()
    }

    
    @IBAction func submitForm(_ sender: Any) {
        let isFunding = isFundedField.textField.text
        let bidAmount = Int(bidAmountField.textField.text ?? "0")
        let timescale = DynamicLexicon.getKeyByValue(array: timescaleOptions, value: timescaleField.textField.text)
        if bidAmount == nil {
            bidAmountField.showError(revalidate: true)
            return
        }
        if isFunding == "" {
            isFundedField.showError(revalidate: true)
            return
        }

        Popup.shared.dismiss()
        debugPrint("offer request")
        let msg = { (title:String, desc:String) in
            let pum = PopupManager()
            pum.presentSimplePopup(then: {}, title: title, description: desc)
        }
        let disposeBag = DisposeBag()
        var terms = ""
        termsField.valueDriver.drive(onNext: { (value) in
            terms = value ?? ""
        }).disposed(by: disposeBag)
        //timescaleField.textField.text


        apiClient?.createBusinessEngagementBid(
            authToken: authToken!,
            businessEngagementId: engagementId!,
            bidAmount: bidAmount!,
            terms: terms,
            timescale: timescale,
            isFundingInPlace: isFunding
            ).subscribe(onSuccess: { (response) in
                guard response.success != nil else {
                    msg("Error", "Something went wrong")
                    print("response.success is null")
                    return
                }
                if response.success! {
                    print("response.success is true")
                    msg("Success", "You successfully made an offer")
                }else{
                    print("response.success is true")
                    msg("Error", "Something went wrong")
                }
            }, onError: { (error) in
                msg("Error", "Something went wrong:"+error.localizedDescription)
                debugPrint(error)
            }).disposed(by: disposeBag)
        
        dismissHandler?()

        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //modalView.frame.origin.y -= keyboardSize.height / 2
            modalView.frame.origin.y =  (originFrame?.origin.y)! - (keyboardSize.height / 2)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //modalView.frame.origin.y += keyboardSize.height / 2
            modalView.frame = originFrame!
        }
        print(" KEYBOARD HIDING")
        
    }
}


