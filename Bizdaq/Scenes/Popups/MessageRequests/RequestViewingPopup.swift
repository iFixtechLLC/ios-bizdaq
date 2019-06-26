//
//  UnfavouriteConfirmationPopup.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 05/09/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit
import RxSwift

class RequestViewingPopup: UIView {
    
    private var apiClient:APIClient?
    private var authToken:AuthToken?
    private var engagementId:Int?
    private var dismissHandler: (() -> Void)?

    //OUTLETS
    
    @IBOutlet weak var dateTimeTextField1: UITextField!
    @IBOutlet weak var dateTimeTextField2: UITextField!
    @IBOutlet weak var dateTimeTextField3: UITextField!
    let timePicker = UIDatePicker()
    let timePickerView = UIView()
    private var tx: Int?
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var modalView: UIView!
    
    private var date1:String?
    private var date2:String?
    private var date3:String?
    private var time1:String?
    private var time2:String?
    private var time3:String?
    
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

        timePickerView.frame = CGRect(x: 0.0, y: (self.view.frame.height/1.5), width: self.view.frame.width, height: (self.view.frame.height/2))
        
        
        timePicker.datePickerMode = UIDatePickerMode.dateAndTime
        let toolbar = getToolBar(mySelect: #selector(startTimeDiveChanged))
        timePicker.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: (timePickerView.frame.height))
        timePicker.backgroundColor = UIColor.white
        timePickerView.backgroundColor = UIColor.black
        timePickerView.addSubview(timePicker)
        timePickerView.addSubview(toolbar)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func didPressDateButton1(_ sender: Any) {
        tx = 1
        self.view.addSubview(timePickerView)
    }
    
    @IBAction func didPressDateButton2(_ sender: Any) {
        tx = 2
        self.view.addSubview(timePickerView)
    }
    @IBAction func didPressDateButton3(_ sender: Any) {
        tx = 3
        self.view.addSubview(timePickerView)
    }
    
    @IBAction func didPressBackground(_ sender: UIButton) {
        Popup.shared.dismiss()
        dismissHandler?()

    }

    @IBAction func submitForm(_ sender: Any) {
        Popup.shared.dismiss()
        debugPrint("offer request")
        let msg = { (title:String, desc:String) in
            let pum = PopupManager()
            pum.presentSimplePopup(then: {}, title: title, description: desc)
        }
        let disposeBag = DisposeBag()

        apiClient?.createBusinessEngagementViewing(
            authToken: authToken!,
            businessEngagementId: engagementId!,
            dateOption1: date1 ?? "",
            timeStartOption1: time1 ?? "",
            dateOption2:  date2 ?? "",
            timeStartOption2: time2 ?? "",
            dateOption3: date3 ?? "",
            timeStartOption3: time3 ?? "")
            .subscribe(onSuccess: { (response) in
                guard response.success != nil else {
                    msg("Error", "Something went wrong")
                    return
                }
                if response.success! {
                    msg("Success", "You successfully requested a viewing")
                }else{
                    msg("Error", "Something went wrong")
                }
            }, onError: { (error) in
                msg("Error", "Something went wrong:"+error.localizedDescription)
                debugPrint(error)
            }).disposed(by: disposeBag)
        
        
        
        //offerHandler!()
        dismissHandler?()
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date = dateFormat.string(from: timePicker.date)
        dateFormat.dateFormat = "HH:mm"
        let time = dateFormat.string(from: timePicker.date)

        switch tx {
        case 1:
            date1 = date
            time1 = time
            dateTimeTextField1.text = formatter.string(from: timePicker.date)
        case 2:
            date2 = date
            time2 = time
            dateTimeTextField2.text = formatter.string(from: timePicker.date)
        case 3:
            date3 = date
            time3 = time
            dateTimeTextField3.text = formatter.string(from: timePicker.date)
        default:
            debugPrint("FALLTHROUGH")
        }
        timePickerView.removeFromSuperview() // if you want to remove time picker
    }


    @objc func doneDatePickerPressed(){
        debugPrint("DONE ")
        timePickerView.removeFromSuperview() // if you want to remove time picker
        
        
        
    }
    
    
    func getToolBar(mySelect:Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: mySelect)
        doneButton.isEnabled = true
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            modalView.frame.origin.y -= keyboardSize.height / 2
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            modalView.frame.origin.y = modalView.superview?.frame.origin.y ?? (modalView.frame.origin.y + (keyboardSize.height / 2))
        }
    }
    
}



