//
//  Utility.swift
//  Bizdaq
//
//  Created by Joseph Lunn on 19/07/2018.
//  Copyright © 2018 Dreamr. All rights reserved.
//

import UIKit

final class Utility {
    static func addPickerView(to textField: UITextField, with button: UIBarButtonItem) -> UIPickerView {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        toolBar.setItems([button], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let pickerView = UIPickerView()
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
        
        return pickerView
    }
}
